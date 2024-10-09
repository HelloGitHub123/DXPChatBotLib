//
//  IMTextTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMTextTableViewCell.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import "IMViewMoreBottomView.h"
#import "IMTapMorePushVC.h"
#import "AppDelegate.h"
#import "FontManager.h"

@interface IMTextTableViewCell () {
    IMMsgModel *_currentModel;
}

@end

@implementation IMTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
        
        _contentTiew = [[UITextView alloc] init];
        _contentTiew.font = [UIFont cellContentFont];
        _contentTiew.backgroundColor = [UIColor clearColor];
        _contentTiew.textContainerInset = UIEdgeInsetsZero;
        _contentTiew.textContainer.lineFragmentPadding = 0;
        _contentTiew.editable = NO;
        [_cellBgView addSubview:_contentTiew];
        
        // 已读未读
        _seenLab = [[UILabel alloc] init];
        _seenLab.text = @"Seen";
		_seenLab.font = [FontManager setMediumFontSize:10];
        _seenLab.textColor = UIColorFromRGB_IM(0x3E3E3E);
        _seenLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_seenLab];
      
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"View More" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColorFromRGB_IM(0xFFFFFF) forState:UIControlStateNormal];
		_moreBtn.titleLabel.font = [FontManager setMediumFontSize:14];
        _moreBtn.backgroundColor = [UIColor  cellServerBackgroundColor];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        [_moreBtn setImage:[UIImage imageNamed:@"ico-arrow-right"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreViewAction) forControlEvents:UIControlEventTouchUpInside];
        [_cellBgView addSubview:_moreBtn];
        
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"ico-arrow-right"];
        [_moreBtn addSubview:_arrowView];
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];

    //聊天背景
    CGSize contentSize = [model.mainInfo singleSizeWithFont:[UIFont cellContentFont]];
    CGFloat contentWidth = 0;
    if ([NSString isIMBlankString:model.jumpMenu]) {
        contentWidth = (contentSize.width+kCellSpace10*2)<kCellMaxWidth?(contentSize.width+kCellSpace10*2):kCellMaxWidth;
    } else {
        contentWidth = kCellMaxWidth;
    }
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, contentWidth, model.cellHeight);
        _cellBgView.backgroundColor = [UIColor  cellServerBackgroundColor];
        _contentTiew.textColor = [UIColor cellServerContextColor];
        // 已读未读
        _seenLab.hidden = YES;
    } else if (model.createType == IMMsgCreateType_user) {
        _cellBgView.frame = CGRectMake(kMainScreenWidth-contentWidth-64, 0, contentWidth, model.cellHeight);
        _cellBgView.backgroundColor = [UIColor cellUserBackgroundColor];
        _contentTiew.textColor = [UIColor cellUserContentColor];
        // 已读未读
        if ([model.sessionState isEqualToString:@"S"]) {
            // 人工
            if (model.createType == IMMsgCreateType_user && model.isSeen) {
                _seenLab.hidden = NO;
            } else {
                _seenLab.hidden = YES;
            }
        }
        if ([model.sessionState isEqualToString:@"C"]) {
            // 机器人
            _seenLab.hidden = NO;
        }
        if ([model.sessionState isEqualToString:@"Q"]) {
            // 排队
            _seenLab.hidden = YES;
        }
        _seenLab.frame = CGRectMake(kCellSpace10, model.cellHeight+5, kMainScreenWidth-64-kCellSpace10, 20);
    }
    
    //内容
    _contentTiew.tag = indexPath.section;
    _contentTiew.frame = CGRectMake(kCellSpace10, kCellSpace10+2, contentWidth-kCellSpace10*2, model.cellHeight-kCellSpace10*2);
    _contentTiew.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor cellLinkContentColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    NSMutableArray *clickArray = [IMCellDataHelper getMatchContent:model.mainInfo];
    if (clickArray.count == 0) {
        NSDictionary *attributes = @{NSForegroundColorAttributeName:_contentTiew.textColor, NSFontAttributeName:[UIFont cellContentFont]};
        NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:model.mainInfo attributes:attributes];
        if ([model.sessionState isEqualToString:@"C"] && [model.needBtn isEqualToString:@"Y"] && !model.isSubmit) {
            [totalContent addAttribute:NSLinkAttributeName value:@"manual://" range:NSMakeRange(model.mainInfo.length-7, 7)];
        }
        _contentTiew.attributedText = totalContent;
    } else {
      NSDictionary *attributes = @{NSForegroundColorAttributeName:_contentTiew.textColor, NSFontAttributeName:[UIFont cellContentFont]};
      NSMutableAttributedString *totalContent = [[NSMutableAttributedString alloc] initWithString:model.mainInfo attributes:attributes];
      for (NSInteger i=0;i<clickArray.count;i++) {
        NSString *title = [clickArray objectAtIndex:i];
        NSRange ansRange = [model.mainInfo rangeOfString:title];
        [totalContent addAttribute:NSLinkAttributeName value:@"uccLinkString://" range:ansRange];
      }
      _contentTiew.attributedText = totalContent;
    }
  
    if (![NSString isIMBlankString:model.jumpMenu]) {
        _moreBtn.hidden = NO;
        _moreBtn.frame = CGRectMake(0, model.cellHeight-36, contentWidth, 36);
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_moreBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(12.0, 12.0)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _moreBtn.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _moreBtn.layer.mask = cornerRadiusLayer;
        
        _arrowView.frame = CGRectMake(contentWidth-26, 10, 16, 16);
    } else {
        _moreBtn.hidden = YES;
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)moreViewAction {
    [IMTapMorePushVC pushVCWithRouter:@{@"router":_currentModel.jumpMenu}];
}

@end
