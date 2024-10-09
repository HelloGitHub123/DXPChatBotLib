//
//  IMCellHeightHelper.h
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IMMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMCellHeightHelper : NSObject

//获取cell高度，保存于数据库中
+ (NSInteger)getCellHeight:(IMMsgModel *)model;

@end

NS_ASSUME_NONNULL_END
