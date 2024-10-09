//
//  IMPopupView.m
//  CLP
//
//  Created by 李标 on 2022/9/19.
//

#import "IMPopupView.h"
#import "NSString+IM.h"
#import <Masonry/Masonry.h>

@implementation IMPopupView

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString doneText:(NSString *  __nullable )doneText cancleText:(NSString * __nullable)cancleText
{
    self = [super init];
    if (self)
    {
        self.type = MMPopupTypeAlert;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
       
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth_IM-32);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UILabel *detailLable =[UILabel new];
        detailLable.numberOfLines = 0;
        detailLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:detailLable];
        
        [detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth_IM-64);
            make.centerX.equalTo(self);
            make.top.equalTo(lastAttribute).offset(36);
        }];
        
        detailLable.attributedText = attributedString;
        lastAttribute = detailLable .mas_bottom;
        UIButton *doneBtn =[UIButton new];
        doneBtn.backgroundColor = RGBA(206, 17, 38, 1);
        doneBtn.layer.cornerRadius = 4;
		doneBtn.titleLabel.font =  [UIFont systemFontOfSize:14]; //kFontExo2Bold(14);
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn setTitle:doneText?:@"Yes, Proceed" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:doneBtn];
        
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth_IM-64);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self);
            make.top.equalTo(lastAttribute).offset(25);
        }];
        lastAttribute = doneBtn .mas_bottom;
        
        UIButton *cancleBtn =[UIButton new];
        [self addSubview:cancleBtn];
        if (![NSString isIMBlankString:cancleText]) {
			cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14]; // kFontExo2Bold(14);
            [cancleBtn setTitleColor:RGBA(0, 56, 169, 1) forState:UIControlStateNormal];
            [cancleBtn setTitle:cancleText?:@"Cancel" forState:UIControlStateNormal];
            [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
            [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth_IM-64);
                make.height.mas_equalTo(40);
                make.centerX.equalTo(self);
                make.top.equalTo(lastAttribute).offset(17);
            }];
        } else {
            [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth_IM-64);
                make.height.mas_equalTo(0);
                make.centerX.equalTo(self);
                make.top.equalTo(lastAttribute).offset(17);
            }];
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cancleBtn.mas_bottom).offset(25);
        }];

    }
    return self;
}


-(void)doneAction:(UIButton *)sender{
    
    if (self.doneBlock) {
        self.doneBlock(sender);
    }
    
//    [self hide];
}

-(void)cancleAction:(UIButton *)sender{
    
    if (self.cancleBlock) {
        self.cancleBlock(sender);
    }
    
    [self hide];
}


@end
