//
//  IMChatViewController.m
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMChatViewController.h"
#import "IMNoneTableViewCell.h"
#import "IMTextTableViewCell.h"
#import "IMImageTableViewCell.h"
#import "IMVoiceTableViewCell.h"
#import "IMVideoTableViewCell.h"
#import "IMFileTableViewCell.h"
#import "IMlinkListTableViewCell.h"
#import "IMSatisfactionTableViewCell.h"
#import "IMMenuListTableViewCell.h"
#import "IMDisLikeTableViewCell.h"
#import "IMHtmlTableViewCell.h"
#import "IMConfigSingleton.h"
#import "UCCHeader.h"
#import "IMTopView.h"
#import "IMBottomView.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMDeviceModelHelper.h"
#import "IMMsgModel.h"
#import "IMChatDBManager.h"
#import "IMHttpRequest.h"
#import "IMSocketRocketManager.h"
#import "IMCellDataHelper.h"
#import "IMRequestDataHelper.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import <CKYPhotoBrowser/KYPhotoBrowserController.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "IMHeaderView.h"
#import "IMQuickView.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import "IMCellHeightHelper.h"
#import "IMLeaveTipView.h"
#import "IMHistoryViewController.h"
#import "IMMenuBtnListTableViewCell.h"
#import "IMUserInfoTableViewCell.h"
#import "IMTypingTableViewCell.h"
#import "IMPopupView.h"
#import "IMEmojiTextTableViewCell.h"
#import "IMVOIPTableViewCell.h"
#import <MJRefresh/MJRefresh.h>

#define  ROLES_TOURIST  @"tourist" // 游客

@interface IMChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, HtmlTableViewCellDelagate, IMUserInfoSubmitDelegate, VOIPTableViewCellDeleagte> {
    NSString *_flowNo;
    NSString *_custId;
    NSString *_accNbr;
    CGFloat KTopViewHeight;
    CGFloat KBottomViewHeight;
    CGFloat KShowKeyboardHeight;
    BOOL _isShowKeyboard;
    CGFloat KQuickViewHeight;
    BOOL _isShowQuickQuestion;
    IMMsgModel *_disLikeModel;
}

@property (nonatomic, strong) NSMutableArray *chatDataArray;
@property (nonatomic, assign) BOOL isSearching;

@property (nonatomic, strong) IMTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IMBottomView *bottomView;
@property (nonatomic, strong) IMQuickView *quickView;
@property (nonatomic, strong) IMPopupView *popupView;
@end

@implementation IMChatViewController

- (id)initWithUserId:(NSString *)userId custId:(NSString *)custId accNbr:(NSString *)accNbr sessionID:(nonnull NSString *)sessionID {
    self = [super init];
    if (self) {
        // 判断是否deaplink
        if (![NSString isIMBlankString:sessionID]) {
            // deaplink
            _flowNo = sessionID;
            [self CacheUserInfoWithUserId:userId custId:custId accNbr:accNbr];
            [[IMSocketRocketManager instance] openSocket:sessionID];
        } else {
            // 非deaplink
            [self CacheUserInfoWithUserId:userId custId:custId accNbr:accNbr];
        }
    }
    return self;
}

// 缓存用户信息
- (void)CacheUserInfoWithUserId:(NSString *)userId custId:(NSString *)custId accNbr:(NSString *)accNbr {
    if ([NSString isIMBlankString:userId]) {
        
        [IMConfigSingleton sharedInstance].userId = ROLES_TOURIST;
    } else {
        [IMConfigSingleton sharedInstance].userId = userId;
    }
    
    if ([NSString isIMBlankString:custId]) {
        _custId = @"";
    } else {
        _custId = custId;
    }
    
    if ([NSString isIMBlankString:accNbr]) {
        _accNbr = @"";
    } else {
        _accNbr = accNbr;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO; // 控制整个功能是否启用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:IMNotificationReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendImageMessage:) name:IMNotificationSendImage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextMessage:) name:IMNotificationSendText object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextMenuMessage:) name:IMNotificationSendMenuText object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveQuestions:) name:IMNotificationReceiveQuestions object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataTableView) name:IMNotificationReloadData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendDisLikeMessage) name:IMNotificationDisLike object:nil];
    // 退出chat 窗口
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootViewController) name:IMNotificationPopToRootView object:nil];
    
    // 刷新本地数据源列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrashChatDataArray:) name:IMNotificationRefrashChatArray object:nil];
    
	// 路由跳转--通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routerDeal:) name:IMNotificationRouterDeal object:nil];

    
    [self initData];
    
    [self initUI];
    
    // 根据flowNo判断是否是deaplink跳转过来的
    if (![NSString isIMBlankString:_flowNo]) {
        // deaplink 跳转过来的
    } else {
        // 非deaplink 跳转过来的。
        [self requestDataPrivacy];
    }
}

- (void)requestDataPrivacy {
    if ([[IMConfigSingleton sharedInstance].userId isEqualToString:ROLES_TOURIST]) {
        // 如果是访客，则弹出隐私协议
		NSString *appName = isEmptyString_IM([IMConfigSingleton sharedInstance].appName)?@"":[IMConfigSingleton sharedInstance].appName;
		NSString *headerInfo = [NSString stringWithFormat:@"I am your %@ virtual assistant and I’ll be happy to answer your questions. Before we start please read and accept our Terms and Conditions.\nBy clicking \"I Accept\", you agree to the Terms and Conditions and you are giving %@ Telecommunity your consent and permission to use your Personal Data to facilitate your transaction. To check our Data Privacy details, you may click below.",appName,appName];
		
        NSDictionary *contentDic = @{@"contentType":@"6",@"header":headerInfo,@"menu":@[@{@"title":@"View and read Data Privacy",@"content":@"webchat://ViewDataPrivacy:View and read Data Privacy"},@{@"title":@"I do not accept",@"content":@"webchat://NotAcceptDataPrivacy:I do not accept"},@{@"title":@"I Accept",@"content":@"webchat://AcceptDataPrivacy:I Accept"}],@"msgId":@"181B90BE-C61B-47AE-A09E-D27C9B362F7B"};
        NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
        NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
        [fullDic setObject:dicString forKey:@"mainInfo"];
        // 计算mode cell的高度
        NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
        NSString *title = [mainInfoDic objectForKey:@"header"];
        CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
        NSArray *array = [mainInfoDic objectForKey:@"menu"];
        //
        //        NSString *mainInfoString = [dic[@"mainInfo"] yy_modelToJSONString];
        //        NSString *title = [IMCellDataHelper getMenuHeaderContent:mainInfoString];
        //        CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
        //        // 菜单数量
        //        NSArray *array = [IMCellDataHelper getMenuList:mainInfoString];
        // 消息构造
        IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
        model.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+array.count*40+kCellSpace10;
        model.msgType = IMMsgContentType_linkList;
        model.createType = IMMsgCreateType_server;
        //        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
        [_chatDataArray addObject:model];
        // 刷新cell
        [self reloadAndScrollAndChange];
    } else {
        // 订户
        [self beginSessions];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    
    [[IMSocketRocketManager instance] closeSocket];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData {
    _chatDataArray = [[NSMutableArray alloc] init];
    _isSearching = NO;
    KTopViewHeight = [IMDeviceModelHelper isIPhoneX] ? 88.0f : 64.0f;
    KBottomViewHeight = ([IMDeviceModelHelper isIPhoneX] ? 34.0f : 0) + 66;
//    KQuickViewHeight = 50;
    KQuickViewHeight = 0; // 快速问题高度
    KShowKeyboardHeight = 0;
    _isShowKeyboard = NO;
    _isShowQuickQuestion = NO;
    [IMConfigSingleton sharedInstance].sessionS = NO;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor chatVCBackgroundColor];
    
    [self.view addSubview:self.topView];//键盘弹起时,topView也固定在顶部
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.topView];
    
//    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)mjHeaderRefresh {
    if ([self.tableView.mj_header isRefreshing]) [self.tableView.mj_header endRefreshing];
    NSString *lastTime = @"";
    if (_chatDataArray.count > 0) {
        IMMsgModel *lastModel = [_chatDataArray firstObject];
        lastTime = lastModel.createTime;
    }
    NSMutableArray *array = [IMChatDBManager queryMJHeaderChatDBWithUserId:[IMConfigSingleton sharedInstance].userId lastTime:lastTime];
    __block NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[_chatDataArray reverseObjectEnumerator] allObjects]];
    [array enumerateObjectsUsingBlock:^(IMMsgModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:model];
    }];
    _chatDataArray = [[NSMutableArray alloc] initWithArray:[[tempArray reverseObjectEnumerator] allObjects]];
    [self.tableView reloadData];
}

- (void)mjFooterRefresh {
    if ([self.tableView.mj_footer isRefreshing]) [self.tableView.mj_footer endRefreshing];
    if (_chatDataArray.count > 0) {
        IMMsgModel *lastModel = [_chatDataArray lastObject];
        NSMutableArray *array = [IMChatDBManager queryMJFooterChatDBWithUserId:[IMConfigSingleton sharedInstance].userId lastTime:lastModel.createTime];
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_chatDataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}

// 刷新消息队列数据
- (void)refrashChatDataArray:(NSNotification *)notification {
    NSMutableArray *messages = [notification object]; // 要修改的list
    for (int i = 0; i< [_chatDataArray count]; i++) {
        IMMsgModel *msgModel = [_chatDataArray objectAtIndex:i];
        for (int j = 0; j< [messages count]; j++) {
            NSString *msgId = [messages objectAtIndex:j];
            if ([msgModel.msgSeenId isEqualToString:msgId]) {
                msgModel.isSeen = YES; // 修改已读
            }
        }
    }
    // 刷新table
    [self.tableView reloadData];
}

- (void)routerDeal:(NSNotification *)notification {
	NSString *text = [notification object];
	if (self.routerActionBlock) {
		self.routerActionBlock(text, @"", self, @"", @"");
	}
}

#pragma mark - sessions/begin接口，必备
// 重启会话
- (void)restartSessions {
    [self beginSessionsByIsRestart:@"Y" firstName:@"" lastName:@"" email:@"" phoneNumber:@"" birthday:@""];
}

- (void)beginSessions {
    [self beginSessionsByIsRestart:@"" firstName:@"" lastName:@"" email:@"" phoneNumber:@"" birthday:@""];
}

- (void)beginSessionsByIsRestart:(NSString *)isRestart firstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email phoneNumber:(NSString *)phoneNumber birthday:(NSString *)birthday {
	[HJMBProgressHUD showLoading];
    [IMHttpRequest beginSessionWithUserAcct:@"" accNbr:_accNbr acData:@"infomations" createTime:[NSString getCreateTime] custId:_custId isRestart:isRestart firstName:firstName lastName:lastName emailAddress:email phoneNumber:phoneNumber birthday:birthday block:^(NSString * _Nonnull flowNo, NSError * _Nonnull error) {
		[HJMBProgressHUD hideLoading];
        if (![NSString isIMBlankString:flowNo]) {
            _flowNo = flowNo;
            [[IMSocketRocketManager instance] openSocket:flowNo];
            // 保存
            [IMConfigSingleton sharedInstance].custId = _custId;
            [IMConfigSingleton sharedInstance].accNbr = _accNbr;
            
        } else {
			[HJMBProgressHUD showText:@"Network can not be accessed!"];
            [self.bottomView setBottomEnabled];
        }
    }];
}

// 结束会话
- (void)endSessions {
	[HJMBProgressHUD showLoading];
    
    [IMHttpRequest endSessionByFlowNo:_flowNo block:^(NSError * _Nonnull error) {
        // 关闭socket
        [[IMSocketRocketManager instance] closeSocket];
        [self popToRootViewController];
//        if (!error) {
//            // 重启
////            [self restartSessions];
//            // 关闭socket
//            [[IMSocketRocketManager instance] closeSocket];
//            [self popToRootViewController];
//        } else {
//            [IMProgressHUD showMessage:@"End Sessions Error" finshBlock:nil];
//        }
    }];
}

//- (void)beginSessions {
//    [IMProgressHUD showActivityIndicator];
//    [IMHttpRequest beginSessionWithUserAcct:@"" accNbr:[IMConfigSingleton sharedInstance].userId acData:@"infomations" createTime:[NSString getCreateTime] custId:_custId block:^(NSString * _Nonnull flowNo, NSError * _Nonnull error) {
//        if (![NSString isIMBlankString:flowNo]) {
//            [IMProgressHUD showMessage:nil finshBlock:nil];
//            _flowNo = flowNo;
//            [[IMSocketRocketManager instance] openSocket:flowNo];
//        } else {
//            [IMProgressHUD showMessage:@"Network can not be accessed!" finshBlock:nil];
//            [self.bottomView setBottomEnabled];
//        }
//    }];
//}

#pragma mark - NSNotification - 接受新的消息刷新界面
- (void)receiveMessage:(NSNotification *)notification {
    NSMutableArray *messages = [notification object];
    if (messages.count > 0) {
        // 判断是否有失效消息
        for (IMMsgModel *model in messages) {
            if (model.msgType == IMMsgContentType_flowNoExpired) {
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:model.mainInfo];
                self.popupView =[[IMPopupView alloc] initWithAttributedString:content doneText:@"OK" cancleText:nil];
                __strong typeof(self) strongSelf = self;
                self.popupView.doneBlock = ^(UIButton * _Nonnull sender) {
                    [strongSelf.popupView hide];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                        [[IMSocketRocketManager instance] closeSocket];
                    });
                };
                self.popupView.cancleBlock = ^(UIButton * _Nonnull sender) {
                };
                [self.popupView show];
                return;
            }
        }
        
        // 从消息队列中捞出 正在输入 的消息，排列到消息队列的末端，让正在输入的状态永远显示在最下面
        BOOL isExist = NO; // 是否存在正在输入的状态
        IMMsgModel *TModel; // 正在输入的model
        for (int i = 0; i < [_chatDataArray count]; i++) {
            IMMsgModel *model = [_chatDataArray objectAtIndex:i];
            if ([model.status isEqualToString:@"T"]) {
                isExist = YES;
                TModel = model;
                break;
            }
        }
        
        for (int i = 0; i< [messages count]; i++) {
            IMMsgModel *model = [messages objectAtIndex:i];
            if ([model.status isEqualToString:@"T"] && !isExist) {
                // 返回的消息中存在正在输入 并且 之前的消息不存在正在输入
                [_chatDataArray addObject:model];
                break;
            } else {
                if (isEmptyString_IM(model.status)) {
                    [_chatDataArray addObject:model];
                }
                if ([model.status isEqualToString:@"N"]) {
                    [_chatDataArray removeObject:TModel];
                }
            }
        }
        //        [_chatDataArray addObjectsFromArray:messages];
        [self reloadAndScrollAndChange];
    }
    for (IMMsgModel *model in messages) {
        if ([model.sessionState isEqualToString:@"F"]) {
            [[IMSocketRocketManager instance] closeSocket];
            [self beginSessions];
            break;
        }
    }
}

#pragma mark - NSNotification - 刷新界面
- (void)reloadDataTableView {
    [self reloadAndScrollAndChange];
}

#pragma mark - NSNotification -发送文本
- (void)sendTextMessage:(NSNotification *)notification {
    NSString *text = [notification object];
    [self sendMessageText:text webChat:@""];
}

#pragma mark - NSNotification -发送文本
- (void)sendTextMenuMessage:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    NSString *content = [NSString imStringWithoutNil:[dic objectForKey:@"content"]];
    NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
    [self sendMessageText:title webChat:content];
}

#pragma mark - NSNotification -发送点踩列表
- (void)sendDisLikeMessage {
    if (_disLikeModel) {
        IMMsgModel *tempModel = [_disLikeModel copy];
        tempModel.msgId = [NSString getLocalMsgId];
        tempModel.createTime = [NSString getCurrentTimestamp];
        tempModel.cellHeight = [IMCellHeightHelper getCellHeight:tempModel];
        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:tempModel];
        [_chatDataArray addObject:tempModel];
        [self reloadAndScrollAndChange];
    }
}

#pragma mark - NSNotification - 接受 常见问题和快捷问题
- (void)receiveQuestions:(NSNotification *)notification {
    IMMsgModel *model = [notification object];
    if (model.msgType == IMMsgContentType_commonQuestion) {
//        NSArray *cateMenuList = [[model.mainInfo JSONValue] objectForKey:@"cateMenuList"];
//        if (cateMenuList.count > 0) {
//            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//            for (NSDictionary * dic in cateMenuList) {
//                IMCardModel *model = [[IMCardModel alloc] initWithDic:dic];
//                [dataArray addObject:model];
//            }
//            IMHeaderView *headerView = [[IMHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 260) cateMenuList:dataArray];
//            self.tableView.tableHeaderView = headerView;
//        }
    } else if (model.msgType == IMMsgContentType_quickQuesttion) {
//        if (!_quickView) {
//            NSArray *questionList = [[model.mainInfo JSONValue] objectForKey:@"questionList"];
//            if (questionList.count > 0) {
//                _isShowQuickQuestion = YES;
//                _quickView = [[IMQuickView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - KBottomViewHeight - KQuickViewHeight, kMainScreenWidth, KQuickViewHeight) questionList:questionList];
//                [self.view addSubview:_quickView];
//
//                CGRect tableViewFrame = self.tableView.frame;
//                tableViewFrame.size.height = tableViewFrame.size.height - KQuickViewHeight;
//                self.tableView.frame = tableViewFrame;
//            }
//        }
    } else if (model.msgType == IMMsgContentType_disLike) {
        _disLikeModel = model;
    }
}

#pragma mark - NSNotification - 键盘将要弹起
- (void)keyboardWillShow:(NSNotification *)notification {
    _isShowKeyboard = YES;
    [self scrollToBottomCell];
    
    //获取动画开始状态的frame
    NSValue *aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    NSTimeInterval timte = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    KShowKeyboardHeight = keyboardHeight + (KBottomViewHeight+(_isShowQuickQuestion ? KQuickViewHeight:0)-([IMDeviceModelHelper isIPhoneX] ? 34.0f : 0));
    [UIView animateWithDuration:timte animations:^{
        //更新bottomView的Y坐标
        CGRect tempBRect = CGRectMake(0, kMainScreenHeight - KBottomViewHeight, kMainScreenWidth, KBottomViewHeight);
        tempBRect.origin.y = tempBRect.origin.y - keyboardHeight + ([IMDeviceModelHelper isIPhoneX] ? 34.0f : 0);
        self.bottomView.frame = tempBRect;
      
        //更新quickView的Y坐标
        if (self.quickView && _isShowQuickQuestion) {
            CGRect tempBRect = CGRectMake(0, kMainScreenHeight - KBottomViewHeight - KQuickViewHeight, kMainScreenWidth, KQuickViewHeight);
            tempBRect.origin.y = tempBRect.origin.y - keyboardHeight + ([IMDeviceModelHelper isIPhoneX] ? 34.0f : 0);
            self.quickView.frame = tempBRect;
        }
        
        //更新tableView的Y坐标
        if (_chatDataArray.count > 0) [self changeTableViewY];
    } completion:nil];
}

- (void)changeTableViewY {
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_chatDataArray.count - 1];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:lastIndexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
    CGFloat restHeight = kMainScreenHeight - rect.origin.y - rect.size.height - kCellHeaderFooterSpace;
    //说明:部分cell在键盘的下面、弹出改变tableView的坐标，
    if (KShowKeyboardHeight > restHeight) {
        CGFloat orginBottomY = kMainScreenHeight - KBottomViewHeight;
        CGFloat newBottomY = self.bottomView.frame.origin.y;
        CGFloat keyBoardChangeY = orginBottomY - newBottomY;//键盘移动高度

        CGRect tempTRect = CGRectMake(0, KTopViewHeight, kMainScreenWidth, kMainScreenHeight - KTopViewHeight- KBottomViewHeight- (_isShowQuickQuestion ? KQuickViewHeight:0));
        tempTRect.origin.y = tempTRect.origin.y - keyBoardChangeY;
        self.tableView.frame= tempTRect;
    }
}

#pragma mark - NSNotification - 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    _isShowKeyboard = NO;
    NSTimeInterval timte = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:timte animations:^{
        self.bottomView.frame = CGRectMake(0, kMainScreenHeight - KBottomViewHeight, kMainScreenWidth, KBottomViewHeight);
        if (self.quickView && _isShowQuickQuestion) {
            self.quickView.frame = CGRectMake(0, kMainScreenHeight - KBottomViewHeight - KQuickViewHeight, kMainScreenWidth, KQuickViewHeight);
        }
      self.tableView.frame = CGRectMake(0, KTopViewHeight, kMainScreenWidth, kMainScreenHeight - KTopViewHeight - KBottomViewHeight - (_isShowQuickQuestion ? KQuickViewHeight:0));
    } completion:nil];
}

#pragma mark - popview
- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_chatDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _chatDataArray.count - 1) {
        return kCellHeaderFooterSpace;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:section];
    if (msgModel.isShowTime) {
        return 60;
    }
    return kCellHeaderFooterSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:indexPath.section];
    if ([msgModel.sessionState isEqualToString:@"C"]) {
        // 机器人 用户发出
        if (msgModel.createType == IMMsgCreateType_user) {
            NSDictionary *mianInfoDic = [msgModel.mainInfo JSONValue];
            NSString *showType = [mianInfoDic objectForKey:@"showType"];
            if ([showType isEqualToString:@"C"]) {
                // 评论反馈 显示菜单展示的方式 C:emoji横排展示
                return 40;
            }
            // 已读，展示
            NSInteger seen = 20;
            return msgModel.cellHeight + 10 + seen;
        }
    }
    if ([msgModel.sessionState isEqualToString:@"S"]) {
        // 人工
        if (msgModel.createType == IMMsgCreateType_user && msgModel.isSeen) {
            // 已读，展示
            NSInteger seen = 20;
            return msgModel.cellHeight + 10 + seen;
        }
    }
    return msgModel.cellHeight + 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:section];
    if (msgModel.isShowTime) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
        headView.backgroundColor = [UIColor clearColor];
        
        NSString *time = [IMCellDataHelper getCellHeaderDate:msgModel.createTime];
        CGSize timeSize = [time singleSizeWithFont:[UIFont cellDateTextFont]];
        CGFloat timeWidth = timeSize.width < 200 ? (timeSize.width+20) : 200;
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth-timeWidth)/2, 20, timeWidth, 20)];
        timeLab.font = [UIFont cellDateTextFont];
        timeLab.textColor = UIColorFromRGB_IM(0xFFFFFF);
        timeLab.layer.backgroundColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        timeLab.layer.cornerRadius = 4;
        timeLab.text = [IMCellDataHelper getCellHeaderDate:msgModel.createTime];
        timeLab.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:timeLab];
        
        return headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:indexPath.section];

    // 正在输入状态
//    IMTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTyping forIndexPath:indexPath];
//    [cell setContentWithModel:msgModel indexPath:indexPath];
//    return cell;
    
    if (msgModel.msgType == IMMsgContentType_text) {
        if (msgModel.isHTML) {
            IMHtmlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
            [cell setContentWithModel:msgModel indexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
        if ([msgModel.mainInfo containsString:@"Emoji_"]) {
            IMEmojiTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMEmojiTextTableViewCell" forIndexPath:indexPath];
            [cell setContentWithModel:msgModel indexPath:indexPath];
            return cell;
        }
        
        IMTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        cell.contentTiew.delegate = self;
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_image) {
        IMImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_voice) {
        IMVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_video) {
        IMVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_file) {
        IMFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_linkList) {
        if ([msgModel.sessionState isEqualToString:@"C"] || [msgModel.sessionState isEqualToString:@"Q"]) {
            IMlinkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
            cell.flowNo = [NSString imStringWithoutNil:_flowNo];
            [cell setContentWithModel:msgModel indexPath:indexPath];
            return cell;
        } else {
            IMSatisfactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
            [cell setContentWithModel:msgModel indexPath:indexPath];
            cell.submintBtn.tag = indexPath.section;
            [cell.submintBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    } else if (msgModel.msgType == IMMsgContentType_menuList) {
        IMMenuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        cell.submintBtn.tag = indexPath.section;
        [cell.submintBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_VOIP) {
        // VOIP 需求
        IMVOIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        cell.delegate = self;
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_file) {
        IMDisLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_dataPrivacy) {
        IMMenuBtnListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        NSArray *operList = @[@"View and read Data Privacy",@"I do not accept",@"I Acce"];
        [cell setContentWithModel:msgModel operList:operList indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_userInfo) {
        // 用户资料
        IMUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        cell.delegate = self;
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else if (msgModel.msgType == IMMsgContentType_typing) {
        // 正在输入状态
        IMTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    } else {
        IMNoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString getCellIdentifier:msgModel] forIndexPath:indexPath];
        [cell setContentWithModel:msgModel indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:indexPath.section];
    if (msgModel.msgType == IMMsgContentType_file) {
        //浏览器打开文件
        NSString *url = [NSString stringWithFormat:@"%@%@",[IMConfigSingleton sharedInstance].fileURLStr,msgModel.mainInfo];
        [self openWithUrl:url];
    } else if (msgModel.msgType == IMMsgContentType_image) {
        if (msgModel.createType == IMMsgCreateType_user) {
            //本地图片
            SDImageCache *imageCache  = [[SDWebImageManager sharedManager] imageCache];
            UIImage *cacheImage = [imageCache imageFromCacheForKey:msgModel.msgId];
            [KYPhotoBrowserController showPhotoBrowserWithImages:@[cacheImage] currentImageIndex:0 delegate:nil];
        } else if (![NSString isIMBlankString:msgModel.mainInfo]) {
            //网络图片
            NSString *url = [NSString stringWithFormat:@"%@%@",[IMConfigSingleton sharedInstance].fileURLStr, msgModel.mainInfo];
            [KYPhotoBrowserController showPhotoBrowserWithImages:@[url] currentImageIndex:0 delegate:nil];
        }
    }
}

#pragma mark - UITextViewDelegate 点富文本
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
  
    if ([[URL scheme] isEqualToString:@"uccLinkString"]) {
        [textView.text enumerateSubstringsInRange:characterRange options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [self openWithUrl:substring];
        }];
    } else if ([[URL scheme] isEqualToString:@"manual"]) {
        IMMsgModel *clickModel = [_chatDataArray objectAtIndex:textView.tag];
        [textView.text enumerateSubstringsInRange:characterRange options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [IMRequestDataHelper sendMessagesWithManual:@"yes" flowNo:self->_flowNo resultBlock:^(BOOL isSuccess) {
                if (!isSuccess) {
					[HJMBProgressHUD showText:@"Sorry, we encountered an error while processing your request. Please try again later."];
                } else {
                    clickModel.isSubmit = YES;
                    [IMChatDBManager updateIsSubmitWithUserId:[IMConfigSingleton sharedInstance].userId msgId:clickModel.msgId isSubmit:YES];
                    [self reloadAndScrollAndChange];
                }
            }];
        }];
    }
    return YES;
}

- (void)openWithUrl:(NSString *)url {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
        }
    } else {
       [application openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark - HtmlTableViewCellDelagate
- (void)reloadHTMLData:(NSIndexPath *)indexPath {
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:indexPath.section];
    if (!msgModel.isHtmlReload) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!msgModel.isHtmlReload && msgModel.cellHeight > 40) {
                msgModel.cellHeight = msgModel.cellHeight+20;
            }
            msgModel.isHtmlReload = YES;
            [IMChatDBManager updateExtendWithUserId:[IMConfigSingleton sharedInstance].userId msgId:msgModel.msgId isHtmlReload:YES];
            [IMChatDBManager updateCellHeightWithUserId:[IMConfigSingleton sharedInstance].userId msgId:msgModel.msgId cellHeight:msgModel.cellHeight];
            [self.tableView reloadData];
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_chatDataArray.count-1];
            [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
}

#pragma mark - 发送文本
- (void)sendMessageText:(NSString *)text webChat:(NSString *)webChat {
    // 判断是否隐私协议消息
    if ([webChat containsString:@"ViewDataPrivacy"]) {
        // 查看隐私协议
        [self jumpDataPrivacy];
        
        IMMsgModel *model = [[IMMsgModel alloc] initText];
        model.mainInfo = text;
        model.cellHeight = [IMCellHeightHelper getCellHeight:model];
        [_chatDataArray addObject:model];
        [self reloadAndScrollAndChange];
        
        return;
    } else if ([webChat containsString:@"NotAcceptDataPrivacy"]) {
        // 不接受隐私协议
        [self popToRootViewController];
        return;
    } else if ([webChat containsString:@"AcceptDataPrivacy"]) {
        // 接受隐私协议
        IMMsgModel *model = [[IMMsgModel alloc] initText];
        model.mainInfo = text;
        model.cellHeight = [IMCellHeightHelper getCellHeight:model];
        //        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
        [_chatDataArray addObject:model];
        
        // 构造用户资料model
        IMMsgModel *userInfoModel = [[IMMsgModel alloc] initUserInfo];
        userInfoModel.msgType = IMMsgContentType_userInfo;
        userInfoModel.createType = IMMsgCreateType_server;
        // 计算标题高度
        NSString *title = @"Please fill in the details below to start the conversation.:";
        CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellFontTextSize12]];
        userInfoModel.cellHeight = kCellSpace10 + titleSize.height + (kCellSpace6 + 12 + kCellSpace6 + 40)*4 + kCellSpace10 + kCellSpace6 + 31 + kCellSpace10;
        userInfoModel.mainInfo = title;
        [_chatDataArray addObject:userInfoModel];
        
        [self reloadAndScrollAndChange];
        
        return;
    }
    
    if ([webChat containsString:@"webchat://"]) {
        // Leave and close 场景
        NSString *content = [webChat stringByReplacingOccurrencesOfString:@"webchat://" withString:@""];
        if ([content isEqualToString:@"#"]) {
            // 退出live chat
            [self endSessions];
            return;
        } else if ([content.uppercaseString isEqualToString:@"#START"]) {
            // 先调关闭会话接口，再调sessions/begin重启会话  restartSession = Y
            [self restartSessions];
            return;
        }
    } else {
        NSString *content = webChat.uppercaseString;
        if ([content containsString:@"#START"]) {
            // 先调关闭会话接口，再调sessions/begin重启会话  restartSession = Y
            [self restartSessions];
            return;
        }
    }

    [IMRequestDataHelper sendMessagesWithText:text webChat:webChat flowNo:_flowNo resultBlock:^(BOOL isSuccess, IMMsgModel * _Nonnull sendModel) {
        if (isSuccess) {
            if (_isSearching) {
                _isSearching = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [_chatDataArray removeAllObjects];
                NSMutableArray *array = [IMChatDBManager queryMJHeaderChatDBWithUserId:[IMConfigSingleton sharedInstance].userId lastTime:@""];
                [_chatDataArray addObjectsFromArray:[[array reverseObjectEnumerator] allObjects]];
                [self reloadAndScrollAndChange];
            } else {
                if (!sendModel) {
                    return;
                }
                if ([webChat containsString:@"webchat://"]) {
                    // Leave and close 场景
                    NSString *content = [webChat stringByReplacingOccurrencesOfString:@"webchat://" withString:@""];
                    if ([content isEqualToString:@"#"]) {
                        // 退出live chat
                        //                        [self popToRootViewController];
                        return;
                    } else if ([content.uppercaseString isEqualToString:@"#START"]) {
                        // 先调关闭会话接口，再调sessions/begin重启会话  restartSession = Y
                        //                        [self endSessions];
                        return;
                    }
                } else if ([sendModel.mainInfo isEqualToString:@"QUIT_QUEUING"]) {
                    return;
                } else {
                    NSString *content = webChat.uppercaseString;
                    if ([content containsString:@"#START"]) {
                        // 先调关闭会话接口，再调sessions/begin重启会话  restartSession = Y
                        //                        [self endSessions];
                        return;
                    }
                }
                
                
                
                IMMsgModel *model = [_chatDataArray lastObject];
                if ([model.sessionState isEqualToString:@"C"] && [model.needBtn isEqualToString:@"Y"] && !model.isSubmit && ([[text lowercaseString] isEqualToString:@"y"] || [[text lowercaseString] isEqualToString:@"yes"])) {
                    model.isSubmit = YES;
                    [IMChatDBManager updateIsSubmitWithUserId:[IMConfigSingleton sharedInstance].userId msgId:model.msgId isSubmit:YES];
                }
                [_chatDataArray addObject:sendModel];
                [self reloadAndScrollAndChange];
            }
        } else {
			[HJMBProgressHUD showText:@"Sorry, we encountered an error while processing your request. Please try again later."];
        }
    }];
}

#pragma mark - 发送图像
- (void)sendImageMessage:(NSNotification *)notification {
    UIImage *selectImage = [notification object];
    if (!selectImage) return;
    
    [HJMBProgressHUD showLoading];
    [IMRequestDataHelper sendMessagesWithImage:selectImage flowNo:_flowNo resultBlock:^(BOOL isSuccess, IMMsgModel * _Nonnull sendModel) {
        if (isSuccess) {
            [HJMBProgressHUD hideLoading];
            if (_isSearching) {
                _isSearching = NO;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [_chatDataArray removeAllObjects];
                NSMutableArray *array = [IMChatDBManager queryMJHeaderChatDBWithUserId:[IMConfigSingleton sharedInstance].userId lastTime:@""];
                [_chatDataArray addObjectsFromArray:[[array reverseObjectEnumerator] allObjects]];
                [self reloadAndScrollAndChange];
            } else {
                [_chatDataArray addObject:sendModel];
                [self reloadAndScrollAndChange];
            }
        } else {
			[HJMBProgressHUD showText:@"Sorry, we encountered an error while processing your request. Please try again later."];
        }
    }];
}

#pragma mark - 发送文本[满意度]
- (void)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    IMMsgModel *msgModel = [_chatDataArray objectAtIndex:sender.tag];
    if (msgModel.isSubmit ) return;
    
    [IMRequestDataHelper sendMessagesWithSatisfyModel:msgModel flowNo:_flowNo resultBlock:^(BOOL isSuccess, IMMsgModel * _Nonnull sendModel) {
        if (isSuccess) {
            if (msgModel.msgType == IMMsgContentType_linkList) {
                [_chatDataArray addObject:sendModel];
            }
            [self reloadAndScrollAndChange];
        } else {
			[HJMBProgressHUD showText:@"Sorry, we encountered an error while processing your request. Please try again later."];
        }
    }];
}

#pragma mark -- VOIPTableViewCellDeleagte
- (void)VOIPTableViewCellEventByTag:(IMVOIPAgreeButtonType)tag IMMsgModel:(IMMsgModel *)model cell:(UITableViewCell *)cell {
    if (tag == IMVOIPAgreeButtonType_Yes) {
//        [IMProgressHUD showActivityIndicator];
        NSDictionary *dic = [model.mainInfo JSONValue];
        NSString *voipAgentId = [dic objectForKey:@"voipAgentId"];
        // 提示信息
        NSString *expiredPrompt = [dic objectForKey:@"expiredPrompt"];
		WS_IM(weakSelf);
        [IMHttpRequest checkVoipValidityByFlowNo:_flowNo voipAgentId:voipAgentId block:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            NSNumber *boolNum = ((NSDictionary *)responseObject)[@"validity"];
            BOOL isSuccess = [boolNum boolValue];
            if (isSuccess) {
                NSString *deviceDn = [dic objectForKey:@"deviceDn"]; // 分机号
                NSString *srcContactHisId = [dic objectForKey:@"srcContactHisId"];
                NSString *voipAgentName = [dic objectForKey:@"voipAgentName"];
                // voip H5地址
                NSString *voipUrl = [NSString stringWithFormat:@"http%@/h5/italk?extNbr=%@&username=%@&srcContactHisId=%@",[IMConfigSingleton sharedInstance].voipUrl,deviceDn,voipAgentName,srcContactHisId];
                NSURL *url = [NSURL URLWithString:[voipUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                // 跳转H5 webview 加载voip
				if (weakSelf.webViewActionBlock) {
					weakSelf.webViewActionBlock([url absoluteString], @"", IMMsgWebViewType_VOIP);
				}
            } else {
                // 提示这个消息已经过期的提示语
                if ([NSString isIMBlankString:expiredPrompt]) {
                    // 默认提示语
					[HJMBProgressHUD showText:@"Sorry, this request has expired."];
                } else {
					[HJMBProgressHUD showText:expiredPrompt];
                }
            }
        }];
    }
    if (tag == IMVOIPAgreeButtonType_No) {
//        [IMProgressHUD showActivityIndicator];
        NSDictionary *dic = [model.mainInfo JSONValue];
        NSString *voipAgentId = [dic objectForKey:@"voipAgentId"];
        // 提示信息
        NSString *expiredPrompt = [dic objectForKey:@"expiredPrompt"];
        [IMHttpRequest checkVoipResultByFlowNo:_flowNo voipAgentId:voipAgentId block:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            NSNumber *boolNum = ((NSDictionary *)responseObject)[@"success"];
            BOOL isSuccess = [boolNum boolValue];
            NSNumber *boolValidity = ((NSDictionary *)responseObject)[@"validity"];
            BOOL isValidity = [boolValidity boolValue];
            
            if (isSuccess) {
                if (!isValidity) {
                    // 提示这个消息已经过期的提示语
                    if ([NSString isIMBlankString:expiredPrompt]) {
                        // 默认提示语
						[HJMBProgressHUD showText:@"Sorry, this request has expired."];
                    } else {
						[HJMBProgressHUD showText:expiredPrompt];
                    }
                }
            }
        }];
    }
}

#pragma mark - IMUserInfoSubmitDelegate
// 提交用户数据
- (void)SubmitUserInfoAction:(IMUserInfoTableViewCell *)cell firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress mobileNumber:(NSString *)mobileNumber birthday:(NSString *)birthday  {
    // 提交信息后，建立会话连接
    [self beginSessionsByIsRestart:@"" firstName:firstName lastName:lastName email:emailAddress phoneNumber:mobileNumber birthday:birthday];
}

#pragma mark - private method
// 跳转到隐私协议
- (void)jumpDataPrivacy {
	if (self.webViewActionBlock) {
		self.webViewActionBlock(@"", @"", IMMsgWebViewType_Privacy);
	}
}

#pragma mark - private method
- (void)reloadAndScrollAndChange {
    [self.tableView reloadData];
    [self scrollToBottomCell];
    
    if (_isShowKeyboard && _chatDataArray.count > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [self changeTableViewY];
        }];
    }
}

- (void)scrollToBottomCell {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_chatDataArray.count > 0) {
            if (_chatDataArray.count > 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_chatDataArray.count-2];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_chatDataArray.count-1];
            [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

#pragma mark -
- (IMTopView *)topView {
    if (!_topView) {
        _topView = [[IMTopView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KTopViewHeight)];
        _topView.backgroundColor = [UIColor chatVCTopBackgroundColor];
        __weak typeof(self) weakSelf = self;
        _topView.backBlock = ^{
            [weakSelf.view endEditing:YES];
            if ([IMConfigSingleton sharedInstance].sessionS) {
                IMLeaveTipView *view = [[IMLeaveTipView alloc] init];
                [view show];
                view.leaveBlock = ^{
                    if (weakSelf.navigationController != nil) {
                        // 关闭会话
//                        [[IMSocketRocketManager instance] closeSocket];
//                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [weakSelf endSessions];
                    } else {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                };
            } else {
              if (weakSelf.navigationController != nil) {
                  [weakSelf.navigationController popViewControllerAnimated:YES];
              } else {
                  [weakSelf dismissViewControllerAnimated:YES completion:nil];
              }
            }
        };
        
        _topView.historyBlock = ^{
            [weakSelf.view endEditing:YES];
            IMHistoryViewController *vc = [[IMHistoryViewController alloc] initWithBlock:^(NSMutableArray * _Nonnull dataArray) {
//                weakSelf.isSearching = YES;
                [weakSelf.chatDataArray removeAllObjects];
                [weakSelf.chatDataArray addObjectsFromArray:dataArray];
                [weakSelf.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (weakSelf.chatDataArray.count < 10) {
//                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//                    } else {
//                        [weakSelf.tableView.mj_footer resetNoMoreData];
//                    }
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                });
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopViewHeight, kMainScreenWidth, kMainScreenHeight - KTopViewHeight - KBottomViewHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor chatVCBackgroundColor];
        
        [_tableView registerClass:[IMNoneTableViewCell class] forCellReuseIdentifier:CellIdentifierNone];
        [_tableView registerClass:[IMTextTableViewCell class] forCellReuseIdentifier:CellIdentifierText];
        [_tableView registerClass:[IMImageTableViewCell class] forCellReuseIdentifier:CellIdentifierImage];
        [_tableView registerClass:[IMVoiceTableViewCell class] forCellReuseIdentifier:CellIdentifierVoice];
        [_tableView registerClass:[IMEmojiTextTableViewCell class] forCellReuseIdentifier:@"IMEmojiTextTableViewCell"];
        [_tableView registerClass:[IMVideoTableViewCell class] forCellReuseIdentifier:CellIdentifierVideo];
        [_tableView registerClass:[IMFileTableViewCell class] forCellReuseIdentifier:CellIdentifierFile];
        [_tableView registerClass:[IMlinkListTableViewCell class] forCellReuseIdentifier:CellIdentifierlinkList];
        [_tableView registerClass:[IMSatisfactionTableViewCell class] forCellReuseIdentifier:CellIdentifierSatisfaction];
        [_tableView registerClass:[IMMenuListTableViewCell class] forCellReuseIdentifier:CellIdentifierMenuList];
        [_tableView registerClass:[IMDisLikeTableViewCell class] forCellReuseIdentifier:CellIdentifierDisLike];
        [_tableView registerClass:[IMHtmlTableViewCell class] forCellReuseIdentifier:CellIdentifierHtml];
        [_tableView registerClass:[IMMenuBtnListTableViewCell class] forCellReuseIdentifier:CellIdentifierMenuBtnList];
        [_tableView registerClass:[IMUserInfoTableViewCell class] forCellReuseIdentifier:CellIdentifierUserInfo];
        [_tableView registerClass:[IMTypingTableViewCell class] forCellReuseIdentifier:CellIdentifierTyping];
        [_tableView registerClass:[IMVOIPTableViewCell class] forCellReuseIdentifier:CellIdentifierVoip];
        
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjHeaderRefresh)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
        
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjFooterRefresh)];
    }
    return _tableView;
}

- (IMBottomView *)bottomView {
    if (!_bottomView) {
        __weak typeof(self) weakSelf = self;
        _bottomView = [[IMBottomView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - KBottomViewHeight, kMainScreenWidth, KBottomViewHeight) block:^(NSString * _Nonnull text) {
            [weakSelf sendMessageText:text webChat:@""];
        }];
        _bottomView.backgroundColor = [UIColor chatVCBottomBackgroundColor];
    }
    return _bottomView;
}

- (IMPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[IMPopupView alloc] init];
    }
    return _popupView;
}

@end
