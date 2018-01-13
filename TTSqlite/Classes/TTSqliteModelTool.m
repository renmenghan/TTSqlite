//
//  TTSqliteModelTool.m
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import "TTSqliteModelTool.h"
#import "TTModelTool.h"
#import "TTSqliteTool.h"
#import "TTTableTool.h"

@implementation TTSqliteModelTool

// 关于这个工具类的封装
// 实现方案 1. 基于配置2.Runtime动态获取
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid
{
    // 1.创建表格的sql语句拼接
    
    // create table if not exists 表名（字段1 字段1类型，字段2 字段2类型 （约束），... ,primary key（字段））
    // 1.1 获取表格名称
    NSString *tableName = [TTModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型 必须要实现+(NSString *)primaryKey;这个方法 来实现主键");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    
    // 1.2 获取一个模型里面所有的字段 以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key(%@))",tableName,[TTModelTool columnNamesAndTypesStr:cls],primaryKey];
    
    // 2 执行
    return [TTSqliteTool deal:createTableSql uid:uid];;
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid
{
    NSArray *modelNames = [TTModelTool allTableScortedIvarNames:cls];
    NSArray *tableNames = [TTTableTool tableSortedColumnNames:cls uid:uid];
    
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid
{
    // 1 创建一个拥有正确结构的临时表
    // 1.1 获取表格名称
    NSString *tmpTableName  = [TTModelTool tmpTableName:cls];
    NSString *tableName     = [TTModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型，必须实现+(NSString *)primaryKey;这个方法，来告诉我主键信息");
        return NO;
    }
    
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key(%@));",tmpTableName,[TTModelTool columnNamesAndTypesStr:cls],primaryKey];
    
    [execSqls addObject:createTableSql];
    // 2.根据主键 插入数据
    // insert into ttstu_tmp(stuNum) select stuNum from ttstu;
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@",tmpTableName,primaryKey,primaryKey,tableName];
    
    [execSqls addObject:insertPrimaryKeyData];
    // 3.根据主键，把所有的数据更新到表里
    NSArray *oldNames = [TTTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [TTModelTool allTableScortedIvarNames:cls];
    //4. 获取更名字典
    NSDictionary *newNameToOldNameDic = @{};
    
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        // 找映射的旧的字段名称
        if ([newNameToOldNameDic[columnName] length]!= 0) {
            // columnname age1  oldnames age1
            // oldname age
            oldName = newNameToOldNameDic[columnName];
//            if (![newNames containsObject:oldName]) {
//                oldName = columnName;
//            }
        }
        // 如果老表包含了新的列名 应该从老表更新到临时表格里面
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey] ) {
            
            
            continue;
        }
        //不包含
//        if (![oldNames containsObject: columnName]) {
//            continue;
//        }
        // 包含
        // update ttstu_tmp set sorce = (select sorce from ttstu where ttstu_tmp.stuNum = ttstu.stuNum)
        // update 临时表 set 新字段名称 = （select 旧字段名 from 旧表 where 临时表.主键 = 旧表.主键）
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)",tmpTableName,columnName,oldName,tableName,tmpTableName,primaryKey,tableName,primaryKey];
        [execSqls addObject:updateSql];
    }
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@",tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@",tmpTableName,tableName];
    [execSqls addObject:renameTableName];
    
    return [TTSqliteTool dealSqls:execSqls uid:uid];
    
}


+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid
{
    // 如果用户在使用过程中 直接调用这个方法 去保存模型
    // 保存一个模型
    Class cls = [model class];
    // 1. 判断表格是否存在 不存在则创建
    if ([TTTableTool isTableExists:cls uid:uid]) {
        [self createTable:cls uid:uid];
    }
    // 2. 检测表格是否需要更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        BOOL updateSuccess = [self updateTable:cls uid:uid];
        if (!updateSuccess) {
            NSLog(@"更新数据库表结构失败");
            return NO;
        }
    }
    // 3. 判断记录是否存在 主键
    // 从表格里按照主键 进行查询该记录 如果能够查询到
    NSString *tableName = [TTModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString  *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",tableName,primaryKey,primaryValue];
    
    NSArray *result = [TTSqliteTool querySql:checkSql uid:uid];
    
    
    // 获取字段数组
    NSArray *columnNames = [TTModelTool classIvarNameTypeDic:cls].allKeys;
    // 获取值数组
    // model keyPath:
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            // 在这里把字典 或者 数组 处理成一个字符串 保存到数据库中
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
        }
        
        [values addObject:value];
    }
    
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i< count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'",name,value];
        [setValueArray addObject:setStr];
    }
    
    // 更新
    // 字段名称 字段值
    // update 表明 set 字段1=字段1值，....where 主键=‘主键值’
    NSString *execSql = @"";
    if (result.count > 0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'",tableName,[setValueArray componentsJoinedByString:@","],primaryKey,primaryValue];
    }else {
        // insert into 表名(字段1, 字段2, 字段3) values ('值1', '值2', '值3')
        // '   值1', '值2', '值3   '
        // 插入
        // text sz 'sz' 2 '2'
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')",tableName,[columnNames componentsJoinedByString:@","],[values componentsJoinedByString:@"','"]];
    }
    return [TTSqliteTool deal:execSql uid:uid];
}

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid
{
    Class cls = [model class];
    NSString *tableName = [TTModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;

    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,primaryKey,primaryValue];
    
    return [TTSqliteTool deal:deleteSql uid:uid];
   
}

+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereStr.length > 0) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@", whereStr];
    }
    return [TTSqliteTool deal:deleteSql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)releation value:(id)value uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ %@", tableName,name,[self ColumnNameToValueRelationTypeDic][@(releation)],value];
 
    return [TTSqliteTool deal:deleteSql uid:uid];
}


+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    // 1 sql
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    
    // 2 执行查询
    
    NSArray<NSDictionary *> *resultes = [TTSqliteTool querySql:sql uid:uid];
    
    // 3 处理查询的结果集 - 》 数组模型
    return [self parseResults:resultes withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls colunmName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid
{
    NSString *tableName = [TTModelTool tableName:cls];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ %@",tableName,name,[self ColumnNameToValueRelationTypeDic][@(relation)],value];
    
    NSArray<NSDictionary *> *resultes = [TTSqliteTool querySql:sql uid:uid];
    
    // 3 处理查询的结果集 - 》 数组模型
    return [self parseResults:resultes withClass:cls];
    
}

+ (NSArray *)queryModels:(Class)cls withSql:(NSString *)sql uid:(NSString *)uid
{
    
    NSArray<NSDictionary *> *resultes = [TTSqliteTool querySql:sql uid:uid];
    
    // 3 处理查询的结果集 - 》 数组模型
    return [self parseResults:resultes withClass:cls];
    
}

+ (NSArray *)parseResults:(NSArray<NSDictionary *> *)results withClass:(Class)cls{
    
    NSMutableArray *models = [NSMutableArray array];
    
    NSDictionary *nameTypeDic = [TTModelTool classIvarNameTypeDic:cls];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            NSString *type = nameTypeDic[key];
            
            id resultValue = obj;
            
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [ NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            }else if([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
            
        }];
        
    }
    return models;
    
}


#pragma mark - 关系映射
+ (NSDictionary *)ColumnNameToValueRelationTypeDic{
    return @{
             @(ColumnNameToValueRelationTypeMore):@">",
             @(ColumnNameToValueRelationTypeLess):@"<",
             @(ColumnNameToValueRelationTypeEqual):@"=",
             @(ColumnNameToValueRelationTypeMoreEqual):@">=",
             @(ColumnNameToValueRelationTypeLessEqual):@"<="
             };
}
@end
