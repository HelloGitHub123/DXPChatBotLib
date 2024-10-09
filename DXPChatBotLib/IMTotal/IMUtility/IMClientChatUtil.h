//
//  IMClientChatUtil.h
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - UCCSecurityResult
@interface UCCSecurityResult : NSObject

@property (strong, nonatomic, readonly) NSData *data;
@property (strong, nonatomic, readonly) NSString *utf8String;
@property (strong, nonatomic, readonly) NSString *hex;
@property (strong, nonatomic, readonly) NSString *hexLower;
@property (strong, nonatomic, readonly) NSString *base64;

- (id)initWithBytes:(unsigned char[])initData length:(NSUInteger)length;

@end

#pragma mark - UCCSecurityEncoder
@interface UCCSecurityEncoder : NSObject
- (NSString *)base64:(NSData *)data;
- (NSString *)hex:(NSData *)data useLower:(BOOL)isOutputLower;
@end


#pragma mark - UCCSecurityDecoder
@interface UCCSecurityDecoder : NSObject
- (NSData *)base64:(NSString *)data;
- (NSData *)hex:(NSString *)data;
@end

@interface IMClientChatUtil : NSObject

+ (NSString *)getNetSignatureWithContent:(id)content andDate:(NSString *)gmtDate;

+ (NSString *)getNetSignatureWithContent1:(id)content andDate:(NSString *)gmtDate;

+ (NSData *)imageForCodingUpload:(UIImage *)image andMaxLen:(NSInteger)dataLength;

+ (NSString *)UUIDString;

+ (NSString *)md5Str:(NSString *)str;

+ (NSString *)currentGMT;

//+ (NSData *)convertCAFtoAMR:(NSString *)fielPath;

+ (NSString *)getNowGMTDateStr;

+ (NSString *)getGMTDateStr:(NSDate *)date;

+ (NSString *)getNowDateStr;

+ (NSString *)formatDate:(NSDate *)date formatter:(NSString *)fromatter;

+ (BOOL)isEmptyStr:(NSString *)str;

// 当前时间戳。毫秒
+ (NSString *)getNowTimeTimestamp3;

// 临时
+ (UCCSecurityResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key;

@end
