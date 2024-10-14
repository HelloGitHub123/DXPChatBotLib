//
//  IMQuestionTableViewCell.m
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMQuestionTableViewCell.h"
#import "UCCHeader.h"
#import "NSString+IM.h"
#import <DXPFontManagerLib/FontManager.h>

@implementation IMQuestionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
      
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 51.5, kMainScreenWidth-60, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB_IM(0xEBEBEB);
        [self.contentView addSubview:_lineView];
      
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-80, 52)];
		_contentLab.font = [FontManager setMediumFontSize:14];
        _contentLab.textColor = UIColorFromRGB_IM(0x606060);
        _contentLab.numberOfLines = 0;
        [self.contentView addSubview:_contentLab];
      
        _rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-75, 14, 24, 24)];
        _rightArrow.image = [UIImage imageNamed:@"ic_mylist_arrow"];
        [self.contentView addSubview:_rightArrow];
    }
    return self;
}

- (void)setContentWithModel:(IMQuestionModel*)model{
    _contentLab.text = model.questionMsg;
	CGSize contentSize = [model.questionMsg sizeForWidth:kMainScreenWidth-80 withFont:[FontManager setMediumFontSize:14]];
    CGFloat height = (contentSize.height+6)<52?(contentSize.height+6):52;
    _contentLab.frame = CGRectMake(10, (52-height)/2, kMainScreenWidth-80, height);
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
