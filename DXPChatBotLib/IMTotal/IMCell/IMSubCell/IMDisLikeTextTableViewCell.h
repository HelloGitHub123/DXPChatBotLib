//
//  IMDisLikeTextTableViewCell.h
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMDisLikeTextTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;

- (void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath isSubmit:(BOOL)isSubmit;

@end

NS_ASSUME_NONNULL_END
