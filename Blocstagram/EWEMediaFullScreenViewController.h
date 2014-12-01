//
//  EWEMediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/21/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEMedia;

@protocol EWEMediaFullScreenDelegate <NSObject>

@optional
- (void)shareMediaItem:(EWEMedia *)item fromController:(UIViewController *)controller;

@end

@interface EWEMediaFullScreenViewController : UIViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<EWEMediaFullScreenDelegate> delegate;
@property (nonatomic, strong) EWEMedia *media;


- (instancetype) initWithMedia:(EWEMedia *)media;
- (instancetype) initWithMedia:(EWEMedia *)media andDelegate:(id<EWEMediaFullScreenDelegate>) delegate;

- (void) centerScrollView;

- (void) recalculateZoomScale;
@end
