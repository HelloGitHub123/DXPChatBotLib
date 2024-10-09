//
//  IMImageTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMImageTableViewCell.h"
#import "UIColor+IM.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"
#import "IMConfigSingleton.h"

@implementation IMImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _logoView = [[UIImageView alloc] init];
        _logoView.contentMode = UIViewContentModeScaleAspectFill;
        _logoView.layer.cornerRadius = 12;
        _logoView.clipsToBounds = YES;
        [self.contentView addSubview:_logoView];
    }
    return self;
}

-(void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    
    //头像
    [self setContentHeadIconWithModel:model];

    //图片
    if (model.createType == IMMsgCreateType_server) {
        _logoView.frame = CGRectMake(64, 0, kCellImageWidth, model.cellHeight);
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[IMConfigSingleton sharedInstance].fileURLStr, model.mainInfo];
        [_logoView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_normal"]];
    } else if (model.createType == IMMsgCreateType_user) {
        _logoView.frame = CGRectMake(kMainScreenWidth - kCellImageWidth -64, 0, kCellImageWidth, model.cellHeight);
        
        SDImageCache *imageCache = [[SDWebImageManager sharedManager] imageCache];
        UIImage *cacheImage = [imageCache imageFromCacheForKey:model.msgId];
        _logoView.image = cacheImage;
    }

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
