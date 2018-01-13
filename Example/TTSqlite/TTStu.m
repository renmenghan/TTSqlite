//
//  TTStu.m
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import "TTStu.h"

@implementation TTStu

+ (NSString *)primaryKey
{
    return @"stuNum";
}
+ (NSArray *)ignoreColumnName
{
    return @[@"score2"];
}
+ (NSDictionary *)newNameToOldNameDic
{
    return @{@"age":@"age1"};
}
@end
