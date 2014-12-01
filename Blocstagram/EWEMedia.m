//
//  EWEMedia.m
//  Blocstagram
//
//  Created by Jesse Schneider on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWEMedia.h"
#import "EWEUser.h"
#import "EWEComment.h"

@implementation EWEMedia

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = mediaDictionary[@"id"];
        self.user = [[EWEUser alloc] initWithDictionary:mediaDictionary[@"user"]];
        NSString *standardResolutionImageURLString = mediaDictionary[@"images"][@"standard_resolution"][@"url"];
        NSURL *standardResolutionImageURL = [NSURL URLWithString:standardResolutionImageURLString];
        
        if (standardResolutionImageURL) {
            self.mediaURL = standardResolutionImageURL;
            self.downloadState = EWEMediaDownloadStateNeedsImage;
        } else {
            self.downloadState = EWEMediaDownloadStateNonRecoverableError;
        }

        
        NSDictionary *captionDictionary = mediaDictionary[@"caption"];
        
        // Caption might be null (if there's no caption)
        if ([captionDictionary isKindOfClass:[NSDictionary class]]) {
            self.caption = captionDictionary[@"text"];
        } else {
            self.caption = @"";
        }
        
        NSMutableArray *commentsArray = [NSMutableArray array];
        
        for (NSDictionary *commentDictionary in mediaDictionary[@"comments"][@"data"]) {
            EWEComment *comment = [[EWEComment alloc] initWithDictionary:commentDictionary];
            [commentsArray addObject:comment];
        }
        
        NSDictionary *likeDictionary = mediaDictionary[@"likes"];
        if ([likeDictionary isKindOfClass:[NSDictionary class]]) {
            self.likes = likeDictionary[@"count"];
        } else{
        self.likes = @"";
        }
        
        self.comments = commentsArray;
        
        BOOL userHasLiked = [mediaDictionary[@"user_has_liked"] boolValue];
        
        self.likeState = userHasLiked ? EWELikeStateLiked : EWELikeStateNotLiked;
    }
    
    return self;
}

#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.user = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(user))];
        self.mediaURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mediaURL))];
        self.image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        if (self.image) {
            self.downloadState = EWEMediaDownloadStateHasImage;
        } else if (self.mediaURL) {
            self.downloadState = EWEMediaDownloadStateNeedsImage;
        } else {
            self.downloadState = EWEMediaDownloadStateNonRecoverableError;
        }
        self.caption = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(caption))];
        self.comments = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(comments))];
        self.likeState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(likeState))];
        
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.user forKey:NSStringFromSelector(@selector(user))];
    [aCoder encodeObject:self.mediaURL forKey:NSStringFromSelector(@selector(mediaURL))];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.caption forKey:NSStringFromSelector(@selector(caption))];
    [aCoder encodeObject:self.comments forKey:NSStringFromSelector(@selector(comments))];
    [aCoder encodeInteger:self.likeState forKey:NSStringFromSelector(@selector(likeState))];
}

@end
