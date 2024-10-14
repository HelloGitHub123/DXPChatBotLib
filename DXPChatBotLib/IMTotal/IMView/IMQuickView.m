//
//  IMQuickView.m
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMQuickView.h"
#import "UIColor+IM.h"
#import "UCCHeader.h"
#import "IMQuickCollectionViewCell.h"
#import "NSString+IM.h"
#import <DXPFontManagerLib/FontManager.h>

static NSString *quickCellIdentifier = @"IMQuickCollectionViewCellIdentifier";

@interface IMQuickView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *_questionList;
}

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation IMQuickView

- (id)initWithFrame:(CGRect)frame questionList:(NSArray *)questionList {
    self = [super initWithFrame:frame];
    if (self) {
        _questionList = questionList;
        self.backgroundColor = UIColorFromRGB_IM(0xFFFFFF);
      
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.topLineView];
    [self addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.bottomLineView];
}

#pragma mark- UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _questionList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_questionList objectAtIndex:indexPath.row];
    NSString *questionMsg = [NSString imStringWithoutNil:[dic objectForKey:@"questionMsg"]];
	CGSize titleSize = [questionMsg singleSizeWithFont:[FontManager setMediumFontSize:14]];
    return CGSizeMake(titleSize.width+18, 34);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMQuickCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:quickCellIdentifier forIndexPath:indexPath];
    [cell setContentWithDic:_questionList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_questionList objectAtIndex:indexPath.row];
    NSString *questionMsg = [NSString imStringWithoutNil:[dic objectForKey:@"questionMsg"]];
    NSString *questionCode = [NSString imStringWithoutNil:[dic objectForKey:@"questionCode"]];
	NSLog(@"点击了问题：%@ %@", questionMsg, questionCode);
    [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationSendText object:questionMsg];
}

#pragma mark - lazy
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        _topLineView.backgroundColor = UIColorFromRGB_IM(0xEBEBEB);
    }
    return _topLineView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 8, kMainScreenWidth, 34) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[IMQuickCollectionViewCell class] forCellWithReuseIdentifier:quickCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kMainScreenWidth, 0.5)];
        _bottomLineView.backgroundColor = UIColorFromRGB_IM(0xEBEBEB);
    }
    return _bottomLineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
