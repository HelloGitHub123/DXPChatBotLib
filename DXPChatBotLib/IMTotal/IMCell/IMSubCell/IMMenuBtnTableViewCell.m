//
//  IMMenuBtnTableViewCell.m
//  CLP
//
//  Created by 李标 on 2021/12/13.
//

#import "IMMenuBtnTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import <DXPFontManagerLib/FontManager.h>

@interface IMMenuBtnTableViewCell () {
    NSIndexPath *current_indexPath;
}

@end

@implementation IMMenuBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setTitleColor:UIColorFromRGB_IM(0x0038A8) forState:UIControlStateNormal];
		_menuBtn.titleLabel.font = [FontManager setMediumFontSize:15];
        _menuBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _menuBtn.layer.cornerRadius=16;
        _menuBtn.layer.borderColor= UIColorFromRGB_IM(0x0038A8).CGColor;
        _menuBtn.layer.borderWidth=1.0;
        _menuBtn.userInteractionEnabled = YES;
        _menuBtn.layer.masksToBounds=YES;
        [_menuBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_menuBtn];
    }
    return self;
}

- (void)setContenWithTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    
    current_indexPath = indexPath;
    
    CGSize contentSize = [title singleSizeWithFont:[UIFont cellContentFont]];
    _menuBtn.frame = CGRectMake(0, 10, contentSize.width+30, 31);
    _menuBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [_menuBtn setTitle:title forState:UIControlStateNormal];
    _menuBtn.tag = [indexPath row];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)handleAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuButtonClickByTarget:indexPath:)]) {
        [self.delegate menuButtonClickByTarget:self indexPath:current_indexPath];
    }
}

@end
