//
//  EWEMedia.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWELikeButton.h"
@class EWEUser;
typedef NS_ENUM(NSInteger, EWEMediaDownloadState) {
    EWEMediaDownloadStateNeedsImage             = 0,
    EWEMediaDownloadStateDownloadInProgress     = 1,
    EWEMediaDownloadStateNonRecoverableError    = 2,
    EWEMediaDownloadStateHasImage               = 3
};
@interface EWEMedia : NSObject <NSCoding>



@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) EWEUser *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *likes;
@property (nonatomic, assign) EWELikeState likeState;
@property (nonatomic, strong) NSString *temporaryComment;

@property (nonatomic, assign) EWEMediaDownloadState downloadState;

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
