//
//  IMDisLikeModel.m
//  CLP
//
//  Created by mac on 2020/9/27.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMDisLikeModel.h"
#import "NSString+IM.h"

@implementation IMDisLikeModel

- (id)init {
    self = [super init];
    if (self) {
        _unsatReasonCode = @"";
        _unsatReasonName = @"";
        _isSelect = NO;
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.unsatReasonCode = [NSString imStringWithoutNil:[dic objectForKey:@"unsatReasonCode"]];
        self.unsatReasonName = [NSString imStringWithoutNil:[dic objectForKey:@"unsatReasonName"]];
        self.isSelect = [[NSString imStringWithoutNil:[dic objectForKey:@"isSelect"]] boolValue];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    IMDisLikeModel *model = [[[self class] allocWithZone:zone] init];
    model.unsatReasonCode = self.unsatReasonCode;
    model.unsatReasonName = self.unsatReasonName;
    model.isSelect = self.isSelect;
    return model;
}

@end
