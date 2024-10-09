//
//  IMDisLikeTableViewCell.h
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMDisLikeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITableView *tableView;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
