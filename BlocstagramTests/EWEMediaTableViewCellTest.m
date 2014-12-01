//
//  EWEMediaTableViewCellTest.m
//  Blocstagram
//
//  Created by Jesse Schneider on 9/1/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWEMediaTableViewCell.h"
#import "EWEMedia.h"
#import "EWEComposeCommentView.h"


@interface EWEMediaTableViewCellTest : XCTestCase

@end

@implementation EWEMediaTableViewCellTest

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
    EWEComposeCommentView *height = [[EWEComposeCommentView alloc]init];
    EWEMedia *imageItems = [[EWEMedia alloc]init];
    CGFloat newImageSize =[EWEMediaTableViewCell heightForMediaItem:imageItems width:320];
    
    XCTAssertTrue(newImageSize == CGRectGetHeight(height.frame)  , @"the height is incorrect");
    
}

@end
