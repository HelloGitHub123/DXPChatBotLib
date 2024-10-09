//
//  IMTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/7/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMTableViewCell : UITableViewCell {
    IMMsgModel *_currentModel;
}

@property (nonatomic, strong) UIButton *headIconBtn;
//@property (nonatomic, strong) UIButton *upBtn;
//@property (nonatomic, strong) UIButton *downBtn;

- (void)setContentHeadIconWithModel:(IMMsgModel*)model;

@end

NS_ASSUME_NONNULL_END
