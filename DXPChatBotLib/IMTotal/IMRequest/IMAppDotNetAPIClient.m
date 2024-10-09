//
//  IMAppDotNetAPIClient.m
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMAppDotNetAPIClient.h"
#import "IMConfigSingleton.h"

@implementation IMAppDotNetAPIClient

+ (instancetype)sharedDefaultSessionClient {
    static IMAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[IMAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[IMConfigSingleton sharedInstance].baseURLStr]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"image/jpeg", @"video/mp4", @"application/xml", @"text/xml", @"application/x-plist", nil];
    }
    return self;
}

@end
