//
//  IMlinkListTableViewCell.h
//  CLP
//
//  Created by mac on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IMlinkMenuListCellDelegate <NSObject>
// 菜单按钮点击事件
- (void)linkMenuListCellButtonClickByModel:(IMMsgModel *)model buttonTag:(NSInteger)buttonTag indexPath:(nonnull NSIndexPath *)indexPath;
@end

@interface IMlinkMenuListTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IMlinkMenuListCellDelegate> delegate;

- (void)setContentWithModel:(IMMsgModel *)model indexPath:(nonnull NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
