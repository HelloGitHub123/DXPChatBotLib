//
//  IMLinkMenuFeedBackTableViewCell.h
//  CLP
//
//  Created by 李标 on 2023/2/1.
//  反馈emoji 表情server端显示cell

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IMLinkMenuFeedBackCellDelegate <NSObject>
// 菜单按钮点击事件
- (void)IMLinkMenuFeedBackButtonClickByModel:(IMMsgModel *)model buttonTag:(NSInteger)buttonTag isURLEmoji:(BOOL)isURLEmoji indexPath:(nonnull NSIndexPath *)indexPath;
@end

@interface IMLinkMenuFeedBackTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IMLinkMenuFeedBackCellDelegate> delegate;
@property (nonatomic, assign) BOOL isURLEmoji; // emoji表情是否是URL链接 

- (void)setContentWithModel:(IMMsgModel *)model indexPath:(nonnull NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
