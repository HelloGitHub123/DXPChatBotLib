//
//  FontManager.m
//  DXPChatBot
//
//  Created by 李标 on 2024/10/8.
//

#import "FontManager.h"

static NSString *normalFamiy;
static NSString *mediumFamily;
static NSString *lightFamily;
static NSString *boldFamily;
static NSString *other1Family;
static NSString *other2Family;
static NSString *other3Family;

@implementation FontManager

+ (void)setFontFamilyList:(NSDictionary *)dicFont {
	if (dicFont.allKeys.count == 0) return;
	normalFamiy = [dicFont valueForKey:@"Normal"];
	mediumFamily = [dicFont valueForKey:@"Medium"];
	lightFamily = [dicFont valueForKey:@"Light"];
	boldFamily = [dicFont valueForKey:@"Bold"];
	other1Family = [dicFont valueForKey:@"Other1"];
	other2Family = [dicFont valueForKey:@"Other2"];
	other3Family = [dicFont valueForKey:@"Other3"];
}

// 设置正常字体
+ (UIFont *)setNormalFontSize:(NSInteger)size {
	if (!normalFamiy) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:normalFamiy size:size];
}

// 设置中型字体
+ (UIFont *)setMediumFontSize:(NSInteger)size {
	if (!mediumFamily) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:mediumFamily size:size];
}

// 设置轻型字体
+ (UIFont *)setLightFontSize:(NSInteger)size {
	if (!lightFamily) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:lightFamily size:size];
}

// 设置粗体字体
+ (UIFont *)setBoldFontSize:(NSInteger)size {
	if (!boldFamily) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:boldFamily size:size];
}

// 设置其他字体1
+ (UIFont *)setOther1FontSize:(NSInteger)size {
	if (!other1Family) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:other1Family size:size];
}

// 设置其他字体2
+ (UIFont *)setOther2FontSize:(NSInteger)size {
	if (!other2Family) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:other2Family size:size];
}

// 设置其他字体3
+ (UIFont *)setOther3FontSize:(NSInteger)size {
	if (!other3Family) {
		return [UIFont systemFontOfSize:[UIFont systemFontSize]];;
	}
	return [UIFont fontWithName:other3Family size:size];
}

@end
