//
//  TTSqliteModelTool.m
//  TTSqlite_Tests
//
//  Created by 任梦晗 on 2018/1/10.
//  Copyright © 2018年 renmenghan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTSqliteModelTool.h"
#import "TTStu.h"
@interface TTSqliteModelToolTest : XCTestCase

@end

@implementation TTSqliteModelToolTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    TTStu *stu = [[TTStu alloc] init];
    stu.stuNum = 100;
    stu.age1 = 12;
    stu.name = @"ppp";
    stu.score = 999;
    stu.xx = @[@"2",@"3"] ;
    stu.oo = @{
               @"a":@"aa",
               @"b":@"bb"
               };
   BOOL result =  [TTSqliteModelTool saveOrUpdateModel:stu uid:nil];
    XCTAssertTrue(result);
}
- (void)testDelete{
    TTStu *stu = [[TTStu alloc] init];
    stu.stuNum = 100;
    stu.age1 = 12;
    stu.name = @"ppp";
    stu.score = 999;
    
    BOOL result =  [TTSqliteModelTool deleteModel:stu uid:nil];
    XCTAssertTrue(result);
}
- (void)testDeleteWhereStr{
    [TTSqliteModelTool deleteModel:[TTStu class] whereStr:@"score <= 10" uid:nil];
}
- (void)testDeleteWhereStr1{
    [TTSqliteModelTool deleteModel:[TTStu class] columnName:@"score" relation:ColumnNameToValueRelationTypeEqual value:@(15) uid:nil];
}
- (void)testQueryModels{
    NSArray *arr = [TTSqliteModelTool queryAllModels:[TTStu class] uid:nil];
    NSLog(@"%@",arr);
}
- (void)testQueryModels1{
    NSArray *arr = [TTSqliteModelTool queryModels:[TTStu class] colunmName:@"score" relation:ColumnNameToValueRelationTypeLessEqual value:@(39) uid:nil];
    NSLog(@"%@",arr);
}
@end
