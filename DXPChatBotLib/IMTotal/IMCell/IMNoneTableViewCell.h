//
//  IMNoneTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

//异常cell, 展示一行文字即可
@interface IMNoneTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UILabel *contentLab;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
