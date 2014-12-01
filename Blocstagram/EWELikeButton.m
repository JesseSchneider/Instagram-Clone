//
//  EWELikeButton.m
//  Blocstagram
//
//  Created by Jesse Schneider on 8/25/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWELikeButton.h"
#import "EWECircleSpinnerView.h"

#define kLikedStateImage @"heart-full"
#define kUnlikedStateImage @"heart-empty"

@interface EWELikeButton ()

@property (nonatomic, strong) EWECircleSpinnerView *spinnerView;

@end

@implementation EWELikeButton

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.spinnerView = [[EWECircleSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:self.spinnerView];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        self.likeButtonState = EWELikeStateNotLiked;
    }
    
    return self;

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.spinnerView.frame = self.imageView.frame;
}

- (void) setLikeButtonState:(EWELikeState)likeState {
    _likeButtonState = likeState;
    
    NSString *imageName;
    
    switch (_likeButtonState) {
        case EWELikeStateLiked:
        case EWELikeStateUnliking:
            imageName = kLikedStateImage;
            break;
            
        case EWELikeStateNotLiked:
        case EWELikeStateLiking:
            imageName = kUnlikedStateImage;
    }
    
    switch (_likeButtonState) {
        case EWELikeStateLiking:
        case EWELikeStateUnliking:
            self.spinnerView.hidden = NO;
            self.userInteractionEnabled = NO;
            break;
            
        case EWELikeStateLiked:
        case EWELikeStateNotLiked:
            self.spinnerView.hidden = YES;
            self.userInteractionEnabled = YES;
    }
    
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
