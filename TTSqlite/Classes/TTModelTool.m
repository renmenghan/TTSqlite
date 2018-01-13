//
//  TTModelTool.m
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import "TTModelTool.h"
#import <objc/runtime.h>
#import "TTModelProtocol.h"

@implementation TTModelTool

+ (NSString *)tableName:(Class)cls
{
    return NSStringFromClass(cls);
}
+ (NSString *)tmpTableName:(Class)cls
{
    return [NSStringFromClass(cls) stringByAppendingString:@"_tmp"];
}

+ (NSDictionary *)classIvarNameTypeDic:(Class)cls{
    // 获取这个类里面所有的成员变量以及类型
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    
    NSArray *ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreColumnName)]) {
        ignoreNames = [cls ignoreColumnName];
    }
    
    for (int i = 0 ; i < outCount; i++) {
        Ivar ivar = varList[i];
        // 1.获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        if ([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        // 2.获取成员变量类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [nameTypeDic setValue:type forKey:ivarName];
    }
    return nameTypeDic;
}

+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls{
    NSMutableDictionary *dic = [[self classIvarNameTypeDic:cls] mutableCopy];
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dic[key] = typeDic[obj];
    }];
    return dic;
}

+ (NSString *)columnNamesAndTypesStr:(Class)cls{
    NSDictionary *nameTypeDic = [self classIvarNameSqliteTypeDic:cls];
    
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@",key,obj]];
    }];
    return [result componentsJoinedByString:@","];
    
}


+ (NSArray *)allTableScortedIvarNames:(Class)cls
{
    NSDictionary *dic = [self classIvarNameTypeDic:cls];
    NSArray *keys = dic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return keys;
}

// 映射
+ (NSDictionary *)ocTypeToSqliteTypeDic{
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
}
@end
