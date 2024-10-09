//
//  IMHistoryTableViewCell.h
//  CLP
//
//  Created by mac on 2021/5/12.
//

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIView *lineView;

- (void)setContentWithModel:(IMMsgModel *)model key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
