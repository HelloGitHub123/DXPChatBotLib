//
//  IMRequestDataHelper.h
//  IMDemo
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMRequestDataHelper : NSObject

//发送文本
+ (void)sendMessagesWithText:(NSString *)text webChat:(NSString *)webChat flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock;

//发送图片
+ (void)sendMessagesWithImage:(UIImage *)image flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock;

//发送满意度【单个评分/改进。多个评分】
+ (void)sendMessagesWithSatisfyModel:(IMMsgModel *)msgModel flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess, IMMsgModel *sendModel))resultBlock;

//发送yes 人工客服
+ (void)sendMessagesWithManual:(NSString *)text flowNo:(NSString *)flowNo resultBlock:(void (^)(BOOL isSuccess))resultBlock;

@end

NS_ASSUME_NONNULL_END
