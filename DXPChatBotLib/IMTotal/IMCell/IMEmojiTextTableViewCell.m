//
//  IMEmojiTextTableViewCell.m
//  CLP
//
//  Created by 李标 on 2023/2/1.
//

#import "IMEmojiTextTableViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface IMEmojiTextTableViewCell () {
    IMMsgModel *_currentModel;
}

@end

@implementation IMEmojiTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];

    if ([model.mainInfo containsString:@"Emoji_"]) {
        // 评论反馈  emoji表情打分
        NSString *imgSrc = [model.mainInfo stringByReplacingOccurrencesOfString:@"Emoji_" withString:@""];
        UIImageView *imgview = [[UIImageView alloc] init];
        [imgview setFrame:CGRectMake(0, 10, 30, 30)];
        NSURL *url = [NSURL URLWithString:imgSrc];
        [imgview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        _cellBgView.frame = CGRectMake(kMainScreenWidth-64-kCellSpace10*3 , 0, 30, 30);
        _cellBgView.backgroundColor = [UIColor clearColor];
        [_cellBgView addSubview:imgview];
        return;
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
