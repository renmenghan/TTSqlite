//
//  TTSqliteTests.m
//  TTSqliteTests
//
//  Created by renmenghan on 01/09/2016.
//  Copyright (c) 2016 renmenghan. All rights reserved.
//

@import XCTest;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    NSArray *arr = @[@"2",@"3",@"5"];
    BOOL result = [arr containsObject:@"6"];
    
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
}

@end

