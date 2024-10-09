//
//  IMVOIPTableViewCell.h
//  CLP
//
//  Created by 李标 on 2023/4/17.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"
#import "IMVOIPSubTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VOIPTableViewCellDeleagte  <NSObject>

- (void)VOIPTableViewCellEventByTag:(IMVOIPAgreeButtonType)tag IMMsgModel:(IMMsgModel *)model cell:(UITableViewCell *)cell;
@end


@interface IMVOIPTableViewCell : IMTableViewCell

@property (nonatomic, strong) NSString *flowNo;
@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) id<VOIPTableViewCellDeleagte> delegate;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
