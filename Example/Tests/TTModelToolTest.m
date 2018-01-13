//
//  TTModelToolTest.m
//  TTSqlite_Tests
//
//  Created by 任梦晗 on 2018/1/9.
//  Copyright © 2018年 renmenghan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTModelTool.h"
#import "TTStu.h"
@interface TTModelToolTest : XCTestCase

@end

@implementation TTModelToolTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
  
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void)testIvarNameType{
   NSString *dic = [TTModelTool columnNamesAndTypesStr:[TTStu class]];
    NSLog(@"%@",dic);
}

@end
