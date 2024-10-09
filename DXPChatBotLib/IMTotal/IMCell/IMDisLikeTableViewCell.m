//
//  IMDisLikeTableViewCell.m
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMDisLikeTableViewCell.h"
#import "IMDisLikeTextTableViewCell.h"
#import "UIColor+IM.h"
#import "UIFont+IM.h"
#import "NSString+IM.h"
#import "IMDisLikeModel.h"
#import "IMHttpRequest.h"
#import "IMChatDBManager.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <YYModel/YYModel.h>
#import "IMConfigSingleton.h"
#import "FontManager.h"

@interface IMDisLikeTableViewCell () <UITableViewDataSource, UITableViewDelegate> {
    IMMsgModel *_currentModel;
    NSString *_reasonCode;
}

@end

@implementation IMDisLikeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB_IM(0xF2F2F2);
        
        _cellBgView = [[UIView alloc] init];
        _cellBgView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _cellBgView.layer.cornerRadius = 12.0;
        [self.contentView addSubview:_cellBgView];
      
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kMaxCellWidthNoIcon-20, 30)];
		_titleLab.font = [FontManager setMediumFontSize:14];
        _titleLab.textColor = UIColorFromRGB_IM(0x929292);
        _titleLab.text = @"Help us to improve.";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_cellBgView addSubview:_titleLab];
      
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[IMDisLikeTextTableViewCell class] forCellReuseIdentifier:@"disLikeTableViewCellIdentifier"];
        [_cellBgView addSubview:_tableView];
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
    }
    
    //tableView
    if (_currentModel.isSubmit) {
        _tableView.frame = CGRectMake(0, 50, kMaxCellWidthNoIcon, model.cellHeight-60);
        _tableView.tableFooterView = nil;
    } else {
        _tableView.frame = CGRectMake(0, 50, kMaxCellWidthNoIcon, model.cellHeight-60);
        _tableView.tableFooterView = [self footView];
    }
    [_tableView reloadData];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_currentModel.isSubmit) return 1;
    return [_currentModel.dislikeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMDisLikeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"disLikeTableViewCellIdentifier" forIndexPath:indexPath];
    [cell setContentWithArray:_currentModel.dislikeList indexPath:indexPath isSubmit:_currentModel.isSubmit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_currentModel.isSubmit) return;
    
    for (IMDisLikeModel *tempModel in _currentModel.dislikeList) {
        tempModel.isSelect = NO;
    }
    IMDisLikeModel *subModel = [_currentModel.dislikeList objectAtIndex:indexPath.section];
    subModel.isSelect = YES;
    _reasonCode = subModel.unsatReasonCode;
    [self.tableView reloadData];
}

- (UIView *)footView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMaxCellWidthNoIcon, 60)];
    footView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
    
    UIButton *submintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submintBtn.frame = CGRectMake(16, 5, kMaxCellWidthNoIcon-32, 46);
    [submintBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [submintBtn setTitleColor:UIColorFromRGB_IM(0xFFFFFF) forState:UIControlStateNormal];
	submintBtn.titleLabel.font = [FontManager setMediumFontSize:14];
    submintBtn.backgroundColor = UIColorFromRGB_IM(0xCE1126);
    submintBtn.layer.cornerRadius = 23;
    [submintBtn addTarget:self action:@selector(submitAciton) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submintBtn];
    
    return footView;
}

- (void)submitAciton {
    if ([NSString isIMBlankString:_reasonCode] || [NSString isIMBlankString:[IMConfigSingleton sharedInstance].dislikeMessageId] ) {
        return;
    }
    
	[HJMBProgressHUD showLoading];

    [IMHttpRequest postHttpUrl:[NSString stringWithFormat:@"message/%@/appraisereason", [IMConfigSingleton sharedInstance].dislikeMessageId] param:@{@"msgId":[IMConfigSingleton sharedInstance].dislikeMessageId, @"appraiseReasonCode":_reasonCode} block:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
		[HJMBProgressHUD hideLoading];
        if (error) {
			[HJMBProgressHUD showText:@"Server Error"];
        } else {
            [IMConfigSingleton sharedInstance].dislikeMessageId = @"";
            NSMutableArray *reasonList = [[NSMutableArray alloc] init];
            for (IMDisLikeModel *model in _currentModel.dislikeList) {
                [reasonList addObject:[model yy_modelToJSONObject]];
            }
            _currentModel.mainInfo = [NSString dictionaryToJson:@{@"reasonList":reasonList}];
            _currentModel.isSubmit = YES;
            _currentModel.cellHeight = 50+1*50+10;
            [IMChatDBManager updateMainInfoWithUserId:[IMConfigSingleton sharedInstance].userId msgId:_currentModel.msgId mainInfo:_currentModel.mainInfo];
            [IMChatDBManager updateIsSubmitWithUserId:[IMConfigSingleton sharedInstance].userId msgId:_currentModel.msgId isSubmit:YES];
            [IMChatDBManager updateCellHeightWithUserId:[IMConfigSingleton sharedInstance].userId msgId:_currentModel.msgId  cellHeight:_currentModel.cellHeight];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReloadData object:nil];
        }
    }];
}

@end
