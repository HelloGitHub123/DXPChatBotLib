//
//  IMDBManager.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue,FMDatabase;
#define T_UCC_DB_NAME          @"T_UCC_DB.db"  //数据库名称

NS_ASSUME_NONNULL_BEGIN

@interface IMDBManager : NSObject

+ (FMDatabaseQueue *)getDBQueue;

+ (void)initDBSettings;

@end

NS_ASSUME_NONNULL_END
