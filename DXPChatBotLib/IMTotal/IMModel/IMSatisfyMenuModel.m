//
//  IMSatisfyMenuModel.m
//  IMDemo
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMSatisfyMenuModel.h"
#import "NSString+IM.h"

@implementation IMSatisfyMenuModel

- (id)init {
    self = [super init];
    if (self) {
        _index = @"";
        _title = @"";
        _type = @"";
        _isSelect = NO;
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.index = [NSString imStringWithoutNil:[dic objectForKey:@"index"]];
        
        self.title = [NSString imStringWithoutNil:[dic objectForKey:@"title"]];
        
        self.type = [NSString imStringWithoutNil:[dic objectForKey:@"type"]];
        
        self.isSelect = [[NSString imStringWithoutNil:[dic objectForKey:@"isSelect"]] boolValue];
    }
    return self;
}


@end
