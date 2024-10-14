//
//  IMVOIPSubTableViewCell.m
//  CLP
//
//  Created by 李标 on 2023/4/17.
//

#import "IMVOIPSubTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import <DXPFontManagerLib/FontManager.h>

@interface IMVOIPSubTableViewCell () {
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong) IMMsgModel *currentModel;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@end

@implementation IMVOIPSubTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        
        // 按钮1
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitleColor:UIColorFromRGB_IM(0x0038A8) forState:UIControlStateNormal];
		_button1.titleLabel.font = [FontManager setMediumFontSize:12];
        _button1.layer.cornerRadius=16;
        _button1.layer.borderColor= UIColorFromRGB_IM(0x0038A8).CGColor;
        _button1.layer.borderWidth=1.0;
        _button1.userInteractionEnabled = YES;
        [_button1 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = @"No";
        CGSize contentSize = [title singleSizeWithFont:[UIFont cellContentFont]];
        _button1.frame = CGRectMake(0, 10, contentSize.width + 24, 31);
        _button1.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [_button1 setTitle:title forState:UIControlStateNormal];
        _button1.tag = IMVOIPAgreeButtonType_No;
        
        // 按钮2
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button2 setTitleColor:UIColorFromRGB_IM(0x0038A8) forState:UIControlStateNormal];
		_button2.titleLabel.font = [FontManager setMediumFontSize:12];
        _button2.titleLabel.adjustsFontSizeToFitWidth = YES;
        _button2.layer.cornerRadius=16;
        _button2.layer.borderColor= UIColorFromRGB_IM(0x0038A8).CGColor;
        _button2.layer.borderWidth=1.0;
        _button2.layer.masksToBounds=YES;
        _button2.userInteractionEnabled = YES;
        [_button2 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title2 = @"Yes";
        CGSize contentSize2 = [title2 singleSizeWithFont:[UIFont cellContentFont]];
        _button2.frame = CGRectMake(CGRectGetMaxX(_button1.frame)+10, 10, contentSize2.width + 24, 31);
        _button2.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [_button2 setTitle:title2 forState:UIControlStateNormal];
        _button2.tag = IMVOIPAgreeButtonType_Yes;
        
        [self.contentView addSubview:_button1];
        [self.contentView addSubview:_button2];
    }
    return self;
}

- (void)handleAction:(UIButton *)sender {
    kPreventRepeatClickTime(3);
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(VOIPSubTableViewCellEventByTag:target:)]) {
        [self.delegate VOIPSubTableViewCellEventByTag:button.tag target:self];
    }
}

@end
