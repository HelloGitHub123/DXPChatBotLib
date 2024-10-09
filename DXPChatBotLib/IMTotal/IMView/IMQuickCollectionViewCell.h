//
//  IMQuickCollectionViewCell.h
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMQuickCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setContentWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
