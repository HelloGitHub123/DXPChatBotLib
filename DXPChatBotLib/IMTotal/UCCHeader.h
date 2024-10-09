//
//  UCCHeader.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#ifndef UCCHeader_h
#define UCCHeader_h


#define WS_IM(weakSelf)    __weak __typeof(&*self)weakSelf = self
// 字符串 对象 判断是否为空
#define objectOrNull_IM(obj)        ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr_IM(obj)    ((obj) ? (obj) : @"")
#define isNull_IM(x)                (!x || [x isKindOfClass:[NSNull class]])
#define toInt_IM(x)                 (isNull_IM(x) ? 0 : [x intValue])
#define isEmptyString_IM(x)         (IsNilOrNull_IM(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])
#define IsNilOrNull_IM(_ref)        (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define IsArrEmpty_IM(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

// 版本
#define app_Version_IM [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
#define os_Version_IM [[UIDevice currentDevice] systemVersion]
// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \

#define kScreenWidth_IM [[UIScreen mainScreen] bounds].size.width







#define kMainScreenHeight       [[UIScreen mainScreen] bounds].size.height
#define kMainScreenWidth        [[UIScreen mainScreen] bounds].size.width

#define kCellMaxWidth           (kMainScreenWidth-160)
#define kCellMinHeight          40
#define kCellSpace10            10
#define kCellSpace20            20
#define kCellSpace6             6
#define kCellSingleList         50
#define kCellQuestTextHeight    80
#define kCellSubmitBtn          70
#define kCellHeaderFooterSpace  20
#define kLeftSpace16            16
#define kMaxCellWidthNoIcon     (kMainScreenWidth-kLeftSpace16*2)

#define kCellImageWidth     (kMainScreenWidth/3)
#define kCellImageHeight    (kMainScreenWidth/4)
#define kCellFileWidth      50
#define kCellFileHeight     57

#define kHorizontalSpace        13
#define kVerticalSpace          10

#define UIColorFromRGB_IM(rgbValue)        [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha: 1.0]
#define RGB(r, g, b)                    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define COMMON_FORMATTER @"yyyy-MM-dd HH:mm:ss"
#define COMMON_DAY_FORMATTER @"yyyy-MM-dd"

#define CellIdentifierNone             @"tableViewCellIdentifier_none"
#define CellIdentifierText             @"tableViewCellIdentifier_text"
#define CellIdentifierImage            @"tableViewCellIdentifier_image"
#define CellIdentifierVoice            @"tableViewCellIdentifier_voice"
#define CellIdentifierVideo            @"tableViewCellIdentifier_video"
#define CellIdentifierFile             @"tableViewCellIdentifier_file"
#define CellIdentifierlinkList         @"tableViewCellIdentifier_linkList"
#define CellIdentifierSatisfaction     @"tableViewCellIdentifier_satisfaction"
#define CellIdentifierMenuList         @"tableViewCellIdentifier_menuList"
#define CellIdentifierDisLike          @"tableViewCellIdentifier_disLike"
#define CellIdentifierHtml             @"tableViewCellIdentifier_html"
#define CellIdentifierMenuBtnList      @"tableViewCellIdentifier_menuBtnList"
#define CellIdentifierUserInfo         @"tableViewCellIdentifier_UserInfo"
#define CellIdentifierTyping           @"tableViewCellIdentifier_typing"
#define CellIdentifierVoip             @"tableViewCellIdentifier_Voip"



#define IMNotificationReceiveMessage           @"IMNotificationReceiveMessage"
#define IMNotificationSendImage                @"IMNotificationSendImage"
#define IMNotificationReceiveQuestions         @"IMNotificationReceiveQuestions"
#define IMNotificationSendText                 @"IMNotificationSendText"
#define IMNotificationReloadData               @"IMNotificationReloadData"
#define IMNotificationDisLike                  @"IMNotificationDisLike"
#define IMNotificationSendMenuText             @"IMNotificationSendMenuText"
#define IMNotificationPopToRootView            @"IMNotificationPopToRootView"
#define IMNotificationRefrashChatArray         @"IMNotificationRefrashChatArray"
#define IMNotificationRouterDeal         @"IMNotificationRouterDeal"

/**
 *  会话内容类型
 */
typedef NS_ENUM(NSInteger, IMMsgContentType) {
    IMMsgContentType_none             =   0,
    IMMsgContentType_text             =   1,
    IMMsgContentType_image            =   2,
    IMMsgContentType_voice            =   3,
    IMMsgContentType_video            =   4,
    IMMsgContentType_file             =   5,
    IMMsgContentType_linkList         =   6, // 链接列表+单个满意度
    IMMsgContentType_menuList         =   61,// 多个满意度
    IMMsgContentType_dataPrivacy      =   62,// 隐私协议
    IMMsgContentType_commonQuestion   =   71,// 常见问题列表
    IMMsgContentType_disLike          =   72,// 点踩后,改善列表
    IMMsgContentType_quickQuesttion   =   73,// 快捷问题列表
    IMMsgContentType_userInfo         =   90,// 自定义用户资料填写
    IMMsgContentType_typing           =   96,// 是否正在输入状态
    IMMsgContentType_seen             =   97,// 已读未读
    IMMsgContentType_VOIP             =   80,// VOIP接入
    IMMsgContentType_flowNoExpired    =   301// flowNo失效
};

/**
 *  会话创建类型
 */
typedef NS_ENUM(NSInteger, IMMsgCreateType) {
    IMMsgCreateType_none        =   0,
    IMMsgCreateType_user        =   1,
    IMMsgCreateType_server      =   2,
};


/**
 *   已读 未读
 */
typedef NS_ENUM(NSInteger, IMMsgSeenType) {
    IMMsgSeenType_unSeen       =   0, // 未读
    IMMsgSeenTypee_seen        =   1, // 已读
};

#endif /* UCCHeader_h */
