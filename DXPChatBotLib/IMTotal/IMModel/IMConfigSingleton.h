//
//  IMConfigSingleton.h
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMConfigSingleton : NSObject

@property (nonatomic, copy) NSString *appName; // 项目名称(用于显示)
@property (nonatomic, copy) NSString *contactEmail; // 联系邮箱(用于发邮件)
@property (nonatomic, copy) NSString *selfUrlScheme; //本app的 URLScheme

@property (nonatomic, copy) NSString *IMSocketURL;
@property (nonatomic, copy) NSString *voipUrl; // voip Url
@property (nonatomic, copy) NSString *fileURLStr;
@property (nonatomic, copy) NSString *baseURLStr;
@property (nonatomic, copy) NSString *sysAccount;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, copy) NSString *langCode;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *accNbr;

@property (nonatomic, assign) BOOL isHiddenHistory; // 是否隐藏导航栏右上角历史按钮 默认:NO 显示

@property (nonatomic, strong) UIColor *chatVCBackgroundColor; // 聊天界面的背景色
@property (nonatomic, strong) UIColor *chatVCTopBackgroundColor;
@property (nonatomic, strong) UIColor *chatVCBottomBackgroundColor;
@property (nonatomic, strong) UIColor *cellServerBackgroundColor;
@property (nonatomic, strong) UIColor *cellServerContextColor;
@property (nonatomic, strong) UIColor *cellUserBackgroundColor;
@property (nonatomic, strong) UIColor *cellUserContentColor;
@property (nonatomic, strong) UIColor *cellLinkContentColor;
@property (nonatomic, strong) UIColor *cellLineColor;
@property (nonatomic, strong) UIColor *menuCellBgColor; // 菜单cell的背景色
@property (nonatomic, strong) UIColor *menuCellTextColor; // 菜单按钮文本颜色


@property (nonatomic, copy) NSString *dislikeMessageId;//最近被点踩消息的messageId
@property (nonatomic, assign) BOOL sessionS;//是否人工对话状态

+ (IMConfigSingleton *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
