//
//  EWEDatasource.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EWEMedia;

typedef void (^EWENewItemCompletionBlock)(NSError *error);

@interface EWEDatasource : NSObject

+(instancetype) sharedInstance;
extern NSString *const EWEImageFinishedNotification;

@property (nonatomic, strong, readonly) NSArray *mediaItems;

- (void) deleteMediaItem:(EWEMedia *)item;

+ (NSString *) instagramClientID;
@property (nonatomic, strong, readonly) NSString *accessToken;

- (void) toggleLikeOnMediaItem:(EWEMedia *)mediaItem;
- (void) commentOnMediaItem:(EWEMedia *)mediaItem withCommentText:(NSString *)commentText;
- (void) requestNewItemsWithCompletionHandler:(EWENewItemCompletionBlock)completionHandler;
-(void) requestOldItemsWithCompletionHandler:(EWENewItemCompletionBlock)completionHandler;

- (void) downloadImageForMediaItem:(EWEMedia *)mediaItem;

@end
