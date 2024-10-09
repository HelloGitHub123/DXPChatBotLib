//
//  IMMenuBtnTableViewCell.h
//  CLP
//
//  Created by 李标 on 2021/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IMMenuBtnTableViewCell;

@protocol IMMenuBtnCellDelegate <NSObject>
// 菜单按钮点击事件
- (void)menuButtonClickByTarget:(IMMenuBtnTableViewCell *)cell indexPath:(nonnull NSIndexPath *)indexPath;
@end

@interface IMMenuBtnTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, assign) id<IMMenuBtnCellDelegate> delegate;

- (void)setContenWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
