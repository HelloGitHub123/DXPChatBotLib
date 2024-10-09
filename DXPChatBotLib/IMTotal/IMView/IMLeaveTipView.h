//
//  IMLeaveTipView.h
//  Georgia_IOS
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMLeaveTipView : UIView

@property (nonatomic, copy) dispatch_block_t leaveBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
