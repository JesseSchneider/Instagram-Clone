//
//  EWECommentTests.m
//  Blocstagram
//
//  Created by Jesse Schneider on 8/31/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWEComment.h"

@interface EWECommentTests : XCTestCase

@end

@implementation EWECommentTests

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

- (void)testThatInitializationWorks
{
    NSDictionary *sourceDictionary = @{@"id": @"8675309",
                                       @"text" : @"Sample Comment"};
    
    EWEComment *testComment = [[EWEComment alloc] initWithDictionary:sourceDictionary];
    
    XCTAssertEqualObjects(testComment.idNumber, sourceDictionary[@"id"], @"The ID number should be equal");
    XCTAssertEqualObjects(testComment.text, sourceDictionary[@"text"], @"The text should be equal");
}

@end
