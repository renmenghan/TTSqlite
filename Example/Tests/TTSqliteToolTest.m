//
//  TTSqliteToolTest.m
//  TTSqlite_Tests
//
//  Created by 任梦晗 on 2018/1/9.
//  Copyright © 2018年 renmenghan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTSqliteTool.h"
#import "TTStu.h"
#import "TTSqliteModelTool.h"

@interface TTSqliteToolTest : XCTestCase

@end

@implementation TTSqliteToolTest

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    Class cls = NSClassFromString(@"TTStu");
    
//    BOOL result = [TTSqliteModelTool createTable:cls uid:nil];
//    BOOL result = [TTSqliteModelTool isTableRequiredUpdate:cls uid:nil];
//    BOOL result = [TTSqliteTool deal:sql uid:nil];
    BOOL result = [TTSqliteModelTool updateTable:cls uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery{
    
    // 追加两条记录
    NSString *insertSql1 = @"insert into TTStu(stuNum, name, age1, score) values (4, 'sz', 18, 0)";
    BOOL insertSqlR1 = [TTSqliteTool deal:insertSql1 uid:nil];
    XCTAssertTrue(insertSqlR1);
    
    NSString *insertSql2 = @"insert into TTStu(stuNum, name, age1, score) values (3, 'zs', 81, 1)";
    BOOL insertSqlR2 = [TTSqliteTool deal:insertSql2 uid:nil];
    XCTAssertTrue(insertSqlR2);
    NSString *sql = @"select * from TTStu";
    
    NSMutableArray *arr = [TTSqliteTool querySql:sql uid:nil];
    NSLog(@"%@",arr);
}
@end
