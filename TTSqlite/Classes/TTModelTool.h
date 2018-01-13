//
//  TTModelTool.h
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTModelTool : NSObject

+ (NSString *)tableName:(Class)cls;
+ (NSString *)tmpTableName:(Class)cls;
+ (NSString *)columnNamesAndTypesStr:(Class)cls;

// 所有的成员变量, 以及成员变量对应的类型
+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;
// 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

+ (NSArray *)allTableScortedIvarNames:(Class)cls;
@end
