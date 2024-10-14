//
//  IMTopView.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMTopView.h"
#import "UCCHeader.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import <DXPFontManagerLib/FontManager.h>
#import "IMConfigSingleton.h"

@interface IMTopView () {
    CGFloat topViewHeight;
}

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation IMTopView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        topViewHeight = frame.size.height;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLab];
    [self addSubview:self.historyBtn];
}

- (void)backLastVCAction {
    if (self.backBlock) self.backBlock();
}

- (void)historyVCAction {
    if (self.historyBlock) self.historyBlock();
}

#pragma mark -
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(kHorizontalSpace, topViewHeight-35, 80, 30);
        [_backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn addTarget:self action:@selector(backLastVCAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)historyBtn {
    if (!_historyBtn) {
        _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyBtn.frame = CGRectMake(kMainScreenWidth-kHorizontalSpace-60, topViewHeight-35, 60, 30);
        [_historyBtn setTitle:@"History" forState:UIControlStateNormal];
        [_historyBtn setTitleColor:UIColorFromRGB_IM(0x0038A8) forState:UIControlStateNormal];
        _historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		_historyBtn.titleLabel.font = [FontManager setMediumFontSize:14];
        [_historyBtn addTarget:self action:@selector(historyVCAction) forControlEvents:UIControlEventTouchUpInside];
		_historyBtn.hidden = [IMConfigSingleton sharedInstance].isHiddenHistory;
    }
    return _historyBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-100, topViewHeight-43, 200, 43)];
        _titleLab.text = @"Chat with us";
		_titleLab.font = [FontManager setMediumFontSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = UIColorFromRGB_IM(0x2C2C2C);
    }
    return _titleLab;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
