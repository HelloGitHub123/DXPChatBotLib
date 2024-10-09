//
//  IMlinkListTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMlinkListTableViewCell.h"
#import "IMlinkMenuListTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "UIColor+IM.h"
#import "IMCellDataHelper.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMCellHeightHelper.h"
#import "IMChatDBManager.h"
#import "IMConfigSingleton.h"
#import "IMHttpRequest.h"
#import "IMTapMorePushVC.h"
#import "IMLinkMenuFeedBackTableViewCell.h"
#import <DXPToolsLib/HJTool.h>

@interface IMlinkListTableViewCell () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, IMlinkMenuListCellDelegate,MFMailComposeViewControllerDelegate,IMLinkMenuFeedBackCellDelegate> {
    IMMsgModel *_currentModel;
}

@end

@implementation IMlinkListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor  clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[IMlinkMenuListTableViewCell class] forCellReuseIdentifier:@"IMlinkMenuListCell"];
        [_tableView registerClass:[IMLinkMenuFeedBackTableViewCell class] forCellReuseIdentifier:@"IMLinkMenuFeedBackTableViewCell"];
        [_cellBgView addSubview:_tableView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];
    
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, kCellMaxWidth, model.cellHeight);
        _cellBgView.backgroundColor = [UIColor  clearColor];
    } else if (model.createType == IMMsgCreateType_user) {
        _cellBgView.frame = CGRectMake(kMainScreenWidth-64-kCellSpace10*2, 0, 40, model.cellHeight);
    }
    
    //tableView
    _tableView.frame = CGRectMake(0, 0, kCellMaxWidth, model.cellHeight);
    [_tableView reloadData];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - tableView delegate and source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [IMCellDataHelper getMenuHeaderContent:_currentModel.mainInfo];
//    CGSize titleSize = [title sizeForWidth:kCellMaxWidth withFont:[UIFont cellContentFont]];
    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    if ([NSString isIMBlankString:title]) {
        return CGFLOAT_MIN;
    }
    return kCellSpace10 + titleSize.height + kCellSpace10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [IMCellDataHelper getMenuHeaderContent:_currentModel.mainInfo];
    if ([NSString isIMBlankString:title]) {
        return nil;
    }
    
    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellMaxWidth, kCellSpace10 + titleSize.height + kCellSpace10)];
    headView.backgroundColor = [UIColor cellServerBackgroundColor];
    headView.layer.cornerRadius = 8;
    
    UITextView *contentTiew = [[UITextView alloc] initWithFrame:CGRectMake(kCellSpace10, kCellSpace10, kCellMaxWidth - kCellSpace10*2,  titleSize.height)];
    contentTiew.font = [UIFont cellContentFont];
    contentTiew.textColor = [UIColor cellServerContextColor];
    contentTiew.backgroundColor = [UIColor clearColor];
    contentTiew.textContainerInset = UIEdgeInsetsZero;
    contentTiew.textContainer.lineFragmentPadding = 0;
    contentTiew.editable = NO;
    contentTiew.delegate = self;
    contentTiew.scrollEnabled = NO;
    [headView addSubview:contentTiew];

    contentTiew.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor cellLinkContentColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };

//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 1;// 字体的行间距 NSParagraphStyleAttributeName:paragraphStyle
    
    NSString *desTitle = title;
    if ([title containsString:@"\\n"]) {
        desTitle = [title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }
    
    NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:desTitle attributes:@{NSForegroundColorAttributeName:contentTiew.textColor, NSFontAttributeName:[UIFont cellContentFont]}];
    NSMutableArray *clickArray = [IMCellDataHelper getMatchContent:title];
    if (clickArray.count > 0) {
        for (NSInteger i=0;i<clickArray.count;i++) {
            NSString *url = [clickArray objectAtIndex:i];
            NSRange ansRange = [title rangeOfString:url];
            [totalContent addAttribute:NSLinkAttributeName value:@"uccLinkString://" range:ansRange];
        }
    }
    contentTiew.attributedText = totalContent;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [IMCellDataHelper getMenuList:_currentModel.mainInfo];
    
    NSDictionary *mianInfoDic = [_currentModel.mainInfo JSONValue];
    NSString *showType = [mianInfoDic objectForKey:@"showType"];
    if ([showType isEqualToString:@"C"]) {
        // 评论反馈 显示菜单展示的方式 C:emoji横排展示
        return 1;
    }
    
    // 判断按钮是否是 yes no. 决定是否进行一行展示排版
    BOOL isYesFlag = false;
    BOOL isNoFlag = false;
    for (int i = 0 ; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        if ([[title lowercaseString] isEqualToString:@"yes"]) {
            isYesFlag = true;
        }
        if ([[title lowercaseString] isEqualToString:@"no"]) {
            isNoFlag = true;
        }
    }
    BOOL isFlag = isYesFlag && isNoFlag;
    
    if (_currentModel.showHelpful || isFlag) {
        return 1;
    }
    return [IMCellDataHelper getMenuList:_currentModel.mainInfo].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *mianInfoDic = [_currentModel.mainInfo JSONValue];
    NSString *showType = [mianInfoDic objectForKey:@"showType"];
    // 判断是否是评分反馈
    if ([showType isEqualToString:@"C"]) {
        // URL的emoji表情
        IMLinkMenuFeedBackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMLinkMenuFeedBackTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        // 取title判断是否是http URL
        NSArray *array = [IMCellDataHelper getMenuList:_currentModel.mainInfo];
        NSDictionary *dic = [array objectAtIndex:0];
        NSString *title = [dic objectForKey:@"title"];
        if (title && ([title containsString:@"http"] || [title containsString:@"https"])) { // URL的emoji表情 还是 非URL的emoji表情
            cell.isURLEmoji = YES;
        } else {
            cell.isURLEmoji = NO;
        }
        [cell setContentWithModel:_currentModel indexPath:indexPath];
        return cell;
    }
    
    IMlinkMenuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMlinkMenuListCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setContentWithModel:_currentModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    NSDictionary *dic = [[IMCellDataHelper getMenuList:_currentModel.mainInfo] objectAtIndex:indexPath.row];
//
//    NSString *content = [NSString imStringWithoutNil:[dic objectForKey:@"content"]];
//    NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
//
//    NSRange chatRange = [content rangeOfString:@"webchat://"];
//    if (chatRange.location == NSNotFound ) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:title];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":title, @"content":content}];
//    }
}

// 构建本地消息
- (void)ConstructsLocalMessageByHeader:(NSString *)headerTitle title:(NSString *)sendText {
    NSMutableArray *newMessages = [[NSMutableArray alloc] init];
    //点击的内容
    IMMsgModel *modelUser = [[IMMsgModel alloc] initText];
    modelUser.isSeen = YES;
    modelUser.mainInfo = isEmptyString_IM(sendText)?@"":sendText;
    modelUser.cellHeight = [IMCellHeightHelper getCellHeight:modelUser];
    [newMessages addObject:modelUser];
    
    NSDictionary *contentDic = @{@"contentType":@"6",@"header":headerTitle,@"menu":@[@{@"title":@"Start a new conversation",@"content":@"webchat://#START"},@{@"title":@"Leave and close chat",@"content":@"webchat://#"}],@"msgId":@"181B90BE-C61B-47AE-A09E-D27C9B362F7C"};
    NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
    NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
    [fullDic setObject:dicString forKey:@"mainInfo"];
    // 计算mode cell的高度
    NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
    NSString *title = [mainInfoDic objectForKey:@"header"];
    CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    NSArray *array = [mainInfoDic objectForKey:@"menu"];

    // 消息构造
    IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
    model.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+array.count*40+kCellSpace10;
    model.msgType = IMMsgContentType_linkList;
    model.createType = IMMsgCreateType_server;
    [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
    
    [newMessages addObject:model];
    if (newMessages.count > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
    }
}

#pragma mark -  IMlinkMenuListCellDelegate
// emoji 评论反馈。点击emoji表情触发
- (void)IMLinkMenuFeedBackButtonClickByModel:(IMMsgModel *)model buttonTag:(NSInteger)buttonTag isURLEmoji:(BOOL)isURLEmoji indexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *mianInfoDic = [model.mainInfo JSONValue];
    NSString *showType = [mianInfoDic objectForKey:@"showType"];
    
    
    NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
    NSInteger index = buttonTag - 5000;
    NSDictionary *itemDic = [array objectAtIndex:index];
    
    NSString *realContent = [itemDic objectForKey:@"content"];
    NSString *title = [itemDic objectForKey:@"title"];
    NSString *sendText = @"";
    if (isURLEmoji) {
        sendText = [NSString stringWithFormat:@"Emoji_%@",title];
    } else {
        sendText = title;
    }
    
    
//    IMMsgModel *sendModel = [[IMMsgModel alloc] initText];
//    sendModel.mainInfo = title;
//    sendModel.cellHeight = kCellMinHeight;
//    [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:sendModel];
    // 发送消息 刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":sendText, @"content":realContent}];
    
    
    
//    if ([showType isEqualToString:@"C"]) {
//        NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
//        NSInteger index = buttonTag - 5000;
//        NSDictionary *itemDic = [array objectAtIndex:index];
//        // 评论反馈 显示菜单展示的方式 C:emoji横排展示
//        NSMutableArray *newMessages = [[NSMutableArray alloc] init];
//        // 消息构造
//        NSDictionary *contentDic = @{@"contentType":@"6",@"header":@"",@"showType":@"C",@"menu":@[itemDic],@"msgId":model.msgId};
//        NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
//        NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
//        [fullDic setObject:dicString forKey:@"mainInfo"];
//
//        IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
//        model.cellHeight = kCellMinHeight;
//        model.msgType = IMMsgContentType_linkList;
//        model.createType = IMMsgCreateType_user;
//        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
//        [newMessages addObject:model];
//        if (newMessages.count > 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
//        }
//        // 发送消息 刷新界面
//        NSString *realContent = [itemDic objectForKey:@"content"];
//        NSString *sendText = [NSString stringWithFormat:@"Emoji_%@",realContent];
//        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:sendText];
//    }
}

// 菜单按钮点击事件
- (void)linkMenuListCellButtonClickByModel:(IMMsgModel *)model buttonTag:(NSInteger)buttonTag indexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
    // 判断按钮是否是 yes no. 决定是否进行一行展示排版
    BOOL isYesFlag = false;
    BOOL isNoFlag = false;
    for (int i = 0 ; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        if ([[title lowercaseString] isEqualToString:@"yes"]) {
            isYesFlag = true;
        }
        if ([[title lowercaseString] isEqualToString:@"no"]) {
            isNoFlag = true;
        }
    }
    BOOL isFlag = isYesFlag && isNoFlag;
    
    //
    if (!isFlag) {
        NSDictionary *dic = [[IMCellDataHelper getMenuList:model.mainInfo] objectAtIndex:indexPath.row];
        NSString *realContent = [NSString imStringWithoutNil:[dic objectForKey:@"content"]];
        realContent = [realContent stringByReplacingOccurrencesOfString:@"webchat://" withString:@""];
        if ([realContent containsString:@"FileComplaint"]) {            
            [IMTapMorePushVC pushVCWithRouter:@{@"router":@"TicketCreation"}];
            return;
        } else if ([realContent containsString:@"185"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:185"]];
            return;
        } else if ([realContent containsString:@"Email"]) {
            [self sendMail];
            return;
        }
        
        NSArray *list = [realContent componentsSeparatedByString:@"##"];
        if (list.count > 1 && !isEmptyString_IM(list[1])) {
            if ([realContent containsString:@"WAIT"]) {
                // 弹出3个按钮
                // File a Self Complaint
                // Call 185 hotline
                // Email us at
                
                NSMutableArray *newMessages = [[NSMutableArray alloc] init];
                // 构造用户点击的消息
                NSString *sendText = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                IMMsgModel *modelUser = [[IMMsgModel alloc] initText];
                modelUser.isSeen = YES;
                modelUser.mainInfo = isEmptyString_IM(sendText)?@"":sendText;
                modelUser.cellHeight = [IMCellHeightHelper getCellHeight:modelUser];
                [newMessages addObject:modelUser];
                // 邮箱联系方式
				NSString *contactEmail = isEmptyString_IM([IMConfigSingleton sharedInstance].contactEmail)?@"":[IMConfigSingleton sharedInstance].contactEmail;
				NSString *emailInfo = [NSString stringWithFormat:@"Email us at %@",contactEmail];
                
                NSDictionary *contentDic = @{@"contentType":@"6",@"header":list[1],@"menu":@[@{@"title":@"File a Self Complaint",@"content":@"webchat://#FileComplaint"},@{@"title":@"Call 185 hotline",@"content":@"webchat://#185"},@{@"title":emailInfo,@"content":@"webchat://#Email"}],@"msgId":@"181B90BE-C61B-47AE-A09E-D27C9B362F7H"};
                NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
                NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
                [fullDic setObject:dicString forKey:@"mainInfo"];
                // 计算mode cell的高度
                NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
                NSString *title = [mainInfoDic objectForKey:@"header"];
                CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
                NSArray *array = [mainInfoDic objectForKey:@"menu"];

                // 消息构造
                IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
                model.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+array.count*40+kCellSpace10;
                model.msgType = IMMsgContentType_linkList;
                model.createType = IMMsgCreateType_server;
                [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
                
                [newMessages addObject:model];
                if (newMessages.count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
                }
                return;
            } else if ([realContent containsString:@"LATER"]) {
                
                // 发送一条静默 QUIT_QUEUING 消息
                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:@"QUIT_QUEUING"];
                
                
                NSMutableArray *newMessages = [[NSMutableArray alloc] init];
                // 构造用户点击的消息
                NSString *sendText = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                IMMsgModel *modelUser = [[IMMsgModel alloc] initText];
                modelUser.isSeen = NO;
                modelUser.sessionState = @"Q";
                modelUser.mainInfo = isEmptyString_IM(sendText)?@"":sendText;
                modelUser.cellHeight = [IMCellHeightHelper getCellHeight:modelUser];
                [newMessages addObject:modelUser];
                
                NSDictionary *contentDic = @{@"contentType":@"6",@"header":list[1],@"menu":@[@{@"title":@"Yes",@"content":@"webchat://Yes"},@{@"title":@"No",@"content":@"webchat://Nope"}],@"msgId":@"181B90BE-C61B-47AE-A09E-D27C9B362F7H"};
                NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
                NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
                [fullDic setObject:dicString forKey:@"mainInfo"];
                // 计算mode cell的高度
                NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
                NSString *title = [mainInfoDic objectForKey:@"header"];
                CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
                
                // 消息构造
                IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
                model.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
                model.msgType = IMMsgContentType_linkList;
                model.createType = IMMsgCreateType_server;
                [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
                [newMessages addObject:model];
                if (newMessages.count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
                }
                
                return;
                
            } else if ([realContent containsString:@"HELP_NO"]) {
                
                NSString *sendText = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                [self ConstructsLocalMessageByHeader:list[1] title:sendText];
                return;
                
            } else {
//                [self ConstructsLocalMessageByHeader:list[1]];
                NSMutableArray *newMessages = [[NSMutableArray alloc] init];
                // 构造用户点击的消息
                NSString *sendText = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                IMMsgModel *modelUser = [[IMMsgModel alloc] initText];
                modelUser.isSeen = YES;
                modelUser.mainInfo = isEmptyString_IM(sendText)?@"":sendText;
                modelUser.cellHeight = [IMCellHeightHelper getCellHeight:modelUser];
                [newMessages addObject:modelUser];
                
                
                NSDictionary *contentDic = @{@"contentType":@"6",@"header":list[1],@"menu":@[@{@"title":@"Yes",@"content":@"webchat://#START"},@{@"title":@"No",@"content":@"webchat://#No##Is there anything else that I can help you with?"}],@"msgId":@"181B90BE-C61B-47AE-A09E-D27C9B362F7C"};
                NSString *dicString = [NSString dictionaryToJsonWithOutSpace:contentDic];
                NSMutableDictionary *fullDic = [@{@"msgType":@"6",@"sessionState":@"C"} mutableCopy];
                [fullDic setObject:dicString forKey:@"mainInfo"];
                // 计算mode cell的高度
                NSDictionary *mainInfoDic = [fullDic[@"mainInfo"] JSONValue];
                NSString *title = [mainInfoDic objectForKey:@"header"];
                CGSize titleSize = [title sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];

                // 消息构造
                IMMsgModel *model = [[IMMsgModel alloc] initWithMsgDic:fullDic];
                model.cellHeight = kCellSpace10+titleSize.height+kCellSpace10+40+kCellSpace10;
                model.msgType = IMMsgContentType_linkList;
                model.createType = IMMsgCreateType_server;
                [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
                [newMessages addObject:model];
                if (newMessages.count > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
                }
                
                return;
            }
        }
    }
    
    // 解析区分helpful的model
    if (model.showHelpful || isFlag) {
        NSDictionary *dic = @{};
        if ((buttonTag - indexPath.row) == 100) {
            // button1
            dic = [[IMCellDataHelper getMenuList:model.mainInfo] objectAtIndex:0];
        }
        if ((buttonTag - indexPath.row) == 200) {
            // button2
            dic = [[IMCellDataHelper getMenuList:model.mainInfo] objectAtIndex:1];
        }
        
        NSString *realContent = [NSString imStringWithoutNil:[dic objectForKey:@"content"]];
        realContent = [realContent stringByReplacingOccurrencesOfString:@"webchat://" withString:@""];
        
        NSArray *list = [realContent componentsSeparatedByString:@"##"];
        if (list.count > 1 && !isEmptyString_IM(list[1])) {
            // 处理排队等待的需求，每个5分钟发一条询问消息，点击NO
            NSString *sendText = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
            [self ConstructsLocalMessageByHeader:list[1] title:sendText];
        } else {
            IMMsgModel *sendModel = [[IMMsgModel alloc] initText];
            sendModel.mainInfo = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
            sendModel.cellHeight = [IMCellHeightHelper getCellHeight:sendModel];
            [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:sendModel];
            // 调接口 message/{msgId}/helpful
            if (model.showHelpful) {
                [self submitHelpfulResultByMsgId:model.msgId messageId:model.messageId helpful:realContent flowNo:self.flowNo];
            }
            // 发送消息 刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":sendModel.mainInfo, @"content":realContent}];
        }
        
    } else {
        
        NSDictionary *dic = [[IMCellDataHelper getMenuList:model.mainInfo] objectAtIndex:indexPath.row];
        NSString *content = [NSString imStringWithoutNil:[dic objectForKey:@"content"]];
        NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        
        if ([content containsString:@"#START"]) {
            NSMutableArray *newMessages = [[NSMutableArray alloc] init];
            // 构造用户点击的消息
            IMMsgModel *modelUser = [[IMMsgModel alloc] initText];
            modelUser.isSeen = YES;
            modelUser.mainInfo = isEmptyString_IM(title)?@"":title;
            modelUser.cellHeight = [IMCellHeightHelper getCellHeight:modelUser];
            [newMessages addObject:modelUser];
            if (newMessages.count > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:newMessages];
            }
        }
        
    
        NSRange chatRange = [content rangeOfString:@"webchat://"];
        if (chatRange.location == NSNotFound ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:title];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendMenuText object:@{@"title":title, @"content":content}];
        }
    }
}

// helpful收集答案是否有帮助
- (void)submitHelpfulResultByMsgId:(NSString *)msgId messageId:(NSString *)messageId helpful:(NSString *)helpful flowNo:(NSString *)flowNo {
    [IMHttpRequest postHttpUrl:[NSString stringWithFormat:@"message/%@/helpful", msgId] param:@{@"messageId":messageId, @"msgId":msgId,@"helpful":helpful,@"flowNo":flowNo} block:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"helpful 接口调用失败");
            } else {
            }
    }];
}

#pragma mark - UITextViewDelegate 点富文本
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
  
    if ([[URL scheme] isEqualToString:@"uccLinkString"]) {
        [textView.text enumerateSubstringsInRange:characterRange options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [self openWithUrl:substring];
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


- (void)sendMail {
    //先验证邮箱能否发邮件，不然会崩溃
    if (![MFMailComposeViewController canSendMail]) {
        //       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未配置邮箱账户，是否现在跳转邮箱配置？" preferredStyle:UIAlertControllerStyleAlert];
        //       [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //       }]];
        //       [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        //       [self presentViewController:alert animated:YES completion:nil];
        NSURL *url = [NSURL URLWithString:@"mailto://"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //收件人邮箱，使用NSArray指定多个收件人
	NSString *contactEmail = isEmptyString_IM([IMConfigSingleton sharedInstance].contactEmail)?@"":[IMConfigSingleton sharedInstance].contactEmail;
	
    NSArray *toRecipients = [NSArray arrayWithObject:contactEmail];
    [picker setToRecipients:toRecipients];
    //   //抄送人邮箱，使用NSArray指定多个抄送人
    //   NSArray *ccRecipients = [NSArray arrayWithObject:@"888888888@qq.com"];
    //   [picker setToRecipients:ccRecipients];
    //   //密送人邮箱，使用NSArray指定多个密送人
    //   NSArray *bccRecipients = [NSArray arrayWithObject:@"888888888@qq.com"];
    //   [picker setToRecipients:bccRecipients];
    //邮件主题
    //   [picker setSubject:@"邮件主题"];
    //   //邮件正文，如果正文是html格式则isHTML为yes，否则为no
    //   [picker setMessageBody:@"邮件正文" isHTML:NO];
    //添加附件，附件将附加到邮件的结尾
    //   NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"icon.jpg"], 1.0);
    //   [picker addAttachmentData:data mimeType:@"image/jpeg" fileName:@"new.png"];
    [[HJTool currentVC] presentViewController:picker animated:YES completion:nil];
}

//代理
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    NSLog(@"send mail error:%@", error);
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存成功");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送成功");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        default:
            NSLog(@"邮件未发送");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
