//
//  RKFormViewController.m
//  RKUtilities
//
//  Created by Rajkumar Sharma on 26/09/15.
//  Copyright (c) 2015 RajkumarSharma. All rights reserved.
//

#import "RKFormViewController.h"
#import "RKToolBar.h"

#define RKControlKey @"control"
#define RKControlInputTypeKey @"inputType"

@interface RKFormViewController () <UITextFieldDelegate, UITextViewDelegate, RKToolBarDelegate>

@property (nonatomic, strong) RKToolBar *keyboadToolBar;
@property (nonatomic, assign) int currentControlIndex;
@property (nonatomic, strong) NSMutableArray *arrayOfControls;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation RKFormViewController

- (void)viewDidLoad {

    _arrayOfControls = [[NSMutableArray alloc]init];
    [self initializeToolbar];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addControl:(id)control
         inputType:(RKControlInputType)inputType{

    if (!inputType) {
        inputType = RKControlInputTypePlainText;
    }
    [_arrayOfControls addObject:@{RKControlKey:control,
                                  RKControlInputTypeKey:[NSNumber numberWithInt:inputType]}];
    if (_arrayOfControls.count > 1) {
        [_keyboadToolBar enablePreviousButton];
        [_keyboadToolBar enableNextButton];
    }
}

#pragma mark - Toolbar Related Methods
- (void)initializeToolbar {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    _keyboadToolBar = [[RKToolBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)
                                              delegate:self];
}

- (UIDatePicker *)datePickerModeForInputType:(RKControlInputType)inputType {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    }
    switch (inputType) {
        case RKControlInputTypeDate:
            _datePicker.datePickerMode = UIDatePickerModeDate;
            break;
        case RKControlInputTypeDateTime:
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case RKControlInputTypeTime:
            _datePicker.datePickerMode = UIDatePickerModeTime;
            break;
        case RKControlInputTypeCountDown:
            _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
        default:
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
    }
    return _datePicker;
}

- (void)setToolBarBackgroundColor:(UIColor *)color {
    [_keyboadToolBar setBarTintColor:color];
}

- (void)setToolBarButtonColor:(UIColor *)color {
    [_keyboadToolBar setTintColor:color];
}


#pragma mark - UITextField Related Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (_arrayOfControls.count > 0) {
        
        textField.inputAccessoryView = _keyboadToolBar;
        [self controlWillBecomeFirstResponder:textField];
        
        RKControlInputType _inputType = (RKControlInputType) [_arrayOfControls[_currentControlIndex][RKControlInputTypeKey] intValue];
        if (_inputType != RKControlInputTypePlainText) {
            textField.inputView = [self datePickerModeForInputType:_inputType];
        }
    }
    return true;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UITextView Related Methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    if (_arrayOfControls.count > 0) {
        [self controlWillBecomeFirstResponder:textView];
        textView.inputAccessoryView = _keyboadToolBar;
    }
    return true;
}



#pragma mark - Toolbar Delegate Methods
- (void)doneTapped:(id)sender {
    
    if (_arrayOfControls.count > 0) {
        id _currentControl = _arrayOfControls[_currentControlIndex][RKControlKey];
        if ([_currentControl isKindOfClass:[UITextField class]]) {
            [(UITextField *)_currentControl resignFirstResponder];
        } else if ([_currentControl isKindOfClass:[UITextView class]]) {
            [(UITextView *)_currentControl resignFirstResponder];
        }
    } else {
        [self setEditing:false];
    }
}

- (void)nextTapped:(id)sender {
    _currentControlIndex++;
    [self makeCurrentControlFirstResponder];
    [self setNextPreviousButtonState];
}


- (void)previousTapped:(id)sender {
    _currentControlIndex--;
    [self makeCurrentControlFirstResponder];
    [self setNextPreviousButtonState];
}



#pragma mark - CurrentControlIndex Update

- (void)makeCurrentControlFirstResponder {
    id _currentControl = _arrayOfControls[_currentControlIndex][RKControlKey];
    if ([_currentControl isKindOfClass:[UITextField class]]) {
        [(UITextField *)_currentControl becomeFirstResponder];
    } else if ([_currentControl isKindOfClass:[UITextView class]]) {
        [(UITextView *)_currentControl becomeFirstResponder];
    }
}

- (void)controlWillBecomeFirstResponder:(id)control {

    id _currentControl = _arrayOfControls[_currentControlIndex][RKControlKey];
    if (_currentControl == control) {
        return;
    } else {
        [self setCurrentControlIndexToCurrentSelectedControl:control];
    }
}

- (void)setCurrentControlIndexToCurrentSelectedControl:(id)control {
    for (int i= 0; i<_arrayOfControls.count; i++) {
        id _currentControl = _arrayOfControls[i][RKControlKey];
        if (control == _currentControl) {
            _currentControlIndex = i;
            [self setNextPreviousButtonState];
        }
    }
}

- (void)setNextPreviousButtonState {
    [_keyboadToolBar enableNextButton];
    [_keyboadToolBar enablePreviousButton];
    if (_currentControlIndex == (_arrayOfControls.count-1)) {
        [_keyboadToolBar disableNextButton];
    }
    if (_currentControlIndex == 0) {
        [_keyboadToolBar disablePreviousButton];
    }
}

@end
