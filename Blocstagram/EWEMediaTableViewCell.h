//
//  EWEMediaTableViewCell.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/17/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EWEMedia, EWEMediaTableViewCell, EWEComposeCommentView;
@protocol EWEMediaTableViewCellDelegate <NSObject>

- (void) cell:(EWEMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void) cell:(EWEMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;
- (void) cell:(EWEMediaTableViewCell *)cell didDoubleTapImageView:(UIImageView *)imageView;
- (void) cellDidPressLikeButton:(EWEMediaTableViewCell *)cell;
- (void) cellWillStartComposingComment:(EWEMediaTableViewCell *)cell;
- (void) cell:(EWEMediaTableViewCell *)cell didComposeComment:(NSString *)comment;


@end
@interface EWEMediaTableViewCell : UITableViewCell
@property(nonatomic,strong) EWEMedia *mediaItem;
@property (nonatomic, weak) id <EWEMediaTableViewCellDelegate> delegate;
@property (nonatomic, strong, readonly) EWEComposeCommentView *commentView;


+ (CGFloat) heightForMediaItem:(EWEMedia *)mediaItem width:(CGFloat)width;

- (void) stopComposingComment;

@end
