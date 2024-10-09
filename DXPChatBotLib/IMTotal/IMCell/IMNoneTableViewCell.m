//
//  IMNoneTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMNoneTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"

@implementation IMNoneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
        
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont cellContentFont];
        [_cellBgView addSubview:_contentLab];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    
    //头像
    [self setContentHeadIconWithModel:model];

    //聊天背景
    CGSize contentSize = [model.mainInfo singleSizeWithFont:[UIFont cellContentFont]];
    CGFloat contentWidth = (contentSize.width+kCellSpace10*2)<kCellMaxWidth?(contentSize.width+kCellSpace10*2):kCellMaxWidth;
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, contentWidth, kCellMinHeight);
        _cellBgView.backgroundColor = [UIColor  cellServerBackgroundColor];
        
        _contentLab.textColor = [UIColor cellServerContextColor];
    } else if (model.createType == IMMsgCreateType_user) {
        _cellBgView.frame = CGRectMake(kMainScreenWidth-(contentWidth+kCellSpace10*2)-64, 0, contentWidth+kCellSpace10*2, kCellMinHeight);
        _cellBgView.backgroundColor = [UIColor  cellUserBackgroundColor];
        
        _contentLab.textColor = [UIColor cellUserContentColor];
    }
    
    //内容
    _contentLab.text = model.mainInfo;
    _contentLab.frame = CGRectMake(kCellSpace10, kCellSpace10, contentWidth, kCellMinHeight-kCellSpace10*2);
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
