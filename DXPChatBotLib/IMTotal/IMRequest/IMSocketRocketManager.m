//
//  IMSocketRocketManager.m
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMSocketRocketManager.h"
#import "NSString+IM.h"
#import "IMConfigSingleton.h"
#import "IMMsgModel.h"
#import "IMChatDBManager.h"
#import "IMCellHeightHelper.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"

#define kRconnectCount 8
#define kRconnectOverTime 5

@interface IMSocketRocketManager() <SRWebSocketDelegate> {
    NSInteger _reconnectCounter;
    NSString *_flowNo;
    NSString *_lastPingTime;
}

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSTimer *pingTimer;   //心跳
@property (nonatomic, strong) NSTimer *reTimer;     //重连

@end

@implementation IMSocketRocketManager

+ (IMSocketRocketManager *)instance {
    static IMSocketRocketManager *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[IMSocketRocketManager alloc] init];
    });
    return Instance;
}

- (void)openSocket:(NSString *)flowNo {
    _flowNo = flowNo;
	NSLog(@"openSocket:flowNo -> %@", flowNo);
    [self p_registerReceiveMessageAPI:flowNo];
    [_socket open];
}

- (void)openSocket {
    [self p_registerReceiveMessageAPI:_flowNo];
    if (_socket) {
        [_socket open];
    }
}

- (void)openSocketTimer {
    [self openSocket:_flowNo];
}

- (void)closeSocket {
    [self closePingTimerSocket];
    [self closeRetimerSocket];
    
    [_socket close];
    _socket.delegate = nil;
    _socket = nil;
}

- (void)closePingTimerSocket {
    [self.pingTimer setFireDate:[NSDate distantFuture]];
    [self.pingTimer invalidate];
    self.pingTimer = nil;
}

- (void)closeRetimerSocket {
    [self.reTimer setFireDate:[NSDate distantFuture]];
    [self.reTimer invalidate];
    self.reTimer = nil;
}

- (void)p_registerReceiveMessageAPI:(NSString *)flowNo
{
    NSString * urlStr = [NSString stringWithFormat: @"%@flowNo=%@&os=IOS&appVersion=%@",[IMConfigSingleton sharedInstance].IMSocketURL, flowNo, app_Version_IM];
	NSLog(@"SRWebSocket  initWithURLRequest   urlStr -> %@", urlStr);
    _socket = [[SRWebSocket alloc]initWithURLRequest:
               [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _socket.delegate = self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeSocket];
}

#pragma mark - sokect delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
	NSLog(@"websocket connected...");
    _reconnectCounter = 0;
    _lastPingTime = @"";
    //开始心跳
    self.pingTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.pingTimer forMode:NSRunLoopCommonModes];
    [self.pingTimer setFireDate:[NSDate distantPast]];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    if (![message JSONValue] && [message rangeOfString:@"pong"].location != NSNotFound) {
		NSLog(@"----------心跳,跳起来----------");
        _lastPingTime = [NSString getCurrentTimestamp];
        return;
    }
    
    NSArray *messages = [[message JSONValue] objectForKey:@"msg"];
    if (messages && [messages isKindOfClass:[NSArray class]]) {
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];
        for (NSDictionary *msgDic in messages) {
            if (![msgDic isKindOfClass:[NSNull class]]) {
                NSLog(@"msgDic:%@",msgDic);
                IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:msgDic];
                NSInteger isNeedHelpful = [[NSString imStringWithoutNil:[msgDic objectForKey:@"needHelpful"]] integerValue];
                if (isNeedHelpful) {
                    model.needHelpful = YES;
                } else {
                    model.needHelpful = NO;
                }
                if (model.msgType == IMMsgContentType_commonQuestion || model.msgType == IMMsgContentType_disLike || model.msgType == IMMsgContentType_quickQuesttion) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveQuestions object:model];
                } else {
                    if ([model.sessionState isEqualToString:@"S"] || [model.sessionState isEqualToString:@"Q"]) {
                        [IMConfigSingleton sharedInstance].sessionS = YES;
                        if (![NSString isIMBlankString:model.messageId]) {
                            [_socket send:[NSString dictionaryToJson:@{@"f":@"ack",@"id":model.messageId}]];
                        }
                        
                    } else {
                        [IMConfigSingleton sharedInstance].sessionS = NO;
                    }
                    model.cellHeight = [IMCellHeightHelper getCellHeight:model];
                    if (model.msgType == IMMsgContentType_typing) {
                        // 判断正在输入状态
                    } else if (model.msgType == IMMsgContentType_seen) {
                        // 已读未读
                        if ([model.status isEqualToString:@"B"]) {
                            for (int i = 0; i< [model.msgIdList count]; i++) {
                                NSString *msgId = [model.msgIdList objectAtIndex:i];
                                NSLog(@"msgId:%@",msgId);
                                [IMChatDBManager updateSeenWithUserId:[IMConfigSingleton sharedInstance].userId msgSeenId:msgId isSeen:YES];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationRefrashChatArray object:model.msgIdList];
                        }
                        return;
                    } else {
                        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
                    }
                    [newMessages addObject:model];
                }
                // 判断是否helpful
                if (model.needHelpful) {
                    // 构建helpful 消息model
                    NSDictionary *contentDic = @{@"contentType":@"6",@"header":@"Was the information helpful?",@"menu":@[@{@"title":@"No",@"content":@"webchat://N"},@{@"title":@"Yes",@"content":@"webchat://Y"}]};
                    
                    NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
                    NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C",@"msgId":model.msgId, @"messageId":model.messageId} mutableCopy];
                    [fullDic setObject:dicString forKey:@"mainInfo"];
                    // 计算mode cell的高度
                    NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
                    NSString *title = [mainInfoDic objectForKey:@"header"];
                    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
                    //                    NSArray *array = [mainInfoDic objectForKey:@"menu"];
                    
                    // helpful model
                    IMMsgModel *helpfulModel = [[IMMsgModel alloc] initWithMsgDic:fullDic];
                    helpfulModel.showHelpful = YES;
                    helpfulModel.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
                    helpfulModel.msgType = IMMsgContentType_linkList;
                    helpfulModel.createType = IMMsgCreateType_server;
                    [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:helpfulModel];
                    [newMessages addObject:helpfulModel];
                }
            }
        }
        if (newMessages.count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
	NSLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
	NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
	NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
	NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。或者每隔1，2，4，8，10，10秒重连...f(x) = f(x-1) * 2, (x=5)");
    [self closeSocket];
    [self socketReconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
	NSLog(@"断开连接，清空相关数据");
//    _socket.delegate = nil;
//    _socket = nil;
    [self closeSocket];
    [self socketReconnect];
}

- (void)socketReconnect {
    // 计数+1
    if (_reconnectCounter < kRconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kRconnectOverTime target:self selector:@selector(openSocket) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.reTimer = timer;
    } else{
		NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.reTimer) {
            [self closeRetimerSocket];
        }
        return;
    }
}

- (void)sendPing {
//    [_socket sendPing:nil];
//    [_socket send:@"ping"];
    
    if (![NSString isIMBlankString:_lastPingTime]) {
        NSInteger seconde = [[NSString getCurrentTimestamp] integerValue] - [_lastPingTime integerValue] > 20;
        if (seconde/1000 > 20) {
            [self closeSocket];
            [self socketReconnect];
        }
    }
}

//#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
//- (void)sendData:(id)data {
//    HJLog(@"发送socket数据:%@",data);
//
//    WeakSelf(ws);
//    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
//
//    dispatch_async(queue, ^{
//        if (weakSelf.socket != nil) {
//            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
//            if (weakSelf.socket.readyState == SR_OPEN) {
//                [weakSelf.socket send:data];    // 发送数据
//            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
//                HJLog(@"正在连接中，重连后其他方法会去自动同步数据");
//                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
//                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
//                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
//                // 代码有点长，我就写个逻辑在这里好了
//                [self socketReconnect];
//            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
//                // websocket 断开了，调用 reConnect 方法重连
//                HJLog(@"重连");
//                [self socketReconnect];
//            }
//        } else {
//            HJLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
//        }
//    });
//}

@end
