//
//  IMTopView.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天界面顶部View
 */
@interface IMTopView : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) dispatch_block_t backBlock;
@property (nonatomic, copy) dispatch_block_t historyBlock;

@end

NS_ASSUME_NONNULL_END
