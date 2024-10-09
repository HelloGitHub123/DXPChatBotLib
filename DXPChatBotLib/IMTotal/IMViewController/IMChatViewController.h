//
//  IMChatViewController.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IMMsgWebViewType) {
	IMMsgWebViewType_default       =   0, // 默认
	IMMsgWebViewType_VOIP       =   1, // VOIP
	IMMsgWebViewType_Privacy        =   2, // 隐私
};

@interface IMChatViewController : UIViewController

// 导航栏事件
@property (nonatomic, copy) void(^webViewActionBlock) (NSString *url, NSString *htmlStr, IMMsgWebViewType webviewType);
// 路由跳转
@property (nonatomic, copy) void(^routerActionBlock) (NSString *url, NSString *schemaType, UIViewController *fromVC, NSString *serviceName, NSString *needLogin);

// sessionID 如果有值，那么就说明是走的deaplink
- (id)initWithUserId:(NSString *)userId custId:(NSString *)custId accNbr:(NSString *)accNbr sessionID:(NSString *)sessionID;

@end

NS_ASSUME_NONNULL_END
