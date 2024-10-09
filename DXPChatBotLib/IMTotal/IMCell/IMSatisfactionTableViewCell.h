//
//  IMSatisfactionTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/7/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMSatisfactionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submintBtn;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
