//
//  IMSatisfactionTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/7/29.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMSatisfactionTableViewCell.h"
#import "IMMenuStarTableViewCell.h"
#import "IMMenuTextTableViewCell.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMSatisfyMainInfoModel.h"
#import "IMSatisfyMenuModel.h"
#import "FontManager.h"

@interface IMSatisfactionTableViewCell () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    IMMsgModel *_currentModel;
}

@end

@implementation IMSatisfactionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB_IM(0xF2F2F2);
        
        _cellBgView = [[UIView alloc] init];
        _cellBgView.layer.cornerRadius = 12.0;
        _cellBgView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        [self.contentView addSubview:_cellBgView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = kCellSingleList;
        [_tableView registerClass:[IMMenuStarTableViewCell class] forCellReuseIdentifier:@"menuStarTableViewCell"];
        [_tableView registerClass:[IMMenuTextTableViewCell class] forCellReuseIdentifier:@"menuTextTableViewCell"];
        [_cellBgView addSubview:_tableView];
        
        _submintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submintBtn setTitle:@"Submit" forState:UIControlStateNormal];
        _submintBtn.layer.cornerRadius = 23;
        _submintBtn.backgroundColor = UIColorFromRGB_IM(0xCE1126);
        [_submintBtn setTitleColor:UIColorFromRGB_IM(0xFFFFFF) forState:UIControlStateNormal];
		_submintBtn.titleLabel.font = [FontManager setMediumFontSize:14];
        [_cellBgView addSubview:_submintBtn];
    }
    return self;
}

-(void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
//    [self setContentHeadIconWithModel:model];
    
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(kLeftSpace16, 0, kMaxCellWidthNoIcon, model.cellHeight);
        _cellBgView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
    }
    
    //tableView
    if (_currentModel.isSubmit) {
        _tableView.frame = CGRectMake(0, kCellSpace10, kMaxCellWidthNoIcon, model.cellHeight-kCellSpace10);
    } else {
        _tableView.frame = CGRectMake(0, kCellSpace10, kMaxCellWidthNoIcon, model.cellHeight-kCellSubmitBtn);
    }
    [_tableView reloadData];
    
    //submit
    _submintBtn.frame = CGRectMake(kLeftSpace16, model.cellHeight-46-16, kMaxCellWidthNoIcon-kLeftSpace16*2, 46);
    if (_currentModel.isSubmit) {
        _submintBtn.hidden = YES;
    } else {
        _submintBtn.hidden = NO;
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGSize headerSize = [_currentModel.satisfyMainInfoModel.header sizeForWidth:kMaxCellWidthNoIcon withFont:[FontManager setMediumFontSize:14]];
    return headerSize.height + kCellSpace10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CGSize headerSize = [_currentModel.satisfyMainInfoModel.header sizeForWidth:kMaxCellWidthNoIcon withFont:[FontManager setMediumFontSize:14]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMaxCellWidthNoIcon, headerSize.height + kCellSpace10)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, 0, kMaxCellWidthNoIcon, headerSize.height)];
	headerLab.font = [FontManager setMediumFontSize:14];
    headerLab.textColor = UIColorFromRGB_IM(0x929292);
    headerLab.text = _currentModel.satisfyMainInfoModel.header;
    headerLab.numberOfLines = 0;
    headerLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:headerLab];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_currentModel.satisfyMainInfoModel.questionText isEqualToString:@"Y"] && (_currentModel.satisfyMainInfoModel.isTypeQ || _currentModel.satisfyMainInfoModel.menu.count == 0)) {
        return kCellQuestTextHeight + kCellSpace10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_currentModel.satisfyMainInfoModel.questionText isEqualToString:@"Y"] && (_currentModel.satisfyMainInfoModel.isTypeQ || _currentModel.satisfyMainInfoModel.menu.count == 0)) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMaxCellWidthNoIcon, kCellQuestTextHeight + kCellSpace10)];
        footView.backgroundColor = [UIColor clearColor];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kLeftSpace16, 0, kMaxCellWidthNoIcon-kLeftSpace16*2, kCellQuestTextHeight)];
        textView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        textView.textColor = UIColorFromRGB_IM(0x3A2E2E);
		textView.font = [FontManager setMediumFontSize:16];
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.delegate = self;
        textView.tag = section;
        textView.layer.cornerRadius = 8;
        textView.layer.borderColor = UIColorFromRGB_IM(0xC7C7C7).CGColor;
        textView.layer.borderWidth = 1.0;
        [footView addSubview:textView];
        if (_currentModel.isSubmit) {
            textView.editable = NO;
            textView.text = _currentModel.satisfyMainInfoModel.questionInput;
        } else {
            textView.editable = YES;
            textView.text = @"";
        }
        
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, textView.frame.size.width-10, 36)];
        placeHolderLabel.text = @"Type something..";
        placeHolderLabel.textColor = UIColorFromRGB_IM(0xBFBFBF);
		placeHolderLabel.font = [FontManager setMediumFontSize:14];
        placeHolderLabel.tag = section;
        if (_currentModel.isSubmit) {
            placeHolderLabel.hidden = YES;
        } else {
            placeHolderLabel.hidden = NO;
        }
        [textView addSubview:placeHolderLabel];
        
        return footView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_currentModel.satisfyMainInfoModel.feedbackType isEqualToString:@"B"]) {
        return 1;//星星一行
    } else {
        return [_currentModel.satisfyMainInfoModel.menu count];//文本多行
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_currentModel.satisfyMainInfoModel.feedbackType isEqualToString:@"B"]) {
        IMMenuStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuStarTableViewCell" forIndexPath:indexPath];
        [cell setContentWithModel:_currentModel.satisfyMainInfoModel isSubmit:_currentModel.isSubmit];
        return cell;
    } else {
        IMMenuTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuTextTableViewCell" forIndexPath:indexPath];
        [cell setContentWithArray:_currentModel.satisfyMainInfoModel.menu isTypeQ:_currentModel.satisfyMainInfoModel.isTypeQ indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_currentModel.isSubmit) return;
    
    if ([_currentModel.satisfyMainInfoModel.feedbackType isEqualToString:@"B"]) return;
    
    if (_currentModel.satisfyMainInfoModel.isTypeQ) {
        IMSatisfyMenuModel *subModel = [_currentModel.satisfyMainInfoModel.menu objectAtIndex:indexPath.row];
        subModel.isSelect = !subModel.isSelect;
    } else {
        for (IMSatisfyMenuModel *tempModel in _currentModel.satisfyMainInfoModel.menu) {
            tempModel.isSelect = NO;
        }
        IMSatisfyMenuModel *subModel = [_currentModel.satisfyMainInfoModel.menu objectAtIndex:indexPath.row];
        subModel.isSelect = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([NSString isIMBlankString:textView.text]) {
        for (UIView *subview in textView.subviews){
            if ([subview isKindOfClass:[UILabel class]]) {
                subview.hidden = NO;
                break;
            }
        }
    } else {
        for (UIView *subview in textView.subviews){
            if ([subview isKindOfClass:[UILabel class]]) {
                subview.hidden = YES;
                break;
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView*)textView {
    _currentModel.satisfyMainInfoModel.questionInput = textView.text;
}

@end
