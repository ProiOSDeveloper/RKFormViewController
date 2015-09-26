//
//  RKToolBar.m
//  RKUtilities
//
//  Created by Rajkumar Sharma on 26/09/15.
//  Copyright (c) 2015 RajkumarSharma. All rights reserved.
//

#import "RKToolBar.h"


@interface RKToolBar()

@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;

@end


@implementation RKToolBar

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<RKToolBarDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    _rkToolBarDelegate = delegate;
    [self addButtons];
    return self;
}

- (instancetype)initWithDelegate:(id<RKToolBarDelegate>)delegate {
    
    self = [super init];
    _rkToolBarDelegate = delegate;
    [self addButtons];
    return self;
}

- (void)addButtons {
    
    _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                   style:UIBarButtonItemStylePlain target:self
                                                  action:@selector(doneTapped:)];
    
    _flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil
                                                                    action:nil];
    _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                   style:UIBarButtonItemStylePlain target:self
                                                  action:@selector(nextTapped:)];
    
    _previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                       style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(previousTapped:)];
    [self disableNextButton];
    [self disablePreviousButton];
    [self setItems:[NSArray arrayWithObjects:_doneButton, _flexibleSpace, _previousButton, _nextButton, nil]];
}

- (void)doneTapped:(id)sender {
    if ([_rkToolBarDelegate respondsToSelector:@selector(doneTapped:)]) {
        [_rkToolBarDelegate doneTapped:sender];
    }
}

- (void)nextTapped:(id)sender {
    if ([_rkToolBarDelegate respondsToSelector:@selector(nextTapped:)]) {
        [_rkToolBarDelegate nextTapped:sender];
    }
}

- (void)previousTapped:(id)sender {
    if ([_rkToolBarDelegate respondsToSelector:@selector(previousTapped:)]) {
        [_rkToolBarDelegate previousTapped:sender];
    }
}

- (void)enablePreviousButton {
    _previousButton.enabled = true;
}

- (void)disablePreviousButton {
    _previousButton.enabled = false;
}

- (void)enableNextButton {
    _nextButton.enabled = true;
}

- (void)disableNextButton {
    _nextButton.enabled = false;
}


@end
