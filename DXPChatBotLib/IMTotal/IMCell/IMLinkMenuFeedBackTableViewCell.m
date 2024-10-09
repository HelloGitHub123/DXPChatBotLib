//
//  IMLinkMenuFeedBackTableViewCell.m
//  CLP
//
//  Created by 李标 on 2023/2/1.
//

#import "IMLinkMenuFeedBackTableViewCell.h"
#import "IMCellDataHelper.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import <SDWebImage/SDWebImage.h>

@interface IMLinkMenuFeedBackTableViewCell ()<UIGestureRecognizerDelegate> {
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong) IMMsgModel *currentModel;
@end

@implementation IMLinkMenuFeedBackTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor  clearColor];
        
        
    }
    return self;
}

- (void)setContentWithModel:(IMMsgModel *)model indexPath:(nonnull NSIndexPath *)indexPath {
    _currentModel = model;
    currentIndexPath = indexPath;
    
    NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
    
    NSDictionary *mianInfoDic = [model.mainInfo JSONValue];
    NSString *showType = [mianInfoDic objectForKey:@"showType"];
    if ([showType isEqualToString:@"C"]) {
        // 评论反馈 显示菜单展示的方式 C:emoji横排展示
        if (self.isURLEmoji) {
            // 带有https 或者 http的
            for (int i = 0; i< array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                NSString *emojiImgSrc = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                UIImageView *imgview = [[UIImageView alloc] init];
                imgview.tag = 5000 + i;
                [self.contentView addSubview:imgview];
                
                if (model.createType == IMMsgCreateType_user) {
                    [imgview setFrame:CGRectMake(0, 10, 30, 30)];
                    NSURL *url = [NSURL URLWithString:emojiImgSrc];
                    [imgview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                } else {
                    if (i == 0) {
                        [imgview setFrame:CGRectMake(i*30, 10, 30, 30)];
                    } else {
                        [imgview setFrame:CGRectMake(i*30+i*16, 10, 30, 30)];
                    }
                    NSURL *url = [NSURL URLWithString:emojiImgSrc];
                    [imgview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
                    imgview.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emojiHandleTap:)];
                    tapRecognize.numberOfTapsRequired = 1;
                    tapRecognize.delegate = self;
                    [tapRecognize setEnabled :YES];
                    [imgview addGestureRecognizer:tapRecognize];
                }
            }
        } else {
            for (int i = 0; i< array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
                CGSize contentSize = [title singleSizeWithFont:[UIFont cellContentFont]];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                btn.layer.cornerRadius=16;
//                btn.layer.borderColor= UIColorFromRGB(0x0038A8).CGColor;
//                btn.layer.borderWidth=1.0;
                btn.userInteractionEnabled = YES;
                [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 5000 + i;
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
                [btn setTitle:title forState:UIControlStateNormal];
                if (i == 0) {
                    [btn setFrame:CGRectMake(i*30, 10, contentSize.width + 30, 30)];
                } else {
                    [btn setFrame:CGRectMake(i*30+i*16, 10, contentSize.width + 30, 30)];
                }
                [self.contentView addSubview:btn];
            }
        }
    }
}

- (void)handleAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMLinkMenuFeedBackButtonClickByModel:buttonTag:isURLEmoji:indexPath:)]) {
        UIButton *btn = (UIButton *)sender;
        [self.delegate IMLinkMenuFeedBackButtonClickByModel:_currentModel buttonTag:btn.tag isURLEmoji:NO indexPath:currentIndexPath];
    }
}

#pragma UIGestureRecognizer Handles
- (void)emojiHandleTap:(UITapGestureRecognizer *)recognizer {
    UIView *imgView = recognizer.view;
    NSLog(@"emojiHandleTap:%ld",(long)imgView.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMLinkMenuFeedBackButtonClickByModel:buttonTag:isURLEmoji:indexPath:)]) {
        // 保留 currentIndexPath 不做改动
        [self.delegate IMLinkMenuFeedBackButtonClickByModel:_currentModel buttonTag:imgView.tag isURLEmoji:YES indexPath:currentIndexPath];
    }
}

@end
