//
//  UIFont+IM.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (IM)

/**
 * cell的内容
 */

+ (UIFont *)cellContentFont;

/**
 *  cell的headerView的date
 */
+ (UIFont *)cellDateTextFont;

/**
 *  字体是12大小
 */
+ (UIFont *)cellFontTextSize12;

/**
 *  字体是16大小
 */
+ (UIFont *)cellFontTextSize16;

@end

NS_ASSUME_NONNULL_END
