//
//  IMRequestDataHelper.m
//  IMDemo
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMRequestDataHelper.h"
#import "IMHttpRequest.h"
#import "NSString+IM.h"
#import "IMChatDBManager.h"
#import "IMConfigSingleton.h"
#import "IMCellHeightHelper.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"
#import "IMSatisfyMenuModel.h"
#import <YYModel/YYModel.h>
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>

@implementation IMRequestDataHelper

/*
 * 文本
 */
+ (void)sendMessagesWithText:(NSString *)text webChat:(NSString *)webChat flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock {
    
    NSString *realContent = webChat.length == 0?text:webChat;
    realContent = [realContent stringByReplacingOccurrencesOfString:@"webchat://" withString:@""];
    if ([realContent.uppercaseString isEqualToString:@"#START"]) {
        realContent = @"#";
    }
    NSLog(@"----发送内容为:%@,\n----实际内容为:%@",text,realContent);
    
    if (isEmptyString_IM(flowNo)) {
        // 如果未登录状态，保持发送的消息可以展示在界面上。
        IMMsgModel *model = [[IMMsgModel alloc] initText];
        model.mainInfo = text;
        model.cellHeight = [IMCellHeightHelper getCellHeight:model];
        resultBlock(YES, model);
        return;
    }
    
    [IMHttpRequest sendMessage:realContent flowNo:flowNo createTime:[NSString getCreateTime] msgType:IMMsgContentType_text block:^(NSError * _Nonnull error, NSString *msgSeenId) {
        if (error) {
            resultBlock(NO, nil);
        } else {
            IMMsgModel *model = [[IMMsgModel alloc] initText];
            model.mainInfo = text;
            model.cellHeight = ([text containsString:@"Emoji_"]) ? kCellMinHeight : [IMCellHeightHelper getCellHeight:model];
            if ([IMConfigSingleton sharedInstance].sessionS) {
                model.sessionState = @"S";
                // 人工
                if (model.createType == IMMsgCreateType_user) {
                    model.isSeen = NO;
                }
            } else {
                model.sessionState = @"C";
                if (model.createType == IMMsgCreateType_user) {
                    model.isSeen = YES;
                }
            }
            model.msgSeenId = msgSeenId;
            NSLog(@"发送的msgSeenId为：%@",msgSeenId);
            [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
            resultBlock(YES, model);
        }
    }];
}

/*
 * 图片
 */
+ (void)sendMessagesWithImage:(UIImage *)image flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [IMHttpRequest sendImage:encodedImageStr flowNo:flowNo createTime:[NSString getCreateTime] block:^(NSError * _Nonnull error) {
        UIImage *sendImage = image;
        BOOL sendSuccess = YES;
        if (error) {
            sendSuccess = NO;
            sendImage = [UIImage imageNamed:@"icon_fail"];
        }
        IMMsgModel *model = [[IMMsgModel alloc] initImage];
        model.cellHeight = [IMCellHeightHelper getCellHeight:model];
        [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
        SDImageCache *imageCache = [[SDWebImageManager sharedManager] imageCache];
        [imageCache storeImage:sendImage forKey:model.msgId completion:nil];
        resultBlock(sendSuccess, model);
    }];
}

/*
 * 满意度
 */
+ (void)sendMessagesWithSatisfyModel:(IMMsgModel *)msgModel flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock {
        
    NSString *content = @"";
    NSString *title = @"";
    NSInteger msgType = IMMsgContentType_text;
    if (msgModel.msgType == IMMsgContentType_linkList) {
        if (msgModel.satisfyMainInfoModel.isTypeQ) {
            NSMutableArray *contentArray = [[NSMutableArray alloc] init];
            NSMutableArray *titleArray = [[NSMutableArray alloc] init];
            for (IMSatisfyMenuModel *model in msgModel.satisfyMainInfoModel.menu) {
                if (model.isSelect) {
                    [contentArray addObject:model.index];
                    [titleArray addObject:model.title];
                }
            }
            if ([msgModel.satisfyMainInfoModel.questionText isEqualToString:@"Y"] && ![NSString isIMBlankString:msgModel.satisfyMainInfoModel.questionInput]) {
                [contentArray addObject:[NSString stringWithFormat:@"text:%@", msgModel.satisfyMainInfoModel.questionInput]];
            }
            content = [contentArray componentsJoinedByString:@","];
            title = [titleArray componentsJoinedByString:@","];
        } else {
            for (IMSatisfyMenuModel *model in msgModel.satisfyMainInfoModel.menu) {
                if (model.isSelect) {
                    content = model.index;
                    title = model.title;
                    break;
                }
            }
        }
    } else if (msgModel.msgType == IMMsgContentType_menuList) {
        msgType = 10;
        NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
        for (int i=0 ;i<msgModel.menuList.count; i++) {
            IMSatisfyMainInfoModel *infoModel = [msgModel.menuList objectAtIndex:i];
            NSString *scoreIndex = @"";
            for (IMSatisfyMenuModel *model in infoModel.menu) {
                if (model.isSelect) {
                    scoreIndex = model.index;
                    break;
                }
            }
            [contentDic setValue:@{@"scoreIndex":scoreIndex} forKey:[NSString stringWithFormat:@"%d", i+1]];
        }
        content = [NSString dictionaryToJson:contentDic];
    }
    
    if ([NSString isIMBlankString:content]) {
		[HJMBProgressHUD showText:@"Please choose first"];
		
        return;
    }
	NSLog(@"----发送内容为:%@",content);
    [IMHttpRequest sendMessage:content flowNo:flowNo createTime:[NSString getCreateTime] msgType:msgType block:^(NSError * _Nonnull error, NSString *msgSeenId) {
        if (error) {
            resultBlock(NO, nil);
        } else {
            //更新老数据
            NSString *mainInfo;
            if (msgModel.msgType == IMMsgContentType_linkList) {
                mainInfo = [msgModel.satisfyMainInfoModel yy_modelToJSONString];
            } else {
                mainInfo = [NSString dictionaryToJson:@{@"menuList":[msgModel.menuList yy_modelToJSONString]}];
            }
            msgModel.isSubmit = YES;
            msgModel.cellHeight = msgModel.cellHeight - kCellSubmitBtn + kCellSpace10;
            msgModel.mainInfo = mainInfo;
            [IMChatDBManager updateMainInfoWithUserId:[IMConfigSingleton sharedInstance].userId msgId:msgModel.msgId mainInfo:mainInfo];
            [IMChatDBManager updateIsSubmitWithUserId:[IMConfigSingleton sharedInstance].userId msgId:msgModel.msgId isSubmit:YES];
            [IMChatDBManager updateCellHeightWithUserId:[IMConfigSingleton sharedInstance].userId msgId:msgModel.msgId  cellHeight:msgModel.cellHeight];
            
            if (msgModel.msgType == IMMsgContentType_linkList) {
                //插入新数据
                NSString *showTitle = @"";
                if ([NSString isIMBlankString:msgModel.satisfyMainInfoModel.questionInput]) {
                    showTitle = title;
                } else {
                    showTitle = [NSString stringWithFormat:@"%@. %@",title,msgModel.satisfyMainInfoModel.questionInput];
                }
                // 去除字符串两端空格
                NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
                showTitle = [showTitle stringByTrimmingCharactersInSet:whitespace];
                
                IMMsgModel *model = [[IMMsgModel alloc] initText];
                model.mainInfo = isEmptyString_IM(showTitle)?@"":showTitle;
                model.cellHeight = [IMCellHeightHelper getCellHeight:model];
                [IMChatDBManager insertChatDBWithUserId:[IMConfigSingleton sharedInstance].userId model:model];
                resultBlock(YES, model);
            } else {
                resultBlock(YES, nil);
            }
        }
    }];
}

+ (void)sendMessagesWithManual:(NSString *)text flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess))resultBlock {

    [IMHttpRequest sendMessage:text flowNo:flowNo createTime:[NSString getCreateTime] msgType:IMMsgContentType_text block:^(NSError * _Nonnull error, NSString *msgSeenId) {
        if (error) {
            resultBlock(NO);
        } else {
            resultBlock(YES);
        }
    }];
}


@end
