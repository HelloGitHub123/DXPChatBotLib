//
//  IMBottomView.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TextBlock) (NSString *text);

/**
 *  聊天界面底部View 【聊天输入框。。。】
 */
@interface IMBottomView : UIView

- (id)initWithFrame:(CGRect)frame block:(TextBlock)block;

- (void)setBottomEnabled;

@end

NS_ASSUME_NONNULL_END
