//
//  IMMenuStarTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMMenuStarTableViewCell.h"
#import "IMSatisfyMenuModel.h"

@implementation IMMenuStarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         
    }
    return self;
}

- (void)setContentWithModel:(IMSatisfyMainInfoModel *)model isSubmit:(BOOL)isSubmit {
    _currentModel = model;
    
    for (UIButton *subBtn in self.contentView.subviews) {
        [subBtn removeFromSuperview];
    }
    
    float orginX = 10;
    if ([[model menu] count] == 1) {
        orginX = kMaxCellWidthNoIcon/2-12;
    } else if ([[model menu] count] == 2) {
        orginX = kMaxCellWidthNoIcon/2-36;
    } else if ([[model menu] count] == 3) {
        orginX = kMaxCellWidthNoIcon/2-60;
    } else if ([[model menu] count] == 4) {
        orginX = kMaxCellWidthNoIcon/2-84;
    } else if ([[model menu] count] == 5) {
        orginX = kMaxCellWidthNoIcon/2-108;
    }
    
    for (int i = 0; i < [[model menu] count]; i++) {
        IMSatisfyMenuModel *optionModel = [[model menu] objectAtIndex:[[model menu] count]-1-i];//倒序展示
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        starBtn.frame = CGRectMake(orginX+(kCellSpace20+24)*i, (kCellSingleList-23)/2, 24, 23);
        [starBtn addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventTouchUpInside];
        [starBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        starBtn.tag = i;
        if (isSubmit) {
            starBtn.userInteractionEnabled = NO;
        } else {
            starBtn.userInteractionEnabled = YES;
        }
        if (optionModel.isSelect) {
            [starBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
            for (UIButton *subBtn in self.contentView.subviews) {
                [subBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
            }
        } else {
            [starBtn setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
        }
        [self.contentView addSubview:starBtn];
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)starAction:(UIButton *)sender {
    for (IMSatisfyMenuModel *optionModel in [_currentModel menu]) {
        optionModel.isSelect = NO;
    }
    IMSatisfyMenuModel *selectModel = [[_currentModel menu] objectAtIndex:[[_currentModel menu] count]-1-sender.tag];
    selectModel.isSelect = YES;

    for (UIButton *subBtn in self.contentView.subviews) {
        [subBtn setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        if (subBtn.tag > sender.tag) {
            [subBtn setImage:[UIImage imageNamed:@"unstar"] forState:UIControlStateNormal];
        }
    }
}

@end
