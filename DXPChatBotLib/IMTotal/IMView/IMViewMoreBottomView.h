//
//  IMViewMoreBottomView.h
//  Georgia_IOS
//
//  Created by mac on 2020/8/13.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMViewMoreBottomView : UIView

- (id)initWithJumpMenu:(NSString *)jumpMenu;

/**
    自己选择显示在那个view展示从底部向上弹出的UIView（包含遮罩）
    @param view self.view OR [UIApplication sharedApplication].keyWindow
 */
- (void)coutomshowInView:(UIView *)view;
/**
    展示从底部向上弹出的UIView（包含遮罩）
 */
- (void)showInView;
/**
 移除从底部向上弹出的UIView（包含遮罩）
 */
- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
