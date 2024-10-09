//
//  IMDisLikeTextTableViewCell.m
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMDisLikeTextTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMDisLikeModel.h"
#import "FontManager.h"

@implementation IMDisLikeTextTableViewCell

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

- (void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath *)indexPath isSubmit:(BOOL)isSubmit {

    if (isSubmit) {
        _titleLab.textColor = UIColorFromRGB_IM(0xCE1126);
        _titleLab.layer.borderColor = UIColorFromRGB_IM(0xCE1126).CGColor;
        for (IMDisLikeModel *model in array) {
            if (model.isSelect) {
                _titleLab.text = model.unsatReasonName;
                break;
            }
        }
    } else {
        IMDisLikeModel *subModel = [array objectAtIndex:indexPath.section];
        _titleLab.text = subModel.unsatReasonName;
        if (subModel.isSelect) {
            _titleLab.textColor = UIColorFromRGB_IM(0xCE1126);
            _titleLab.layer.borderColor = UIColorFromRGB_IM(0xCE1126).CGColor;
        } else {
            _titleLab.textColor = UIColorFromRGB_IM(0x929292);
            _titleLab.layer.borderColor = UIColorFromRGB_IM(0x929292).CGColor;
        }
    }
    
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
