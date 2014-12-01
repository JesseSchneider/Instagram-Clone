//
//  EWEMediaTest.m
//  Blocstagram
//
//  Created by Jesse Schneider on 9/1/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWEMedia.h"

@interface EWEMediaTest : XCTestCase

@end

@implementation EWEMediaTest

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
                                       @"image" : @"http://www.example.com/example.jpg",
                                       @"likes" : @"10"};
    EWEMedia *testMedia = [[EWEMedia alloc] initWithDictionary:sourceDictionary];
    
    XCTAssertEqualObjects(testMedia.idNumber, sourceDictionary[@"id"], @"The ID number should be equal");
    XCTAssertEqualObjects(testMedia.image, sourceDictionary[@"image"], @"The image should be equal");
    XCTAssertEqualObjects(testMedia.likes, sourceDictionary[@"likes"], @"The likes should be equal");

}

@end
