//
//  IMMenuStarTableViewCell.h
//  IMDemo
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMsgModel.h"
#import "IMSatisfyMainInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMMenuStarTableViewCell : UITableViewCell {
    IMSatisfyMainInfoModel *_currentModel;
}

- (void)setContentWithModel:(IMSatisfyMainInfoModel *)model isSubmit:(BOOL)isSubmit;


@end

NS_ASSUME_NONNULL_END
