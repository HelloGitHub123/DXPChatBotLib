//
//  NSString+IM.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (IM)

+ (NSString *)imStringWithoutNil:(id)string;

+ (BOOL)isIMBlankString:(NSString *)string;

+ (NSString *)getCellIdentifier:(IMMsgModel *)model;

- (id)JSONValue;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

+ (NSString *)dictionaryToJsonWithOutSpace:(NSDictionary *)dic;

+ (NSString *)getLocalMsgId;

+ (NSString *)getCurrentTimestamp;

+ (NSString *)getCreateTime;

- (CGSize)sizeForWidth:(CGFloat)width withFont:(UIFont*)font;

- (CGSize)singleSizeWithFont:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
