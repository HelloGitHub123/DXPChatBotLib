//
//  IMSatisfyMainInfoModel.m
//  IMDemo
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMSatisfyMainInfoModel.h"
#import "IMSatisfyMenuModel.h"
#import "NSString+IM.h"

@implementation IMSatisfyMainInfoModel

- (id)init {
    self = [super init];
    if (self) {
        _header = @"";
        _feedbackType = @"";
        _questionText = @"";
        _isTypeQ = NO;
        _menu = [[NSMutableArray alloc] init];
        _questionInput = @"";
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.header = [NSString imStringWithoutNil:[dic objectForKey:@"header"]];
        
        self.feedbackType = [NSString imStringWithoutNil:[dic objectForKey:@"feedbackType"]];
        
        self.questionText = [NSString imStringWithoutNil:[dic objectForKey:@"questionText"]];
        
        self.menu = [[NSMutableArray alloc] init];
        NSArray *menu = [dic objectForKey:@"menu"];
        for (NSDictionary *tempDic in menu) {
            IMSatisfyMenuModel *model = [[IMSatisfyMenuModel alloc] initWithDic:tempDic];
            if ([model.type isEqualToString:@"Q"]) {
                self.isTypeQ = YES;
            }
            [self.menu addObject:model];
        }
        
        self.questionInput = [NSString imStringWithoutNil:[dic objectForKey:@"questionInput"]];        
    }
    return self;
}

@end
