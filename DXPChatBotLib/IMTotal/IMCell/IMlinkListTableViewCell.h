//
//  IMlinkListTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMlinkListTableViewCell : IMTableViewCell

@property (nonatomic, strong) NSString *flowNo;
@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
