//
//  IMHeaderView.m
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMHeaderView.h"
#import "UIColor+IM.h"
#import "UCCHeader.h"
#import "IMCardCollectionViewCell.h"

static NSString *cardCellIdentifier = @"IMCardCollectionViewCellIdentifier";

@interface IMHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _viewHeight;
    NSArray *_cateMenuList;
}

//@property (nonatomic, strong) UIButton *bannerBtn;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation IMHeaderView

- (id)initWithFrame:(CGRect)frame cateMenuList:(NSMutableArray *)cateMenuList {
    self = [super initWithFrame:frame];
    if (self) {
        _viewHeight = frame.size.height;
        _cateMenuList = cateMenuList;
        self.backgroundColor = [UIColor chatVCBackgroundColor];
      
        [self initUI];
    }
    return self;
}

- (void)initUI {
//    [self addSubview:self.bannerBtn];
    [self addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark- UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cateMenuList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kMainScreenWidth-40, _viewHeight-30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cardCellIdentifier forIndexPath:indexPath];
    [cell setContentWithModel:_cateMenuList[indexPath.row]];
    return cell;
}

#pragma mark - lazy
//- (UIButton *)bannerBtn {
//    if (!_bannerBtn) {
//        _bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _bannerBtn.frame = CGRectMake(10, 15, kMainScreenWidth-20, 100);
//        [_bannerBtn setBackgroundImage:[UIImage imageNamed:@"img_home_banner"] forState:UIControlStateNormal];
//        _bannerBtn.userInteractionEnabled = NO;
//    }
//    return _bannerBtn;
//}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, kMainScreenWidth, _viewHeight-30) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[IMCardCollectionViewCell class] forCellWithReuseIdentifier:cardCellIdentifier];
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
