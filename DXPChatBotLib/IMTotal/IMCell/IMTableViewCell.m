//
//  IMTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/7/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMTableViewCell.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMChatDBManager.h"
#import "IMConfigSingleton.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import "IMHttpRequest.h"
#import "IMConfigSingleton.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "SDWebImage/SDImageCache.h"

@implementation IMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor chatVCBackgroundColor];
        
        _headIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headIconBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_headIconBtn];
      
//        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _upBtn.userInteractionEnabled = NO;
//        [_upBtn addTarget:self action:@selector(clickUp) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_upBtn];
//
//        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _downBtn.userInteractionEnabled = NO;
//        [_downBtn addTarget:self action:@selector(clickDown) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_downBtn];
    }
    return self;
}

- (void)setContentHeadIconWithModel:(IMMsgModel*)model {
    _currentModel = model;
  
    _headIconBtn.layer.mask = nil;
    if (model.createType == IMMsgCreateType_server) {
        _headIconBtn.frame = CGRectMake(16, 0, 40, 40);
        if ([model.sessionState isEqualToString:@"S"]) {
            if ([NSString isIMBlankString:model.agentPicture]) {
                [_headIconBtn setBackgroundImage:[UIImage imageNamed:@"onlineLogo"] forState:UIControlStateNormal];
            } else {
                [self setHeadIconBtnRadius];
                NSString *url = [NSString stringWithFormat:@"%@%@",[IMConfigSingleton sharedInstance].fileURLStr, model.agentPicture];
                [_headIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"onlineLogo"]];
            }
        } else {
            [_headIconBtn setBackgroundImage:[UIImage imageNamed:@"serverHeadIcon"] forState:UIControlStateNormal];
        }
    } else if (model.createType == IMMsgCreateType_user) {
        _headIconBtn.frame = CGRectMake(kMainScreenWidth-46, 0, 40, 40);
        [_headIconBtn setBackgroundImage:[UIImage imageNamed:@"userHeadIcon"] forState:UIControlStateNormal];
    } else {
        [_headIconBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
  
//    if (model.cellHeight >= 56 && ([model.answerSource isEqualToString:@"KnowledgeBase"] || [model.answerSource isEqualToString:@"knowledge"] || [model.answerSource isEqualToString:@"Knowledge"]) && ![NSString isIMBlankString:model.messageId] && model.createType == IMMsgCreateType_server) {
//        _upBtn.frame = CGRectMake(70+kCellMaxWidth+kCellSpace10+(model.isHTML?20:0), _currentModel.cellHeight-24*2-8, 24, 24);
//        _downBtn.frame = CGRectMake(70+kCellMaxWidth+kCellSpace10+(model.isHTML?20:0), _currentModel.cellHeight-24, 24, 24);
//        if ([NSString isIMBlankString:model.extend]) {
//            _upBtn.hidden = NO;
//            _downBtn.hidden = NO;
//            _upBtn.userInteractionEnabled = YES;
//            _downBtn.userInteractionEnabled = YES;
//            [_upBtn setBackgroundImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
//            [_downBtn setBackgroundImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
//        } else {
//            if ([model.extend isEqualToString:@"like"]) {
//                _upBtn.hidden = YES;
//                _downBtn.hidden = NO;
//                _downBtn.userInteractionEnabled = NO;
//                [_downBtn setBackgroundImage:[UIImage imageNamed:@"like_select"] forState:UIControlStateNormal];
//            } else if ([model.extend isEqualToString:@"dislike"]) {
//                _upBtn.hidden = YES;
//                _downBtn.hidden = NO;
//                _downBtn.userInteractionEnabled = NO;
//                [_downBtn setBackgroundImage:[UIImage imageNamed:@"dislike_select"] forState:UIControlStateNormal];
//            }
//        }
//    } else {
//        _upBtn.hidden = YES;
//        _downBtn.hidden = YES;
//    }
  
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHeadIconBtnRadius {
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_headIconBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = _headIconBtn.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    _headIconBtn.layer.mask = cornerRadiusLayer;
}

@end
