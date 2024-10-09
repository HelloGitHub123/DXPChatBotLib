//
//  UIColor+IM.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "UIColor+IM.h"
#import "UCCHeader.h"
#import "IMConfigSingleton.h"

@implementation UIColor (IM)

+ (UIColor *)chatVCBackgroundColor {
	UIColor *color = [IMConfigSingleton sharedInstance].chatVCBackgroundColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xF2F2F2);
	}
	return color;
}

+ (UIColor *)chatVCTopBackgroundColor {
	UIColor *color = [IMConfigSingleton sharedInstance].chatVCTopBackgroundColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

+ (UIColor *)chatVCBottomBackgroundColor {
	UIColor *color = [IMConfigSingleton sharedInstance].chatVCBottomBackgroundColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

+ (UIColor *)cellServerBackgroundColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellServerBackgroundColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0x0038A8);
	}
	return color;
}

+ (UIColor *)cellServerContextColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellServerContextColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

+ (UIColor *)cellUserBackgroundColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellUserBackgroundColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xCE1126);
	}
	return color;
}

+ (UIColor *)cellUserContentColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellUserContentColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

+ (UIColor *)cellLinkContentColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellLinkContentColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

+ (UIColor *)cellLineColor {
	UIColor *color = [IMConfigSingleton sharedInstance].cellLineColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xE8E8E8);
	}
	return color;
}

+ (UIColor *)menuCellBgColor {
	UIColor *color = [IMConfigSingleton sharedInstance].menuCellBgColor;
	if (!color) {
		// 默认
		return [UIColor clearColor];
	}
	return color;
}

+ (UIColor *)menuCellTextColor {
	UIColor *color = [IMConfigSingleton sharedInstance].menuCellTextColor;
	if (!color) {
		// 默认
		return UIColorFromRGB_IM(0xFFFFFF);
	}
	return color;
}

@end
