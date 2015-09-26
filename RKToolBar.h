//
//  RKToolBar.h
//  RKUtilities
//
//  Created by Rajkumar Sharma on 26/09/15.
//  Copyright (c) 2015 RajkumarSharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKToolBarDelegate <NSObject>

- (void)doneTapped:(id)sender;
- (void)previousTapped:(id)sender;
- (void)nextTapped:(id)sender;

@end

@interface RKToolBar : UIToolbar

@property (unsafe_unretained) id <RKToolBarDelegate> rkToolBarDelegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<RKToolBarDelegate>)delegate;
- (instancetype)initWithDelegate:(id<RKToolBarDelegate>)delegate;
- (void)enablePreviousButton;
- (void)disablePreviousButton;
- (void)enableNextButton;
- (void)disableNextButton;

@end
