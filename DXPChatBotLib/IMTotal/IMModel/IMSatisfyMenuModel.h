//
//  IMSatisfyMenuModel.h
//  IMDemo
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// single满意度
@interface IMSatisfyMenuModel : NSObject

@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;//F表示评分项；Q表示改进项
@property (nonatomic, assign) BOOL isSelect;//是否选择

- (id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
