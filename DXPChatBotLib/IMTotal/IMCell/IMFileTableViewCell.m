//
//  IMFileTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMFileTableViewCell.h"
#import "UIColor+IM.h"

@implementation IMFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _logoView = [[UIImageView alloc] init];
        _logoView.image = [UIImage imageNamed:@"ucc_file"];
        [self.contentView addSubview:_logoView];
    }
    return self;
}

-(void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    
    //头像
    [self setContentHeadIconWithModel:model];

    //图片
    if (model.createType == IMMsgCreateType_server) {
        _logoView.frame = CGRectMake(64, 0, kCellFileWidth, model.cellHeight);
    } else if (model.createType == IMMsgCreateType_user) {
        _logoView.frame = CGRectMake(kMainScreenWidth - kCellFileWidth - 64, 0, kCellFileWidth, model.cellHeight);
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
