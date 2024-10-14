//
//  IMLeaveTipView.m
//  Georgia_IOS
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMLeaveTipView.h"
#import "NSString+IM.h"
#import <DXPFontManagerLib/FontManager.h>

@interface IMLeaveTipView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;

@end

@implementation IMLeaveTipView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColorFromRGB_IM(0x2E3B44) colorWithAlphaComponent:0.5];
        [self addSubview:self.bgView];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        self.alertView.layer.cornerRadius = 16.0;
        self.alertView.layer.masksToBounds = YES;
        self.alertView.layer.position = self.center;
        [self addSubview:self.alertView];
        
        NSString *tip = @"Conversation will close shortly Thanks for contacting us, Looking forward to help you again.";
		CGSize headerSize = [tip sizeForWidth:kCellMaxWidth-64 withFont: [FontManager setMediumFontSize:16]];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 32, kMainScreenWidth-64, headerSize.height)];
        titleLab.text = tip;
		titleLab.font =  [FontManager setMediumFontSize:16];
        titleLab.textColor = UIColorFromRGB_IM(0x2F3043);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.numberOfLines = 0;
        [self.alertView addSubview:titleLab];
        
        UIButton *leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leaveBtn.frame = CGRectMake(16, CGRectGetMaxY(titleLab.frame)+40, kMainScreenWidth-64, 46);
        [leaveBtn setTitle:@"Leave Conversation" forState:UIControlStateNormal];
        [leaveBtn setTitleColor:UIColorFromRGB_IM(0xFFFFFF) forState:UIControlStateNormal];
        leaveBtn.backgroundColor = UIColorFromRGB_IM(0xCE1126);
		leaveBtn.titleLabel.font = [FontManager setMediumFontSize:14];
        leaveBtn.layer.cornerRadius = 23;
        [leaveBtn addTarget:self action:@selector(leave) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView  addSubview:leaveBtn];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(16, CGRectGetMaxY(leaveBtn.frame)+20, kMainScreenWidth-64, 30);
        [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB_IM(0x0038A9) forState:UIControlStateNormal];
		cancelBtn.titleLabel.font =  [FontManager setMediumFontSize:14];
        [cancelBtn addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView  addSubview:cancelBtn];
    
        self.alertView.frame = CGRectMake(0, 0, kMainScreenWidth-32, CGRectGetMaxY(cancelBtn.frame)+20);
    }
    
    return self;
}


#pragma mark - 弹出 -
- (void)show {
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation {
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.60, 0.60);
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
- (void)leave {
    if (_leaveBlock) {
        [self diss];
        _leaveBlock();
    } else {
        [self diss];
    }
}

#pragma mark -
- (void)diss {
    [UIView animateWithDuration:0.10f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
