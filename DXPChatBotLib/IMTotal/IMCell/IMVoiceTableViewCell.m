//
//  IMVoiceTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMVoiceTableViewCell.h"
#import "UIColor+IM.h"
#import <DXPFontManagerLib/FontManager.h>

@implementation IMVoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kMainScreenWidth-120, 20)];
		_contentLab.font = [FontManager setMediumFontSize:16];
        _contentLab.textColor = UIColorFromRGB_IM(0x333333);
        [self.contentView addSubview:_contentLab];
        
    }
    return self;
}

-(void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {

    //头像
    [self setContentHeadIconWithModel:model];
    
    _contentLab.text = model.msgId;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
