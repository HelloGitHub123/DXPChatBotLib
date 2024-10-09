//
//  IMCardModel.m
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IMCardModel.h"
#import "NSString+IM.h"

@implementation IMCardModel

- (id)init {
    self = [super init];
    if (self) {
        _categoryCode = @"";
        _categoryName = @"";
        _cateMenuList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.categoryCode = [NSString imStringWithoutNil:[dic objectForKey:@"categoryCode"]];
        self.categoryName = [NSString imStringWithoutNil:[dic objectForKey:@"categoryName"]];
        self.cateMenuList = [[NSMutableArray alloc] init];
        NSArray *cateMenuList = [dic objectForKey:@"cateMenuList"];
        if (![cateMenuList isKindOfClass:[NSNull class]]) {
            for (int i=0 ;i<cateMenuList.count; i++) {
                NSDictionary *subDic = [cateMenuList objectAtIndex:i];
                IMSecondMenuModel *model = [[IMSecondMenuModel alloc] initWithDic:subDic isSelect:i==0?YES:NO];
                [self.cateMenuList addObject:model];
            }
        }
    }
    return self;
}

@end

@implementation IMSecondMenuModel

- (id)init {
    self = [super init];
    if (self) {
        _categoryCode = @"";
        _categoryName = @"";
        _isSelect = NO;
        _questionList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic isSelect:(BOOL)isSelect {
    self = [super init];
    if (self) {
        self.categoryCode = [NSString imStringWithoutNil:[dic objectForKey:@"categoryCode"]];
        self.categoryName = [NSString imStringWithoutNil:[dic objectForKey:@"categoryName"]];
        self.isSelect = isSelect;
        self.questionList = [[NSMutableArray alloc] init];
        NSArray *questionList = [dic objectForKey:@"questionList"];
        if (![questionList isKindOfClass:[NSNull class]]) {
            for (int i=0 ;i<questionList.count; i++) {
                NSDictionary *subDic = [questionList objectAtIndex:i];
                IMQuestionModel *model = [[IMQuestionModel alloc] initWithDic:subDic ];
                [self.questionList addObject:model];
            }
        }
    }
    return self;
}

@end

@implementation IMQuestionModel

- (id)init {
    self = [super init];
    if (self) {
        _questionCode = @"";
        _questionMsg = @"";
    }
    return self;
}

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.questionCode = [NSString imStringWithoutNil:[dic objectForKey:@"questionCode"]];
        self.questionMsg = [NSString imStringWithoutNil:[dic objectForKey:@"questionMsg"]];
    }
    return self;
}

@end
