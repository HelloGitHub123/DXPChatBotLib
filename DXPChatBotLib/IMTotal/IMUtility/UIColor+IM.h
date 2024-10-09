//
//  UIColor+IM.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIColor (IM)

/**
 *  聊天界面的背景色
 */
+ (UIColor *)chatVCBackgroundColor;

/**
 *  聊天界面TopView的背景色
 */
+ (UIColor *)chatVCTopBackgroundColor;

/**
 *  聊天界面BottomView的背景色
 */
+ (UIColor *)chatVCBottomBackgroundColor;

/**
 *  对话框Server的背景色
 */
+ (UIColor *)cellServerBackgroundColor;

/**
 *  Server的content字体颜色
 */
+ (UIColor *)cellServerContextColor;

/**
 *  对话框User的背景色
 */
+ (UIColor *)cellUserBackgroundColor;

/**
 *  User的content字体颜色
 */
+ (UIColor *)cellUserContentColor;

/**
 *  超链接字体
 */
+ (UIColor *)cellLinkContentColor;

/**
 * 分割线
 */
+ (UIColor *)cellLineColor;

/**
 * 菜单cell的背景色
 */
+ (UIColor *)menuCellBgColor;

/**
 * 菜单按钮的文本颜色
 */
+ (UIColor *)menuCellTextColor;


@end

NS_ASSUME_NONNULL_END
