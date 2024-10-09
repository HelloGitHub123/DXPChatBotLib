//
//  IMCardCollectionViewCell.h
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCardModel.h"

NS_ASSUME_NONNULL_BEGIN

//每个卡片
@interface IMCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;

- (void)setContentWithModel:(IMCardModel *)model;

@end

NS_ASSUME_NONNULL_END
