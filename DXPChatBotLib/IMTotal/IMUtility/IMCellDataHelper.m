//
//  IMCellDataHelper.m
//  IMDemo
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMCellDataHelper.h"
#import "NSString+IM.h"
#import "IMChatDBManager.h"
#import "IMConfigSingleton.h"

@implementation IMCellDataHelper

+ (NSArray *)getMenuList:(NSString *)jsonString {
    if (!jsonString || jsonString.length == 0) return @[];
      
    NSDictionary *jsonDic = [jsonString JSONValue];
    if (!jsonDic) return @[];
    
    NSArray *menuArray = [jsonDic objectForKey:@"menu"];
    if (!menuArray) return @[];

    return menuArray;
}

+ (NSString *)getMenuHeaderContent:(NSString *)jsonString {
  if (!jsonString || jsonString.length == 0) return jsonString;
    
  NSDictionary *jsonDic = [jsonString JSONValue];
  if (!jsonDic) return jsonString;
  
  return [jsonDic objectForKey:@"header"];
}

+ (NSString *)getCellHeaderDate:(NSString *)dateStr {
    if ([NSString isIMBlankString:dateStr]) return @"";
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[dateStr longLongValue]/1000];
    //add by zmm
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm aa"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得当前系统的时区
    [dateFormatter setTimeZone:zone];// 设定时区
    return [dateFormatter stringFromDate:date];
    
//    NSString *relativeDate = [self relativeDateForDate:date];
//    NSString *time = [self timeForDate:date];
//    return [NSString stringWithFormat:@"%@ %@", time, relativeDate];
}

+ (NSString *)relativeDateForDate:(NSDate *)date {
    if (!date) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得当前系统的时区
    [dateFormatter setTimeZone:zone];// 设定时区
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)timeForDate:(NSDate *)date {
    if (!date) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得当前系统的时区
    [dateFormatter setTimeZone:zone];// 设定时区
    return [dateFormatter stringFromDate:date];
}

+ (BOOL)getMsgTimeIsShow:(NSString *)createTime {
    if ([NSString isIMBlankString:createTime]) return YES;
    NSString *lastTime = [IMChatDBManager queryLastDataTimeWithUserId:[IMConfigSingleton sharedInstance].userId];
    if ([NSString isIMBlankString:lastTime]) return YES;
    
    NSTimeInterval start = [lastTime doubleValue]/1000;
    NSTimeInterval end = [createTime doubleValue]/1000;
    NSTimeInterval value = end - start;
    int minute = (int)value / 60 % 60;
    if (minute > 5) {
        return YES;
    }
    return NO;
}

+ (NSMutableArray *)getMatchContent:(NSString *)content {
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    if (content && content.length > 0) {
        NSString *regex = @"((https?|http|ftp|file):\\/\\/|(www\\.))[-A-Za-z0-9+&@#\\/%?=~_|!:,.;]+[-A-Za-z0-9+&@#\\/%=~_|]";
        NSError *error = NULL;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *resultArray = [expression matchesInString:content options:0 range:NSMakeRange(0, [content length])];
        
        for (int i = 0;i < resultArray.count; i++) {
            NSTextCheckingResult *result = [resultArray objectAtIndex:i];
            NSString *matchStr = [content substringWithRange:result.range];
            [matchArray addObject:matchStr];
        }
    }
    return matchArray;
}

+ (BOOL)getMainInfoIsHtml:(NSString *)mainInfo {
    NSString *regex = @"<(\\S*?)[^>]*>.*?|<.*? />";
    NSError *error = NULL;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray = [expression matchesInString:mainInfo options:0 range:NSMakeRange(0, [mainInfo length])];
    if (resultArray.count > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)verifyWebUrlAddress:(NSString *)webUrl {
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:webUrl];
}

//获取a标签
+ (NSString *)getMatchHTML:(NSString *)html href:(NSString *)href {
    NSMutableArray *aLabArray = [[self class] getMatchHtml:html regex:@"<a .*?>(.*?)</a>"];
    NSString *aTag = @"";
    for (int i = 0;i < aLabArray.count; i++) {
        NSString *matchStr = [aLabArray objectAtIndex:i];
        if ([matchStr rangeOfString:href].location != NSNotFound) {
            aTag = matchStr;
            break;
        }
    }
    
    NSMutableArray *aArray = [[self class] getMatchHtml:aTag regex:@"<a .*?>"];
    if (aArray.count == 1) {
        NSString *result = [aTag stringByReplacingOccurrencesOfString:[aArray objectAtIndex:0] withString:@""];
        return [result stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    }
    
    return href;
}

+ (NSMutableArray *)getMatchHtml:(NSString *)html regex:(NSString *)regex {
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    if (html && html.length > 0) {
        NSError *error = NULL;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *resultArray = [expression matchesInString:html options:0 range:NSMakeRange(0, [html length])];
        
        for (int i = 0;i < resultArray.count; i++) {
            NSTextCheckingResult *result = [resultArray objectAtIndex:i];
            NSString *matchStr = [html substringWithRange:result.range];
            [matchArray addObject:matchStr];
        }
    }
    return matchArray;
}

@end
