//
//  IMMenuTextTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMSatisfyMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMMenuTextTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;

- (void)setContentWithArray:(NSMutableArray *)array isTypeQ:(BOOL)isTypeQ indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
