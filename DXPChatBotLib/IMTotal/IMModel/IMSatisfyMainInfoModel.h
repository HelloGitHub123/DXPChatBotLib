//
//  IMSatisfyMainInfoModel.h
//  IMDemo
//
//  Created by mac on 2020/8/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// all 满意度
@interface IMSatisfyMainInfoModel : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *feedbackType;//A：文本，B：星星
@property (nonatomic, copy) NSString *questionText;//是否需要改进项文本，Y/N
@property (nonatomic, assign) BOOL isTypeQ;//F表示评分项；Q表示改进项
@property (nonatomic, strong) NSMutableArray *menu;
@property (nonatomic, copy) NSString *questionInput;//输入框内容

- (id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
