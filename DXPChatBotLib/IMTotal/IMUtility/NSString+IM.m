//
//  NSString+IM.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NSString+IM.h"
#import "UCCHeader.h"

@implementation NSString (IM)

+ (NSString *)imStringWithoutNil:(id)string {
    NSString *tempStr = [NSString stringWithFormat:@"%@",string];
    return [NSString isIMBlankString:tempStr]?@"":tempStr;
}

+ (BOOL)isIMBlankString:(NSString *)string {
    if (string == nil || string == NULL ) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]){
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getCellIdentifier:(IMMsgModel *)model {
    if (model.msgType == IMMsgContentType_text) {
        if (model.isHTML) return CellIdentifierHtml;
        return CellIdentifierText;
    } else if (model.msgType == IMMsgContentType_image) {
        return CellIdentifierImage;
    } else if (model.msgType == IMMsgContentType_voice) {
        return CellIdentifierVoice;
    } else if (model.msgType == IMMsgContentType_video) {
        return CellIdentifierVideo;
    } else if (model.msgType == IMMsgContentType_file) {
        return CellIdentifierFile;
    } else if (model.msgType == IMMsgContentType_linkList) {
        if ([model.sessionState isEqualToString:@"C"] || [model.sessionState isEqualToString:@"Q"]) {
            return CellIdentifierlinkList;
        } else {
            return CellIdentifierSatisfaction;
        } 
    } else if (model.msgType == IMMsgContentType_menuList) {
        return CellIdentifierMenuList;
    } else if (model.msgType == IMMsgContentType_disLike) {
        return CellIdentifierDisLike;
    } else if (model.msgType == IMMsgContentType_dataPrivacy) {
        return CellIdentifierMenuBtnList;
    } else if (model.msgType == IMMsgContentType_userInfo) {
        return CellIdentifierUserInfo;
    } else if (model.msgType == IMMsgContentType_typing) {
        return CellIdentifierTyping;
    } else if (model.msgType == IMMsgContentType_VOIP) {
        return CellIdentifierVoip;
    }
    
    return CellIdentifierNone;
}

- (id)JSONValue {
    NSData* jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    if (jsonData) {
        if ([jsonData length] > 0) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            return jsonObj;
        }
    }
    
    return nil;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    if (!jsonData) {
		NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSRange range3 = {0,mutStr.length};
    //单引号转义
    [mutStr replaceOccurrencesOfString:@"'" withString:@"''" options:NSLiteralSearch range:range3];
    
    return mutStr;
}

+ (NSString *)dictionaryToJsonWithOutSpace:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    if (!jsonData) {
		NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,jsonString.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

+ (NSString *)getLocalMsgId {
    return [NSString stringWithFormat:@"im_%@", [NSUUID UUID].UUIDString];
}

+ (NSString *)getCurrentTimestamp {
    //获取系统当前的时间戳 13位，毫秒级；10位，秒级
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSDecimalNumber *timeNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", time]];
    NSDecimalNumber *baseNumber = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *result = [timeNumber decimalNumberByMultiplyingBy:baseNumber];
    return [NSString stringWithFormat:@"%ld", (long)[result integerValue]];
}

+ (NSString *)getCreateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:COMMON_FORMATTER];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (CGSize)sizeForWidth:(CGFloat)width withFont:(UIFont*)font {
    NSAssert(font, @"heightForWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    size.height = ceilf(size.height)+1;
    size.width = ceilf(size.width);
    return size;
}

- (CGSize)singleSizeWithFont:(UIFont*)font {
    NSAssert(font, @"singleHeightWithFont:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    
    return size;
}


@end
