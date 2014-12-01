//
//  EWEImagesTableViewController.m
//  Blocstagram
//
//  Created by Jesse Schneider on 8/15/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "EWEImagesTableViewController.h"
#import "EWEUser.h"
#import "EWEMedia.h"
#import "EWEComment.h"
#import "EWEDatasource.h"
#import "EWEMediaTableViewCell.h"
#import "EWEMediaFullScreenViewController.h"
#import "EWEMediaFullScreenAnimator.h"
#import "EWECameraViewController.h"
#import "EWEImageLibraryViewController.h"
#import "EWEPostToInstagramViewController.h"


@interface EWEImagesTableViewController () <EWEMediaTableViewCellDelegate, UIViewControllerTransitioningDelegate, EWEMediaFullScreenDelegate, EWECameraViewControllerDelegate,EWEImageLibraryViewControllerDelegate>
@property (nonatomic, weak) UIImageView *lastTappedImageView;
@property (nonatomic, weak) UIView *lastSelectedCommentView;
@property (nonatomic, assign) CGFloat lastKeyboardAdjustment;

@property (nonatomic, strong) UIPopoverController *cameraPopover;
@property (nonatomic, strong) UIPopoverController *sharePopover;



@end

@implementation EWEImagesTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[EWEDatasource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
  
    
    [self.tableView registerClass:[EWEMediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
   
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed:)];
        self.navigationItem.rightBarButtonItem = cameraButton;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageDidFinish:)
                                                 name:EWEImageFinishedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cell:didLongPressImageView:)
                                                 name:EWEImageFinishedNotification
                                               object:nil];
}

- (void) dealloc {
   [[EWEDatasource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *) item {
    return [[EWEDatasource sharedInstance] mediaItems];
}

- (void) refreshControlDidFire:(UIRefreshControl *) sender{
    [[EWEDatasource sharedInstance]requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [EWEDatasource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        // We know mediaItems changed.  Let's see what kind of change it is.
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        }
     else if (kindOfChange == NSKeyValueChangeInsertion ||
                 kindOfChange == NSKeyValueChangeRemoval ||
                 kindOfChange == NSKeyValueChangeReplacement) {
        // We have an incremental change: inserted, deleted, or replaced images
        
        // Get a list of the index (or indices) that changed
        NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
        
        // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
        NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
        [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPathsThatChanged addObject:newIndexPath];
        }];
        
        // Call `beginUpdates` to tell the table view we're about to make changes
        [self.tableView beginUpdates];
        
        // Tell the table view what the changes are
        if (kindOfChange == NSKeyValueChangeInsertion) {
            [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (kindOfChange == NSKeyValueChangeRemoval) {
            [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (kindOfChange == NSKeyValueChangeReplacement) {
            [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        // Tell the table view that we're done telling it about changes, and to complete the animation
        [self.tableView endUpdates];
        }

    }
}
- (void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == [EWEDatasource sharedInstance].mediaItems.count - 1) {
        // The very last cell is on screen
        [[EWEDatasource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}

- (void) cellDidPressLikeButton:(EWEMediaTableViewCell *)cell {
    [[EWEDatasource sharedInstance] toggleLikeOnMediaItem:cell.mediaItem];
  
}
- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}



 #pragma mark - Camera, EWECameraViewControllerDelegate, and EWEImageLibraryViewControllerDelegate

- (void) cameraPressed:(UIBarButtonItem *) sender {
    
    UIViewController *imageVC;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        EWECameraViewController *cameraVC = [[EWECameraViewController alloc] init];
        cameraVC.delegate = self;
        imageVC = cameraVC;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        EWEImageLibraryViewController *imageLibraryVC = [[EWEImageLibraryViewController alloc] init];
        imageLibraryVC.delegate = self;
        imageVC = imageLibraryVC;
    }
    
    if (imageVC) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
        
        if (isPhone) {
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            self.cameraPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
            self.cameraPopover.popoverContentSize = CGSizeMake(320, 568);
            [self.cameraPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    return;
}
- (void) imageLibraryViewController:(EWEImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image {
    [self handleImage:image withNavigationController:imageLibraryViewController.navigationController];
}
- (void) cameraViewController:(EWECameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image {
    
     [self handleImage:image withNavigationController:cameraViewController.navigationController];
}


- (void) handleImage:(UIImage *)image withNavigationController:(UINavigationController *)nav {
         if (image) {
             EWEPostToInstagramViewController *postVC = [[EWEPostToInstagramViewController alloc] initWithImage:image];
             
             [nav pushViewController:postVC animated:YES];
         } else {
             if (isPhone) {
                 [nav dismissViewControllerAnimated:YES completion:nil];
             } else {
                 [self.cameraPopover dismissPopoverAnimated:YES];
                 self.cameraPopover = nil;
             }
         }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
}

//-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self infiniteScrollIfNecessary];
//}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self item].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    // Configure the cell...
    EWEMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.mediaItem = self.item[indexPath.row];
    return cell;
    

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMedia *item = self.item[indexPath.row];
    return [EWEMediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMedia *item = [EWEDatasource sharedInstance].mediaItems[indexPath.row];
    if (item.image) {
        return 450;
    } else {
        return 250;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMediaTableViewCell *cell = (EWEMediaTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell stopComposingComment];
}

- (void) cellWillStartComposingComment:(EWEMediaTableViewCell *)cell {
    self.lastSelectedCommentView = (UIView *)cell.commentView;
}

- (void) cell:(EWEMediaTableViewCell *)cell didComposeComment:(NSString *)comment {
    [[EWEDatasource sharedInstance] commentOnMediaItem:cell.mediaItem withCommentText:comment];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
    
        
        EWEMedia *item = [EWEDatasource sharedInstance].mediaItems[indexPath.row];
        [[EWEDatasource sharedInstance] deleteMediaItem:item];
    }
        
    
    
}

- (void) cell:(EWEMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView {
    [self shareMediaItem:cell.mediaItem fromController:self andVeiwTarget:imageView];
}

#pragma mark - EWEMediaTableViewCellDelegate

- (void) cell:(EWEMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView {
    self.lastTappedImageView = imageView;
    EWEMediaFullScreenViewController *fullScreenVC = [[EWEMediaFullScreenViewController alloc] initWithMedia:cell.mediaItem andDelegate:self];
    if (isPhone) {
        fullScreenVC.transitioningDelegate = self;
        fullScreenVC.modalPresentationStyle = UIModalPresentationCustom;
    } else {
        fullScreenVC.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:fullScreenVC animated:YES completion:nil];
}


- (void) cell:(EWEMediaTableViewCell *)cell didDoubleTapImageView:(UIImageView *)imageView {
    [[EWEDatasource sharedInstance]downloadImageForMediaItem:cell.mediaItem];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    EWEMediaFullScreenAnimator *animator = [EWEMediaFullScreenAnimator new];
    animator.presenting = YES;
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    EWEMediaFullScreenAnimator *animator = [EWEMediaFullScreenAnimator new];
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EWEMedia *mediaItem = [EWEDatasource sharedInstance].mediaItems[indexPath.row];
    if (mediaItem.downloadState == EWEMediaDownloadStateNeedsImage) {
        [[EWEDatasource sharedInstance] downloadImageForMediaItem:mediaItem];
    }
}

#pragma mark - Keyboard Handling



- (void)keyboardWillShow:(NSNotification *)notification {
    // Get the frame of the keyboard within self.view's coordinate system
    NSValue *frameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameInScreenCoordinates = frameValue.CGRectValue;
    CGRect keyboardFrameInViewCoordinates = [self.navigationController.view convertRect:keyboardFrameInScreenCoordinates fromView:nil];
    
    // Get the frame of the comment view in the same coordinate system
    CGRect commentViewFrameInViewCoordinates = [self.navigationController.view convertRect:self.lastSelectedCommentView.bounds fromView:self.lastSelectedCommentView];
    
    CGPoint contentOffset = self.tableView.contentOffset;
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
    CGFloat heightToScroll = 0;
    
    CGFloat keyboardY = CGRectGetMinY(keyboardFrameInViewCoordinates);
    CGFloat commentViewY = CGRectGetMinY(commentViewFrameInViewCoordinates);
    
    CGFloat commentViewHeight = CGRectGetHeight(commentViewFrameInViewCoordinates);
    CGFloat commentViewFinalY = keyboardY - commentViewHeight;
   
    if (commentViewY != commentViewFinalY) {
        NSLog(@"Y difference %f", commentViewY - commentViewFinalY);
        heightToScroll += commentViewY - commentViewFinalY;
    }
    
    NSLog(@"Keyboard Frame %@", NSStringFromCGRect(keyboardFrameInViewCoordinates));
    NSLog(@"Comment Frame %@", NSStringFromCGRect(commentViewFrameInViewCoordinates));


    if (heightToScroll != 0) {
        NSLog(@"Height To Scroll: %f", heightToScroll);
        if (heightToScroll < 0) {
            contentInsets.top -= heightToScroll;
            scrollIndicatorInsets.top -= heightToScroll;
        } else{
            contentInsets.bottom += heightToScroll;
            scrollIndicatorInsets.bottom += heightToScroll;
        }
        contentOffset.y += heightToScroll;

        NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
        
        NSTimeInterval duration = durationNumber.doubleValue;
        UIViewAnimationCurve curve = curveNumber.unsignedIntegerValue;
        UIViewAnimationOptions options = curve << 16;
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.tableView.contentInset = contentInsets;
            self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
            self.tableView.contentOffset = contentOffset;
        } completion:nil];
    }

   self.lastKeyboardAdjustment = heightToScroll;
	
}



- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    
    UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
    
    if (self.lastKeyboardAdjustment < 0) {
        contentInsets.top += self.lastKeyboardAdjustment;
        scrollIndicatorInsets.top += self.lastKeyboardAdjustment;
    } else {
        contentInsets.bottom -= self.lastKeyboardAdjustment;
        scrollIndicatorInsets.bottom -= self.lastKeyboardAdjustment;
    }
    
    self.lastKeyboardAdjustment = 0;
    
    NSNumber *durationNumber = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    
    NSTimeInterval duration = durationNumber.doubleValue;
    UIViewAnimationCurve curve = curveNumber.unsignedIntegerValue;
    UIViewAnimationOptions options = curve << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
    } completion:nil];

}

# pragma mark EWEFullScreenDelegate

- (void)shareMediaItem:(EWEMedia *)item fromController:(UIViewController *)controller {
    [self shareMediaItem:item fromController:controller andVeiwTarget:self.view];
}

-(void) shareMediaItem:(EWEMedia *)item fromController:(UIViewController *)controller andVeiwTarget: (UIView *)target{
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (item.caption.length > 0) {
        [itemsToShare addObject:item.caption];
    }
    
    if (item.image) {
        [itemsToShare addObject:item.image];
    }
    
    if (isPhone) {
        
        
        if (itemsToShare.count > 0) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
            [controller presentViewController:activityVC animated:YES completion:nil];
        }
    }else {
        if (itemsToShare.count > 0) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
            self.sharePopover = [[UIPopoverController alloc]initWithContentViewController:activityVC];
            [self.sharePopover presentPopoverFromRect:target.frame inView:controller.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }

}

#pragma mark - Popover Handling

- (void) imageDidFinish:(NSNotification *)notification {
    if (isPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.cameraPopover dismissPopoverAnimated:YES];
        self.cameraPopover = nil;
    }
}
/*

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
