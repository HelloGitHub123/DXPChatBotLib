//
//  IMConfigSingleton.m
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMConfigSingleton.h"

static IMConfigSingleton * _instance = nil;

@implementation IMConfigSingleton

+ (IMConfigSingleton *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMConfigSingleton alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _fileURLStr = @"";
        _baseURLStr = @"";
        _secretKey = @"";
        _sysAccount = @"";
        _langCode = @"";
        _userId = @"";
        _dislikeMessageId = @"";
        _sessionS = NO;
		_selfUrlScheme = @"clp://";
    }
    return self;
}


@end
