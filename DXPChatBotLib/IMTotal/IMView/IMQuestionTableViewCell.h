//
//  IMQuestionTableViewCell.h
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMQuestionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *rightArrow;

- (void)setContentWithModel:(IMQuestionModel*)model;


@end

NS_ASSUME_NONNULL_END
