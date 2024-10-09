//
//  IMTypingTableViewCell.h
//  CLP
//
//  Created by 李标 on 2022/6/22.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMTypingTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIView *cellBgView;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
