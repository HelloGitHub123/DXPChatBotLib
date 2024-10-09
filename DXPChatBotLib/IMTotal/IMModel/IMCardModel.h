//
//  IMCardModel.h
//  CLP
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMCardModel : NSObject

@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSMutableArray *cateMenuList;

- (id)initWithDic:(NSDictionary *)dic;

@end

@interface IMSecondMenuModel : NSObject

@property (nonatomic, copy) NSString *categoryCode;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSMutableArray *questionList;

- (id)initWithDic:(NSDictionary *)dic isSelect:(BOOL)isSelect;

@end

@interface IMQuestionModel : NSObject

@property (nonatomic, copy) NSString *questionCode;
@property (nonatomic, copy) NSString *questionMsg;

- (id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
