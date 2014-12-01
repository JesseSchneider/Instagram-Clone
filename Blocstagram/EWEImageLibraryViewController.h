//
//  EWEImageLibraryViewController.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/27/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEImageLibraryViewController;

@protocol EWEImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(EWEImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image;

@end

@interface EWEImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <EWEImageLibraryViewControllerDelegate> *delegate;

@end
