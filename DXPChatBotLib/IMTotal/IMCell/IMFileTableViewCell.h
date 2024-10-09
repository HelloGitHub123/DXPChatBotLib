//
//  IMFileTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMTableViewCell.h"
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMFileTableViewCell : IMTableViewCell

@property (nonatomic, strong) UIImageView *logoView;

- (void)setContentWithModel:(IMMsgModel*)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
