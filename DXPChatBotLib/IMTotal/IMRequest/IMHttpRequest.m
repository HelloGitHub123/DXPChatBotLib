//
//  IMHttpRequest.m
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMHttpRequest.h"
#import "IMAppDotNetAPIClient.h"
#import "IMConfigSingleton.h"
#import "NSString+IM.h"
#import "IMClientChatUtil.h"
#import <YYModel/YYModel.h>
#import "NSString+IM.h"

@implementation IMHttpRequest

+ (void)beginSessionWithUserAcct:(NSString *)userAcct accNbr:(NSString *)accNbr acData:(NSString *)acData createTime:(NSString *)createTime custId:(NSString *)custId isRestart:(NSString *)isRestart firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber birthday:(NSString *)birthday block:(void (^)(NSString *flowNo, NSError *error))block {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (![NSString isIMBlankString:userAcct]) [param setObject:userAcct forKey:@"userAccount"];
    if (![NSString isIMBlankString:accNbr]) [param setObject:accNbr forKey:@"accNbr"];
    if (![NSString isIMBlankString:acData]) [param setObject:acData forKey:@"acdata"];
    if (![NSString isIMBlankString:custId]) [param setObject:custId forKey:@"custId"];
    [param setObject:createTime forKey:@"createTime"];
    [param setObject:[IMConfigSingleton sharedInstance].langCode forKey:@"langCode"];
    // 如果等于Y,则重启sessions
    if (![NSString isIMBlankString:isRestart]) [param setObject:isRestart forKey:@"restartSession"];
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:custId]?@"":custId forHTTPHeaderField:@"custId"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:accNbr]?@"":accNbr forHTTPHeaderField:@"accNbr"];
    // 用户资料
    [manager.requestSerializer setValue:[NSString isIMBlankString:firstName]?@"":firstName forHTTPHeaderField:@"firstName"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:lastName]?@"":lastName forHTTPHeaderField:@"lastName"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:emailAddress]?@"":emailAddress forHTTPHeaderField:@"email"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:phoneNumber]?@"":phoneNumber forHTTPHeaderField:@"phoneNumber"];
    [manager.requestSerializer setValue:[NSString isIMBlankString:birthday]?@"":birthday forHTTPHeaderField:@"birthday"];
    // app 版本号
    [manager.requestSerializer setValue:app_Version_IM forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"os"];
    
    [manager POST:@"sessions/begin" parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *flowNo = [responseObject objectForKey:@"flowNo"];
        if (![NSString isIMBlankString:flowNo]) if (block) block(flowNo, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求sessions/begin---error :%@", error);
        if (block) block(nil, error);
    }];
}

+ (void)sendMessage:(NSString *)message flowNo:(NSString *)flowNo createTime:(NSString *)createTime msgType:(NSInteger)msgType block:(void (^)(NSError *error, NSString *msgSeenId))block {
    if ([NSString isIMBlankString:flowNo]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:flowNo forKey:@"flowNo"];
    [param setObject:@(msgType) forKey:@"msgType"];
    [param setObject:message forKey:@"mainInfo"];
    [param setObject:createTime forKey:@"createTime"];
    [param setObject:[IMConfigSingleton sharedInstance].langCode forKey:@"langCode"];
    // 新增MsgId 作为已读未读消息
    NSString *msgSeenId = [NSString stringWithFormat:@"%@-%@", [IMClientChatUtil getNowTimeTimestamp3], [NSUUID UUID].UUIDString];
    [param setObject:msgSeenId forKey:@"msgId"];
    NSLog(@"发送的消息内容是:%@,msgSeedId是:%@", message, msgSeenId);
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    
    [manager POST:@"messages" parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) block(nil, msgSeenId);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求messages---error :%@", error);
        if (block) block(error, nil);
    }];
}

+ (void)sendImage:(NSString *)message flowNo:(NSString *)flowNo createTime:(NSString *)createTime block:(void (^)(NSError *error))block {
    if ([NSString isIMBlankString:flowNo]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:flowNo forKey:@"flowNo"];
    [param setObject:@(IMMsgContentType_image) forKey:@"msgType"];
    [param setObject:message forKey:@"mainInfo"];
    [param setObject:createTime forKey:@"createTime"];
    [param setObject:@"png" forKey:@"fileType"];
    [param setObject:[IMConfigSingleton sharedInstance].langCode forKey:@"langCode"];
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    
    [manager POST:@"messages" parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) block(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求messages---error :%@", error);
        if (block) block(error);
    }];
}

+ (void)postHttpUrl:(NSString *)url param:(NSDictionary *)param block:(void (^)(id responseObject ,NSError *error))block {
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    [manager.requestSerializer setValue:[IMConfigSingleton sharedInstance].custId forHTTPHeaderField:@"custId"];
    [manager.requestSerializer setValue:[IMConfigSingleton sharedInstance].accNbr forHTTPHeaderField:@"accNbr"];
    
    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求---error :%@", error);
        if (block) block(nil, error);
    }];
}

/* 结束会话 */
+ (void)endSessionByFlowNo:(NSString *)flowNo block:(void (^)(NSError *error))block {
    if ([NSString isIMBlankString:flowNo]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (![NSString isIMBlankString:flowNo]) [param setObject:flowNo forKey:@"flowNo"];
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    
    NSString *url = [NSString stringWithFormat:@"sessions/%@/end",flowNo];
    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) block(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求session/end---error :%@", error);
        if (block) block(error);
    }];
    
}

// 每当点 Yes 后校验 VOIP 请求是否有效
+ (void)checkVoipValidityByFlowNo:(NSString *)flowNo voipAgentId:(NSString *)voipAgentId block:(void (^)(id responseObject ,NSError *error))block {
    if ([NSString isIMBlankString:flowNo]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    if (![NSString isIMBlankString:flowNo]) [param setObject:flowNo forKey:@"flowNo"];
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
//    NSString *xdate = [IMClientChatUtil currentGMT];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent1:@"" andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    
    NSString *url = [NSString stringWithFormat:@"%@/voip/%@/validity",flowNo,voipAgentId];
    [manager GET:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if (block) block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求session/end---error :%@", error);
        if (block) block(nil,error);
    }];
}

// 每当点 No 后发送客户拒绝结果
+ (void)checkVoipResultByFlowNo:(NSString *)flowNo voipAgentId:(NSString *)voipAgentId block:(void (^)(id responseObject ,NSError *error))block {
    if ([NSString isIMBlankString:flowNo]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (![NSString isIMBlankString:flowNo]) [param setObject:flowNo forKey:@"flowNo"];
    // 点No, 传"N"
    [param setObject:@"N" forKey:@"result"];
    
    AFHTTPSessionManager *manager =  [IMAppDotNetAPIClient sharedDefaultSessionClient];
    NSString *xdate = [IMClientChatUtil getNowGMTDateStr];
    NSString *signature = [IMClientChatUtil getNetSignatureWithContent:[param yy_modelToJSONString] andDate:xdate];
    NSString *authString = [NSString stringWithFormat:@"UCC %@:%@", [IMConfigSingleton sharedInstance].sysAccount, signature];
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:xdate forHTTPHeaderField:@"X-Date"];
    
    NSString *url = [NSString stringWithFormat:@"%@/voip/%@/result",flowNo,voipAgentId];
    [manager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"请求session/end---error :%@", error);
        if (block) block(nil,error);
    }];
}

@end
