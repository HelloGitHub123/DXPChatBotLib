//
//  IMHistoryTableViewCell.m
//  CLP
//
//  Created by mac on 2021/5/12.
//

#import "IMHistoryTableViewCell.h"
#import "UCCHeader.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import "FontManager.h"
#import "IMConfigSingleton.h"

@implementation IMHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = UIColorFromRGB_IM(0xffffff);
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 32, 32)];
        [self.contentView addSubview:_logoView];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(56, 16, kMainScreenWidth-56-136, 20)];
		_nameLab.font = [FontManager setMediumFontSize:13];
        _nameLab.textColor = UIColorFromRGB_IM(0x929292);
        [self.contentView addSubview:_nameLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-131, 16, 115, 20)];
		_timeLab.font = [FontManager setMediumFontSize:13];
        _timeLab.textColor = UIColorFromRGB_IM(0x929292);
        _timeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLab];
        
        _textLab = [[UILabel alloc] init];
		_textLab.font = [FontManager setMediumFontSize:14];
        _textLab.numberOfLines = 0;
        [self.contentView addSubview:_textLab];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB_IM(0xF0F0F0);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel *)model key:(NSString *)key {
    if ([model.sessionState isEqualToString:@"S"] && model.createType == IMMsgCreateType_server) {
        _logoView.image = [UIImage imageNamed:@"onlineLogo"];
		
		NSString *appName = isEmptyString_IM([IMConfigSingleton sharedInstance].appName)?@"":[IMConfigSingleton sharedInstance].appName;
		
        _nameLab.text = [NSString stringWithFormat:@"%@-%@", appName ,model.nickName];
    } else {
        _logoView.image = [UIImage imageNamed:@"userHeadIcon"];
        _nameLab.text = @"Me";
    }
    
    _timeLab.text = [IMCellDataHelper getCellHeaderDate:model.createTime];
    
	CGSize textSize= [model.mainInfo sizeForWidth:kMainScreenWidth-56-16 withFont:[FontManager setMediumFontSize:14]];
    _textLab.frame = CGRectMake(56, 40, kMainScreenWidth-56-16, textSize.height);
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:UIColorFromRGB_IM(0x3E3E3E)};
    NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:model.mainInfo attributes:attributes];
    NSRange keyRange = [[model.mainInfo lowercaseString] rangeOfString:[key lowercaseString]];
    [totalContent addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB_IM(0xCE1126) range:keyRange];
    _textLab.attributedText = totalContent;
    
    _lineView.frame = CGRectMake(0, CGRectGetMaxY(_textLab.frame)+4.5, kMainScreenWidth, 0.5);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
