//
//  IMEmojiTextTableViewCell.h
//  CLP
//
//  Created by 李标 on 2023/2/1.
//  反馈emoji 表情user端显示cell

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"
#import "IMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMEmojiTextTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIView *cellBgView;
@property (nonatomic, strong) UITextView *contentTiew;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
