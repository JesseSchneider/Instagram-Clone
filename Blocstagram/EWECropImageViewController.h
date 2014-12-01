//
//  EWECropImageViewController.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/27/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EWEMediaFullScreenViewController.h"

@class EWECropImageViewController;

@protocol EWECropImageViewControllerDelegate <NSObject>

- (void) cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end

@interface EWECropImageViewController : EWEMediaFullScreenViewController
- (instancetype) initWithImage:(UIImage *)sourceImage;

@property (nonatomic, weak) NSObject <EWECropImageViewControllerDelegate> *cropDelegate;

@end
