//
//  TTSqliteTool.m
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import "TTSqliteTool.h"
#import "sqlite3.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
//#define kCachePath @"/Users/renmenghan/Desktop"

@implementation TTSqliteTool

sqlite3 *ppDb = nil;

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid
{
    // 打开数据库
    if (![self openDB:uid]) {
        NSLog(@"数据库打开失败");
        return NO;
    }

    // 执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    // 关闭数据库
    [self closeDB];
    
    return result;
}

+ (BOOL)dealSqls:(NSArray<NSString *> *)sqls uid:(NSString *)uid
{
    [self beginTransaction:uid];
    for (NSString *sql in sqls) {
        BOOL result = [self deal:sql uid:uid];
        if (result == NO) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    [self commitTransaction:uid];
    return YES;
}

+ (void)beginTransaction:(NSString *)uid{
    [self deal:@"begin transaction" uid:uid];
}
+ (void)commitTransaction:(NSString *)uid{
    [self deal:@"commit transaction" uid:uid];
}
+ (void)rollBackTransaction:(NSString *)uid{
    [self deal:@"rollback transaction" uid:uid];
}

+ (NSMutableArray<NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid
{
    [self openDB:uid];
    // 准备语句（预处理语句）
    
    // 1. 创建准备语句
    /**
        参数1：一个已经打开的数据库
        参数2：需要的sql
        参数3：参数2取出多少字节的长度 -1 自动计算 \0
        参数4：准备语句
        参数5：通过参数3取出参数2的长度字节后剩下的字符串
     */
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    // 2. 绑定数据（省略）
    
    // 3.执行
    // 大数组
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 1.获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        
        // 2.遍历所有的列
        for (int i = 0 ; i < columnCount; i++) {
            // 2.1 获取列名字
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            // 2.2 获取列值
            // 不同列的类型 使用不同的函数 进行获取
            // 2.2.1获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 2.2.2 根据列的类型 使用不同的函数 进行获取
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                default:
                    break;
            }
            [rowDic setValue:value forKey:columnName];
        }
    }
    
    // 4.重置（省略）
    
    // 5. 释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDicArray;
    
}
#pragma mark - 私有方法

+(void)closeDB
{
    sqlite3_close(ppDb);
}

+(BOOL)openDB:(NSString *)uid
{
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite",uid];
    }
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    // 创建&打开一个数据库
    
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}
@end
