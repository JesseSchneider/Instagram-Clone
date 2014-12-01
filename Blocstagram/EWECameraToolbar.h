//
//  EWECameraToolbar.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/26/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWECameraToolbar;

@protocol EWECameraToolbarDelegate <NSObject>

- (void) leftButtonPressedOnToolbar:(EWECameraToolbar *)toolbar;
- (void) rightButtonPressedOnToolbar:(EWECameraToolbar *)toolbar;
- (void) cameraButtonPressedOnToolbar:(EWECameraToolbar *)toolbar;

@end

@interface EWECameraToolbar : UIView

- (instancetype) initWithImageNames:(NSArray *)imageNames;

@property (nonatomic, weak) NSObject <EWECameraToolbarDelegate> *delegate;
@end
