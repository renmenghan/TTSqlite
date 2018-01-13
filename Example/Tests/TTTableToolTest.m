//
//  TTTableToolTest.m
//  TTSqlite_Tests
//
//  Created by 任梦晗 on 2018/1/10.
//  Copyright © 2018年 renmenghan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTTableTool.h"
@interface TTTableToolTest : XCTestCase

@end

@implementation TTTableToolTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    


    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    Class cls = NSClassFromString(@"TTStu");
    [TTTableTool tableSortedColumnNames:cls uid:nil];
}


@end
