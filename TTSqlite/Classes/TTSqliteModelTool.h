//
//  TTSqliteModelTool.h
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2017/1/9.
//  Copyright © 2017年 renmenghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTModelProtocol.h"

typedef NS_ENUM(NSUInteger,ColumnNameToValueRelationType){
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual,
};

@interface TTSqliteModelTool : NSObject
/**
 根据一个模型类, 创建数据库表
 
 @param cls 类名
 @param uid 用户唯一标识
 @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;
/**
 判断一个表格是否需要更新
 
 @param cls 类名
 @param uid 用户唯一标识
 @return 是否需要更新
 */

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;
/**
 更新表格
 
 @param cls 类名
 @param uid 用户唯一标识
 @return 是否更新成功
 */
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

// 根据条件删除
// age > 19
// score <= 10 and xxx
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)releation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls colunmName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

+ (NSArray *)queryModels:(Class)cls withSql:(NSString *)sql uid:(NSString *)uid;
@end
