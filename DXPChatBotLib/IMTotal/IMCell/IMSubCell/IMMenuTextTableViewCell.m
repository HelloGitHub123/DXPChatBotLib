//
//  IMMenuTextTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMMenuTextTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "FontManager.h"

@implementation IMMenuTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kMaxCellWidthNoIcon-32, 40)];
		_titleLab.font = [FontManager setMediumFontSize:14];
        _titleLab.textColor = UIColorFromRGB_IM(0x929292);
        _titleLab.layer.cornerRadius = 20;
        _titleLab.layer.borderWidth = 1;
        _titleLab.layer.borderColor = UIColorFromRGB_IM(0x929292).CGColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 0;
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)setContentWithArray:(NSMutableArray *)array isTypeQ:(BOOL)isTypeQ indexPath:(NSIndexPath *)indexPath {
    IMSatisfyMenuModel *subModel = [array objectAtIndex:indexPath.row];
    
    _titleLab.text = subModel.title;
    
    // F表示评分项；Q表示改进项
    if (subModel.isSelect) {
        if (isTypeQ) {
//            _selectView.image = [UIImage imageNamed:@"ic_service_choose"];
            _titleLab.textColor = UIColorFromRGB_IM(0xCE1126);
            _titleLab.layer.borderColor = UIColorFromRGB_IM(0xCE1126).CGColor;
        } else {
//            _selectView.image = [UIImage imageNamed:@"ic_service_radio"];
            _titleLab.textColor = UIColorFromRGB_IM(0xCE1126);
            _titleLab.layer.borderColor = UIColorFromRGB_IM(0xCE1126).CGColor;
        }
    } else {
        _titleLab.textColor = UIColorFromRGB_IM(0x929292);
        _titleLab.layer.borderColor = UIColorFromRGB_IM(0x929292).CGColor;
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
