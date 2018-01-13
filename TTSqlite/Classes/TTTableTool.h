//
//  TTTableTool.h
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/10.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTableTool : NSObject

+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;


+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;

@end
