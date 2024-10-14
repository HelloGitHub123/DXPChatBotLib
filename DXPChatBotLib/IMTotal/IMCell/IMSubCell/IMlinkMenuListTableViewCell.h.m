//
//  IMlinkListTableViewCell.m
//  CLP
//
//  Created by mac on 2021/5/6.
//

#import "IMlinkMenuListTableViewCell.h"
#import "UIFont+IM.h"
#import "UIColor+IM.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import <DXPFontManagerLib/FontManager.h>
#import "IMConfigSingleton.h"

@interface IMlinkMenuListTableViewCell() {
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIImageView *imgviewArrow; // 箭头
@property (nonatomic, strong) UIImageView *dashedlineImgView; // 虚线
@property (nonatomic, strong) IMMsgModel *currentModel;
@end

@implementation IMlinkMenuListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [IMConfigSingleton sharedInstance].menuCellBgColor;
		
		// 按钮1
		_button1 = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button1 setTitleColor:[IMConfigSingleton sharedInstance].menuCellTextColor forState:UIControlStateNormal];
		_button1.titleLabel.font = [FontManager setMediumFontSize:12];
		//        _button1.layer.cornerRadius=16;
		//        _button1.layer.borderColor= UIColorFromRGB_IM(0x0038A8).CGColor;
		//        _button1.layer.borderWidth=1.0;
		_button1.userInteractionEnabled = YES;
		[_button1 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
		
		// 按钮2
		_button2 = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button2 setTitleColor:[IMConfigSingleton sharedInstance].menuCellTextColor forState:UIControlStateNormal];
		_button2.titleLabel.font = [FontManager setMediumFontSize:12];
		_button2.titleLabel.adjustsFontSizeToFitWidth = YES;
		//        _button2.layer.cornerRadius=16;
		//        _button2.layer.borderColor= UIColorFromRGB_IM(0x0038A8).CGColor;
		//        _button2.layer.borderWidth=1.0;
		_button2.layer.masksToBounds=YES;
		_button2.userInteractionEnabled = YES;
		[_button2 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
	
		_imgviewArrow = [[UIImageView alloc] init];
		_imgviewArrow.image = [UIImage imageNamed:@"ic_menu_cell_arrow"];
		
		_dashedlineImgView = [[UIImageView alloc] init];
		_dashedlineImgView.image = [UIImage imageNamed:@"dashedline"];
		
	}
    return self;
}

- (void)setContentWithModel:(IMMsgModel *)model indexPath:(nonnull NSIndexPath *)indexPath {
    
    _currentModel = model;
    currentIndexPath = indexPath;
    
    NSArray *array = [IMCellDataHelper getMenuList:model.mainInfo];
    
    // 判断按钮是否是 yes no. 决定是否进行一行展示排版
    BOOL isYesFlag = false;
    BOOL isNoFlag = false;
    for (int i = 0 ; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        if ([[title lowercaseString] isEqualToString:@"yes"]) {
            isYesFlag = true;
        }
        if ([[title lowercaseString] isEqualToString:@"no"]) {
            isNoFlag = true;
        }
    }
    BOOL isFlag = isYesFlag && isNoFlag;
    
    if (model.showHelpful || isFlag) {
        // 设置按钮1
        NSDictionary *dic1 = [array objectAtIndex:0];
        NSString *title = [NSString imStringWithoutNil:[dic1 objectForKey:@"title"]];
        CGSize contentSize = [title singleSizeWithFont:[UIFont cellContentFont]];
        _button1.frame = CGRectMake(0, 10, contentSize.width + 24, 31);
		_button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button1.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [_button1 setTitle:title forState:UIControlStateNormal];
        _button1.tag = [indexPath row] + 100;
        // 设置按钮2
        NSDictionary *dic2 = [array objectAtIndex:1];
        NSString *title2 = [NSString imStringWithoutNil:[dic2 objectForKey:@"title"]];
        CGSize contentSize2 = [title singleSizeWithFont:[UIFont cellContentFont]];
        _button2.frame = CGRectMake(CGRectGetMaxX(_button1.frame)+10, 10, contentSize2.width + 24, 31);
		_button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button2.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        [_button2 setTitle:title2 forState:UIControlStateNormal];
        _button2.tag = [indexPath row] + 200;
        
        [self.contentView addSubview:_button1];
        [self.contentView addSubview:_button2];
        [_button2 setHidden:NO];
		[_imgviewArrow setHidden:YES];
		[_dashedlineImgView setHidden:YES];
        
    } else {
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        // 设置按钮标题
        NSString *title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        CGSize contentSize = [title singleSizeWithFont:[UIFont cellContentFont]];
		_button1.frame = CGRectMake(0, 5, kCellMaxWidth-16-5, 31);
        _button1.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _button1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);
        [_button1 setTitle:title forState:UIControlStateNormal];
        _button1.tag = [indexPath row];
		_button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		
        [self.contentView addSubview:_button1];
		[self.contentView addSubview:_imgviewArrow];
		[self.contentView addSubview:_dashedlineImgView];
		_imgviewArrow.frame = CGRectMake(kCellMaxWidth-16-5, 13, 16, 16);
		_dashedlineImgView.frame = CGRectMake(12, 1, kCellMaxWidth-12*2, 1);
		
        [_button2 setHidden:YES];
		[_imgviewArrow setHidden:NO];
		[_dashedlineImgView setHidden:NO];
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)handleAction:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(linkMenuListCellButtonClickByModel:buttonTag:indexPath:)]) {
        // 保留 currentIndexPath 不做改动
        [self.delegate linkMenuListCellButtonClickByModel:_currentModel buttonTag:button.tag indexPath:currentIndexPath];
    }
}

@end
