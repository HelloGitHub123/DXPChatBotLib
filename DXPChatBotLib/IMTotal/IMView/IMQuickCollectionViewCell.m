//
//  IMQuickCollectionViewCell.m
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMQuickCollectionViewCell.h"
#import "UCCHeader.h"
#import "NSString+IM.h"
#import "FontManager.h"

@implementation IMQuickCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB_IM(0x0038A8);
		_titleLabel.font = [FontManager setMediumFontSize:14];
        _titleLabel.layer.backgroundColor = UIColorFromRGB_IM(0xFFFFFF).CGColor;
        _titleLabel.layer.borderColor = UIColorFromRGB_IM(0x0038A8).CGColor;
        _titleLabel.layer.borderWidth = 1.0;
        _titleLabel.layer.cornerRadius = 16;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setContentWithDic:(NSDictionary *)dic {
    NSString *questionMsg = [NSString imStringWithoutNil:[dic objectForKey:@"questionMsg"]];
	CGSize titleSize = [questionMsg singleSizeWithFont:[FontManager setMediumFontSize:14]];
    _titleLabel.frame = CGRectMake(0, 0, titleSize.width+18, 34);
    _titleLabel.text = questionMsg;
}

@end
