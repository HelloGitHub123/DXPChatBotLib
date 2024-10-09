//
//  IMAppDotNetAPIClient.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedDefaultSessionClient;

@end

NS_ASSUME_NONNULL_END
