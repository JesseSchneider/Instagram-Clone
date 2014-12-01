//
//  EWEComposeCommentView.h
//  Blocstagram
//
//  Created by Jesse Schneider on 8/25/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  EWEComposeCommentView;

@protocol EWEComposeCommentViewDelegate <NSObject>

- (void) commentViewDidPressCommentButton:(EWEComposeCommentView *)sender;
- (void) commentView:(EWEComposeCommentView *)sender textDidChange:(NSString *)text;
- (void) commentViewWillStartEditing:(EWEComposeCommentView *)sender;

@end
@interface EWEComposeCommentView : UIView

@property (nonatomic, weak) NSObject <EWEComposeCommentViewDelegate> *delegate;

@property (nonatomic, assign) BOOL isWritingComment;

@property (nonatomic, strong) NSString *text;

- (void) stopComposingComment;

@end
