//
//  IMChatDBManager.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMsgModel.h"

@interface IMChatDBManager : NSObject

+ (BOOL)insertChatDBWithUserId:(NSString*)userId model:(IMMsgModel *)model;

+ (NSMutableArray *)queryMJHeaderChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime;

+ (NSMutableArray *)queryMJFooterChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime;

+ (NSString *)queryLastDataTimeWithUserId:(NSString *)userId;

+ (void)updateCellHeightWithUserId:(NSString *)userId msgId:(NSString *)msgId cellHeight:(NSInteger)cellHeight;

+ (void)updateMainInfoWithUserId:(NSString *)userId msgId:(NSString *)msgId mainInfo:(NSString *)mainInfo;

+ (void)updateIsSubmitWithUserId:(NSString *)userId msgId:(NSString *)msgId isSubmit:(BOOL)isSubmit;

+ (void)updateExtendWithUserId:(NSString *)userId msgId:(NSString *)msgId extend:(NSString *)extend;

+ (void)updateExtendWithUserId:(NSString *)userId msgId:(NSString *)msgId isHtmlReload:(BOOL)isHtmlReload ;

// 更新已读未读状态
+ (void)updateSeenWithUserId:(NSString *)userId msgSeenId:(NSString *)msgSeenId isSeen:(BOOL)isSeen;

//搜索历史数据
+ (NSMutableArray *)querySearchChatDBWithUserId:(NSString *)userId key:(NSString *)key;

//点击搜索历史数据，返回列表展示
+ (NSMutableArray *)queryAllSearchChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime;

// 根据userId 查询所有记录
+ (NSMutableArray *)queryAllResultDBWithUserId:(NSString *)userId;

@end
