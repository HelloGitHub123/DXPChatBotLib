//
//  IMDisLikeModel.h
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMDisLikeModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *unsatReasonCode;
@property (nonatomic, copy) NSString *unsatReasonName;
@property (nonatomic, assign) BOOL isSelect;

- (id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
