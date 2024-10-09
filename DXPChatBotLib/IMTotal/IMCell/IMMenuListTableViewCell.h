//
//  IMMenuListTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMMenuListTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *submintBtn;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
