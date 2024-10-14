//
//  IMSecondCollectionViewCell.m
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMSecondCollectionViewCell.h"
#import "UCCHeader.h"
#import "NSString+IM.h"
#import <DXPFontManagerLib/FontManager.h>

@implementation IMSecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
		_titleLabel.font =[FontManager setMediumFontSize:14];
        [self.contentView addSubview:_titleLabel];
      
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB_IM(0xCE1126);
        _lineView.layer.cornerRadius = 1.5;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setContentWithModel:(IMSecondMenuModel *)model {
	CGSize titleSize = [model.categoryName singleSizeWithFont:[FontManager setMediumFontSize:14]];
    _titleLabel.frame = CGRectMake(0, 0, titleSize.width+10, 30);
    _lineView.frame = CGRectMake(0, 27, titleSize.width, 3);
  
    _titleLabel.text = model.categoryName;
    if (model.isSelect) {
        _titleLabel.textColor = UIColorFromRGB_IM(0xCE1126);
        _lineView.hidden = NO;
    } else {
        _titleLabel.textColor = UIColorFromRGB_IM(0x606060);
        _lineView.hidden = YES;
    }
}

@end
