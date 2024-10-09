//
//  IMCellDataHelper.h
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMCellDataHelper : NSObject

//两个方法,用于处理msgtype为6的时候，菜单
+ (NSArray *)getMenuList:(NSString *)jsonString;

+ (NSString *)getMenuHeaderContent:(NSString *)jsonString;

//用于处理消息时间
+ (NSString *)getCellHeaderDate:(NSString *)dateStr;

//是否显示消息时间，5分钟内则不显示
+ (BOOL)getMsgTimeIsShow:(NSString *)createTime;

//识别链接
+ (NSMutableArray *)getMatchContent:(NSString *)content;

//识别链接
+ (BOOL)getMainInfoIsHtml:(NSString *)mainInfo;

//识别是否是url
+ (BOOL)verifyWebUrlAddress:(NSString *)webUrl;

//获取a标签
+ (NSString *)getMatchHTML:(NSString *)html href:(NSString *)href;

@end

NS_ASSUME_NONNULL_END
