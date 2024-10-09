//
//  IMCardCollectionViewCell.m
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMCardCollectionViewCell.h"
#import "IMSecondCollectionViewCell.h"
#import "UCCHeader.h"
#import "NSString+IM.h"
#import "IMQuestionTableViewCell.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import "IMHttpRequest.h"
#import "IMCardModel.h"
#import "FontManager.h"

static NSString *secondCellIdentifier = @"IMSecondCollectionViewCellIdentifier";
static NSString *questionCellIdentifier = @"IMQuestionTableViewCellIdentifier";

@interface IMCardCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate> {
    IMCardModel *_currentModel;
    IMSecondMenuModel *_menuModel;
}

@end

@implementation IMCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _bgView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _bgView.layer.cornerRadius = 8;
        [self.contentView addSubview:_bgView];
      
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, self.contentView.bounds.size.width-20, 18)];
		_titleLabel.font = [FontManager setMediumFontSize:16];
        _titleLabel.textColor = UIColorFromRGB_IM(0x606060);
        [_bgView addSubview:_titleLabel];
      
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.bounds.size.width-20, 30) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[IMSecondCollectionViewCell class] forCellWithReuseIdentifier:secondCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_bgView addSubview:_collectionView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 70, kMainScreenWidth-60, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB_IM(0xEBEBEB);
        [self.contentView addSubview:_lineView];
      
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70.5, self.contentView.bounds.size.width-15, 156) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
        _tableView.rowHeight = 48;
//        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[IMQuestionTableViewCell class] forCellReuseIdentifier:questionCellIdentifier];
        [_bgView addSubview:_tableView];
    }
    return self;
}

- (void)setContentWithModel:(IMCardModel *)model {
    _currentModel = model;
    _titleLabel.text = model.categoryName;
    for (IMSecondMenuModel *model in _currentModel.cateMenuList) {
        if (model.isSelect) {
            _menuModel = model;
        }
    }
}

#pragma mark- UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _currentModel.cateMenuList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMSecondMenuModel *model = _currentModel.cateMenuList[indexPath.row];
	CGSize titleSize = [model.categoryName singleSizeWithFont:[FontManager setMediumFontSize:14]];
    return CGSizeMake(titleSize.width+10, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
    [cell setContentWithModel:_currentModel.cateMenuList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (IMSecondMenuModel *model in _currentModel.cateMenuList) {
        model.isSelect = NO;
    }
    IMSecondMenuModel *selectModel = _currentModel.cateMenuList[indexPath.row];
    selectModel.isSelect = YES;
    [self.collectionView reloadData];
  
    _menuModel = selectModel;
    if (_menuModel.questionList.count == 0) {
		[HJMBProgressHUD showLoading];
		
        [IMHttpRequest postHttpUrl:[NSString stringWithFormat:@"question/%@/query", _menuModel.categoryCode] param:@{} block:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
			[HJMBProgressHUD hideLoading];
            if (error) {
                [HJMBProgressHUD showText:@"Server Error"];
            } else {
                NSArray *questionList = [responseObject objectForKey:@"questionList"];
                if (![questionList isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dic in questionList) {
                        IMQuestionModel *model = [[IMQuestionModel alloc] initWithDic:dic];
                        [_menuModel.questionList addObject:model];
                    }
                }
            }
            [self.tableView reloadData];
        }];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - tableView delegate and source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _menuModel.questionList.count<3?_menuModel.questionList.count:3;
    return _menuModel.questionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifier forIndexPath:indexPath];
    [cell setContentWithModel:_menuModel.questionList[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMQuestionModel *model = _menuModel.questionList[indexPath.section];
	NSLog(@"点击了问题：%@ %@", model.questionMsg, model.questionCode);
    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:model.questionMsg];
}

@end
