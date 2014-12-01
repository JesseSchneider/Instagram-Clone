//
//  EWELikeButton.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/25/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EWELikeState) {
    EWELikeStateNotLiked             = 0,
    EWELikeStateLiking               = 1,
    EWELikeStateLiked                = 2,
    EWELikeStateUnliking             = 3
};


@interface EWELikeButton : UIButton

/**
 The current state of the like button. Setting to BLCLikeButtonNotLiked or BLCLikeButtonLiked will display an empty heart or a heart, respectively. Setting to BLCLikeButtonLiking or BLCLikeButtonUnliking will display an activity indicator and disable button taps until the button is set to BLCLikeButtonNotLiked or BLCLikeButtonLiked.
 */
@property (nonatomic, assign) EWELikeState likeButtonState;

@end
