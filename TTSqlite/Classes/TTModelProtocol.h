//
//  TTModelProtocol.h
//  TTSqlite
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol TTModelProtocol <NSObject>
@required

/**
 操作模型必须实现的方法，通过这个方法可以获得主键信息

 @return 主键字符串
 */
+ (NSString *)primaryKey;

@optional

/**
 忽略的字段

 @return 忽略的字段数组
 */
+ (NSArray *)ignoreColumnName;

/**
 新字段名称-> 旧字段名称的映射表格

 @return 映射表格
 */
+ (NSDictionary *)newNameToOldNameDic;
@end
