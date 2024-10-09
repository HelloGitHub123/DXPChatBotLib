//
//  IMHttpRequest.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMHttpRequest : NSObject

/* 1、 In order to obtain flowNo, beginSession Interface that must be called
   2、 Connect socket with flowNo
 */
+ (void)beginSessionWithUserAcct:(NSString *)userAcct accNbr:(NSString *)accNbr acData:(NSString *)acData createTime:(NSString *)createTime custId:(NSString *)custId isRestart:(NSString *)isRestart firstName:(NSString *)firstName lastName:(NSString *)lastName emailAddress:(NSString *)emailAddress phoneNumber:(NSString *)phoneNumber birthday:(NSString *)birthday block:(void (^)(NSString *flowNo, NSError *error))block;


/* Send text message */
+ (void)sendMessage:(NSString *)message flowNo:(NSString *)flowNo createTime:(NSString *)createTime msgType:(NSInteger)msgType block:(void (^)(NSError *error, NSString *msgSeenId))block;


/* Send image message */
+ (void)sendImage:(NSString *)message flowNo:(NSString *)flowNo createTime:(NSString *)createTime block:(void (^)(NSError *error))block;


/* 其他业务接口，比如评价人工客服 Other business interfaces, such as evaluation of human customer service */
+ (void)postHttpUrl:(NSString *)url param:(NSDictionary *)param block:(void (^)(id responseObject ,NSError *error))block;

/* 结束会话 */
+ (void)endSessionByFlowNo:(NSString *)flowNo block:(void (^)(NSError *error))block;

/* 每当点 Yes 后校验 VOIP 请求是否有效 */
+ (void)checkVoipValidityByFlowNo:(NSString *)flowNo voipAgentId:(NSString *)voipAgentId block:(void (^)(id responseObject ,NSError *error))block;

/* 每当点 No 后发送客户拒绝结果 */
+ (void)checkVoipResultByFlowNo:(NSString *)flowNo voipAgentId:(NSString *)voipAgentId block:(void (^)(id responseObject ,NSError *error))block;
@end

NS_ASSUME_NONNULL_END
