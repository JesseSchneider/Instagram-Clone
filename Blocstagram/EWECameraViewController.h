//
//  EWECameraViewController.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/26/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EWECameraViewController;

@protocol EWECameraViewControllerDelegate <NSObject>

- (void) cameraViewController:(EWECameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image;

@end

@interface EWECameraViewController : UIViewController

@property (nonatomic, weak) NSObject <EWECameraViewControllerDelegate> *delegate;

@end
