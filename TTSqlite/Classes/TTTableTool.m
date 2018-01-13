//
//  TTTableTool.m
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/10.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import "TTTableTool.h"
#import "TTModelTool.h"
#import "TTSqliteTool.h"

@implementation TTTableTool

+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    
    // create table ttstu(age integer,stuNum integer,score real,name text,primary key(stuNum))
    
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    
    NSMutableDictionary *dic = [TTSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
//    NSString *createTableSql = [dic[@"sql"] lowercaseString];

    NSString *createTableSql = dic[@"sql"] ;
    // create table ttstu(age integer,stunum integer,score real,name text,primary key(stunum))
    if (createTableSql.length == 0) {
        return nil;
    }
    
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    // CREATE TABLE XMGStu((stuNum))
    
    // 1. age integer,stuNum integer,score real,name text, primary key
    //    CREATE TABLE "XMGStu" ( \n
    //                           "age2" integer,
    //                           "stuNum" integer,
    //                           "score" real,
    //                           "name" text,
    //                           PRIMARY KEY("stuNum")
    //                           )
    
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    
    // age integer
    // stuNum integer
    // score real
    // name text
    // primary key
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    NSMutableArray *names = [NSMutableArray array];
    
    for (NSString *nameType in nameTypeArray) {
        if ([nameType containsString:@"primary"]) {
            continue;
        }
        NSString *nameType2 = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        // age integer
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        
        [names addObject:name];
    }
    
   [names sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return names;
    
}

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'",tableName];
    
    NSMutableArray *result = [TTSqliteTool querySql:queryCreateSqlStr uid:uid];
    
    return result.count > 0;
}

@end
