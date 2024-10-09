//
//  FontManager.h
//  DXPChatBot
//
//  Created by 李标 on 2024/10/8.
//  字体管理

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FontManager : NSObject

// dicFont:  @{@"Normal":@"",@"Medium":@"",@"Light":@"",@"Bold":@"",.....}
+ (void)setFontFamilyList:(NSDictionary *)dicFont;

// 设置正常字体
+ (UIFont *)setNormalFontSize:(NSInteger)size;

// 设置中型字体
+ (UIFont *)setMediumFontSize:(NSInteger)size;

// 设置轻型字体
+ (UIFont *)setLightFontSize:(NSInteger)size;

// 设置粗体字体
+ (UIFont *)setBoldFontSize:(NSInteger)size;

// 设置其他字体1
+ (UIFont *)setOther1FontSize:(NSInteger)size;

// 设置其他字体2
+ (UIFont *)setOther2FontSize:(NSInteger)size;

// 设置其他字体3
+ (UIFont *)setOther3FontSize:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
