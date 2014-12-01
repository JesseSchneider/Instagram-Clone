//
//  EWEComposeCommentViewTest.m
//  Blocstagram
//
//  Created by Jesse Schneider on 9/1/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWEComposeCommentView.h"

@interface EWEComposeCommentViewTest : XCTestCase

@end

@implementation EWEComposeCommentViewTest

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

- (void)testThatCommnetWorks
{
    
    EWEComposeCommentView *composeComment = [[EWEComposeCommentView alloc]init];
    composeComment.text = @"something is writing here";
    XCTAssertTrue(composeComment.isWritingComment == YES, @"The is an error in comment section");
}

-(void)testThatComment
{    EWEComposeCommentView *composeComment = [[EWEComposeCommentView alloc]init];
     composeComment.text = nil;
     XCTAssertTrue(composeComment.isWritingComment == NO, @"The is an error in comment section");
}
@end
