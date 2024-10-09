//
//  UIFont+IM.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "UIFont+IM.h"
#import "UCCHeader.h"
#import "FontManager.h"

@implementation UIFont (IM)

+ (UIFont *)cellContentFont {
    return [FontManager setMediumFontSize:12];
}

+ (UIFont *)cellDateTextFont {
	return [FontManager setMediumFontSize:12];
}

+ (UIFont *)cellFontTextSize12 {
	return [FontManager setMediumFontSize:12];
}

+ (UIFont *)cellFontTextSize16 {
	return [FontManager setMediumFontSize:16];
}

@end
