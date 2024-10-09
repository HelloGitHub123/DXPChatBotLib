//
//  IMUserInfoTableViewCell.h
//  CLP
//
//  Created by 李标 on 2021/12/16.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class IMUserInfoTableViewCell;

@protocol IMUserInfoSubmitDelegate <NSObject>
// 提交用户数据
- (void)SubmitUserInfoAction:(IMUserInfoTableViewCell *)cell firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress mobileNumber:(NSString *)mobileNumber birthday:(NSString *)birthday;
@end

@interface IMUserInfoTableViewCell : IMTableViewCell

@property (nonatomic, assign) id<IMUserInfoSubmitDelegate> delegate;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
