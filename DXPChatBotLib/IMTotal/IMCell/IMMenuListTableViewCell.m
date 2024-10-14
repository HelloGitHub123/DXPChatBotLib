//
//  IMMenuListTableViewCell.m
//  IMDemo
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMMenuListTableViewCell.h"
#import "IMMenuStarTableViewCell.h"
#import "IMMenuTextTableViewCell.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMSatisfyMainInfoModel.h"
#import "IMSatisfyMenuModel.h"
#import <DXPFontManagerLib/FontManager.h>

@interface IMMenuListTableViewCell () <UITableViewDataSource, UITableViewDelegate> {
    IMMsgModel *_currentModel;
}

@end

@implementation IMMenuListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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

        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor cellLineColor];
        [_cellBgView addSubview:_bottomLineView];
        
        _submintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submintBtn setTitle:@"Submit" forState:UIControlStateNormal];
        [_submintBtn setTitleColor:UIColorFromRGB_IM(0xCE1126) forState:UIControlStateNormal];
		_submintBtn.titleLabel.font = [FontManager setMediumFontSize:14];
        [_cellBgView addSubview:_submintBtn];
    }
    return self;
}

-(void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath {
    _currentModel = model;
    //头像
    [self setContentHeadIconWithModel:model];
    
    //聊天背景
    if (model.createType == IMMsgCreateType_server) {
        _cellBgView.frame = CGRectMake(64, 0, kCellMaxWidth, model.cellHeight);
    }
    
    //tableView
    if (_currentModel.isSubmit) {
        _tableView.frame = CGRectMake(0, kCellSpace10, kCellMaxWidth, model.cellHeight-kCellSpace10);
    } else {
        _tableView.frame = CGRectMake(0, kCellSpace10, kCellMaxWidth, model.cellHeight-kCellSubmitBtn);
    }
    [_tableView reloadData];
    
    //submit
    _bottomLineView.frame = CGRectMake(0, model.cellHeight-kCellSubmitBtn, kCellMaxWidth, 1);
    _submintBtn.frame = CGRectMake(0, model.cellHeight-kCellSubmitBtn, kCellMaxWidth, kCellSubmitBtn);
    if (_currentModel.isSubmit) {
        _bottomLineView.hidden = YES;
        _submintBtn.hidden = YES;
    } else {
        _bottomLineView.hidden = NO;
        _submintBtn.hidden = NO;
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _currentModel.menuList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    IMSatisfyMainInfoModel *model = [_currentModel.menuList objectAtIndex:section];
    CGSize headerSize = [model.header sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    return headerSize.height + kCellSpace10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IMSatisfyMainInfoModel *model = [_currentModel.menuList objectAtIndex:section];
    CGSize headerSize = [model.header sizeForWidth:kCellMaxWidth-kCellSpace10*2 withFont:[UIFont cellContentFont]];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCellMaxWidth, headerSize.height + kCellSpace10)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(kCellSpace10, kCellSpace10/2, kCellMaxWidth - kCellSpace10*2, headerSize.height)];
    headerLab.font = [UIFont cellContentFont];
    headerLab.textColor = UIColorFromRGB_IM(0x3A2E2E);
    headerLab.text = model.header;
    headerLab.numberOfLines = 0;
    [headView addSubview:headerLab];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    IMSatisfyMainInfoModel *model = [_currentModel.menuList objectAtIndex:section];
    if ([model.feedbackType isEqualToString:@"B"]) {
        return 1;//星星一行
    } else {
        return [model.menu count];//文本多行
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSatisfyMainInfoModel *model = [_currentModel.menuList objectAtIndex:indexPath.section];
    if ([model.feedbackType isEqualToString:@"B"]) {
        IMMenuStarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuStarTableViewCell" forIndexPath:indexPath];
        [cell setContentWithModel:model isSubmit:_currentModel.isSubmit];
        return cell;
    } else {
        IMMenuTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuTextTableViewCell" forIndexPath:indexPath];
        [cell setContentWithArray:model.menu isTypeQ:model.isTypeQ indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_currentModel.isSubmit) return;
    
    IMSatisfyMainInfoModel *model = [_currentModel.menuList objectAtIndex:indexPath.section];
    
    if ([model.feedbackType isEqualToString:@"B"]) return;
    
    for (IMSatisfyMenuModel *tempModel in model.menu) {
        tempModel.isSelect = NO;
    }
    IMSatisfyMenuModel *subModel = [model.menu objectAtIndex:indexPath.row];
    subModel.isSelect = YES;
    [self.tableView reloadData];
}

@end
