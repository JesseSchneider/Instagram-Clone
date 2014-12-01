//
//  EWEComment.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EWEUser;
@interface EWEComment : NSObject <NSCoding>

@property (nonatomic, strong) NSString *idNumber;

@property (nonatomic, strong) EWEUser *from;
@property (nonatomic, strong) NSString *text;
- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary;

@end
