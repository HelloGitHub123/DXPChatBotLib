//
//  IMMenuBtnListTableViewCell.h
//  CLP
//
//  Created by 李标 on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMMenuBtnListTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;

- (void)setContentWithModel:(IMMsgModel*)model operList:(NSArray *)operList indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
