//
//  RKFormViewController.h
//  RKUtilities
//
//  Created by Rajkumar Sharma on 26/09/15.
//  Copyright (c) 2015 RajkumarSharma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    RKControlInputTypePlainText = 1,
    RKControlInputTypeDate,
    RKControlInputTypeTime,
    RKControlInputTypeDateTime,
    RKControlInputTypeCountDown,
    RKControlInputTypeCustom
    
} RKControlInputType;

@interface RKFormViewController : UIViewController

- (void)setToolBarBackgroundColor:(UIColor *)color;
- (void)setToolBarButtonColor:(UIColor *)color;
- (void)addControl:(id)control inputType:(RKControlInputType)inputType;

@end
