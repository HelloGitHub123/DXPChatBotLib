//
//  IMChatDBManager.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMChatDBManager.h"
#import "IMDBManager.h"
#import <fmdb/FMDB.h>
#import "NSString+IM.h"
#import "IMSatisfyMenuModel.h"
#import "IMDisLikeModel.H"
#import "FMDatabaseQueue.h"
@implementation IMChatDBManager

+ (BOOL)insertChatDBWithUserId:(NSString*)userId model:(IMMsgModel *)model {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block BOOL result = NO;
    [dataQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO T_DB_CHAT (userId, msgId, msgType, createType, mainInfo, sessionState, createTime, jumpMenu, needBtn, nickName, agentPicture, answerSource, messageId, isShowTime, cellHeight, isSubmit, extend, isHTML, isHtmlReload, isMsgSend, needHelpful, showHelpful, seen, msgSeenId) VALUES  (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,userId ,model.msgId, @(model.msgType), @(model.createType), model.mainInfo, model.sessionState, model.createTime, model.jumpMenu, model.needBtn, model.nickName, model.agentPicture, model.answerSource, model.messageId, @(model.isShowTime), @(model.cellHeight), @(model.isSubmit), model.extend, @(model.isHTML), @(model.isHtmlReload), @(model.isMsgSend), @(model.needHelpful), @(model.showHelpful), @(model.isSeen), model.msgSeenId];
         
        if (!result) {
			NSLog(@"insert ChatDB failed");
        }
     }];
    return result;
}

+ (NSMutableArray *)queryMJHeaderChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *findSql = @"";
        if ([NSString isIMBlankString:lastTime]) {
            findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' Order By createTime DESC limit 10", @"T_DB_CHAT", userId];
        } else {
            findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' and createTime < '%@' Order By createTime DESC limit 10", @"T_DB_CHAT", userId, lastTime];
        }

        FMResultSet *rs = [db executeQuery:findSql];
         
        while ([rs next]){
            IMMsgModel *model = [[IMMsgModel alloc] initWithResultSet:rs];
            [resultArray addObject:model];
        }
         
        if (rs) {
            [rs close];
        }
     }];
    
    return resultArray;
}

+ (NSMutableArray *)queryMJFooterChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' and createTime > '%@' Order By createTime ASC limit 10", @"T_DB_CHAT", userId, lastTime];

        FMResultSet *rs = [db executeQuery:findSql];
         
        while ([rs next]){
            IMMsgModel *model = [[IMMsgModel alloc] initWithResultSet:rs];
            [resultArray addObject:model];
        }
         
        if (rs) {
            [rs close];
        }
     }];
    
    return resultArray;
}

+ (NSString *)queryLastDataTimeWithUserId:(NSString *)userId {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSString *createTime = @"";
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' and isShowTime = '%d' Order By createTime DESC", @"T_DB_CHAT", userId, YES];

         FMResultSet *rs = [db executeQuery:findSql];
         
         while ([rs next]){
             createTime = [rs stringForColumn:@"createTime"];
             break;
         }
         if (rs) {
             [rs close];
         }
     }];

    return createTime;
}

+ (void)updateCellHeightWithUserId:(NSString *)userId msgId:(NSString *)msgId cellHeight:(NSInteger)cellHeight {
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET cellHeight = '%ld' WHERE userId ='%@' and msgId = '%@'", (long)cellHeight, userId, msgId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

+ (void)updateMainInfoWithUserId:(NSString *)userId msgId:(NSString *)msgId mainInfo:(NSString *)mainInfo {
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    if ([mainInfo rangeOfString:@"'"].location != NSNotFound) {
        mainInfo = [mainInfo stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
    }
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET mainInfo = '%@' WHERE userId ='%@' and msgId = '%@'", mainInfo, userId, msgId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

+ (void)updateIsSubmitWithUserId:(NSString *)userId msgId:(NSString *)msgId isSubmit:(BOOL)isSubmit {
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET isSubmit = '%ld' WHERE userId ='%@' and msgId = '%@'", (long)isSubmit, userId, msgId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

+ (void)updateExtendWithUserId:(NSString *)userId msgId:(NSString *)msgId extend:(NSString *)extend {
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET extend = '%@' WHERE userId ='%@' and msgId = '%@'", extend, userId, msgId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

+ (void)updateExtendWithUserId:(NSString *)userId msgId:(NSString *)msgId isHtmlReload:(BOOL)isHtmlReload {
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET isHtmlReload = '%d' WHERE userId ='%@' and msgId = '%@'", isHtmlReload, userId, msgId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

+ (NSMutableArray *)querySearchChatDBWithUserId:(NSString *)userId key:(NSString *)key {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' and mainInfo like '%%%@%%' Order By createTime DESC", @"T_DB_CHAT", userId, key];
        FMResultSet *rs = [db executeQuery:findSql];
        while ([rs next]){
            IMMsgModel *model = [[IMMsgModel alloc] initWithResultSet:rs];
            if (model.msgType == IMMsgContentType_text && (model.createType == IMMsgCreateType_user || ([model.sessionState isEqualToString:@"S"] && model.createType == IMMsgCreateType_server) )) {
                [resultArray addObject:model];
            }
        }
         
        if (rs) {
            [rs close];
        }
     }];
    
    return resultArray;
}

+ (NSMutableArray *)queryAllSearchChatDBWithUserId:(NSString *)userId lastTime:(NSString *)lastTime {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@' and createTime >= '%@' Order By createTime ASC", @"T_DB_CHAT", userId, lastTime];

        FMResultSet *rs = [db executeQuery:findSql];
         
        while ([rs next]){
            IMMsgModel *model = [[IMMsgModel alloc] initWithResultSet:rs];
            [resultArray addObject:model];
        }
         
        if (rs) {
            [rs close];
        }
     }];
    
    return resultArray;
}

+ (NSMutableArray *)queryAllResultDBWithUserId:(NSString *)userId {
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString * findSql = [NSString stringWithFormat:@"SELECT * FROM %@ where userId ='%@'", @"T_DB_CHAT", userId];
        FMResultSet *rs = [db executeQuery:findSql];
        
        while ([rs next]){
            IMMsgModel *model = [[IMMsgModel alloc] initWithResultSet:rs];
            [resultArray addObject:model];
        }
    
        if (rs) {
            [rs close];
        }
     }];
    
    return resultArray;
}


+ (void)updateSeenWithUserId:(NSString *)userId msgSeenId:(NSString *)msgSeenId isSeen:(BOOL)isSeen {
    
    if (isEmptyString_IM(msgSeenId)) {
        return;
    }
    
    __block BOOL result = NO;
    FMDatabaseQueue *dataQueue = [IMDBManager getDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE T_DB_CHAT SET seen = '%d' WHERE userId ='%@' and msgSeenId = '%@'", 1, userId, msgSeenId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            result = YES;
        }
        [rs close];
    }];
}

@end
