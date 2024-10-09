//
//  IMSecondCollectionViewCell.h
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMSecondCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)setContentWithModel:(IMSecondMenuModel *)model;


@end

NS_ASSUME_NONNULL_END
