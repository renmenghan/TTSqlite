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
    stu.age = 12;
    stu.name = @"ppp";
    stu.score = 999;
    
    [TTSqliteModelTool saveOrUpdateModel:stu uid:nil];
}

@end
