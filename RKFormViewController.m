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
#define TOP_MARGIN_PADDING 50

@interface RKFormViewController () <UITextFieldDelegate, UITextViewDelegate, RKToolBarDelegate>

@property (nonatomic, strong) RKToolBar *keyboadToolBar;
@property (nonatomic, assign) int currentControlIndex;
@property (nonatomic, strong) NSMutableArray *arrayOfControls;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) float keyboardHeight;
@property (nonatomic, assign) float keyboardAnimationDuration;
@property (nonatomic, assign) UIViewAnimationCurve keyboardAnimationCurve;
@property (nonatomic, assign) float bottomOffsetToKeyboard;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScroll;

@end

@implementation RKFormViewController

- (void)viewDidLoad {

    _arrayOfControls = [[NSMutableArray alloc]init];
    [_contentScroll setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self initializeToolbar];
    [self registerForKeyboardNotifications];
    _bottomOffsetToKeyboard = 100;
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


#pragma mark - View Adjustment
- (void)adjustViewFrameForControl:(id)control {

    CGRect contentRect = _contentScroll.frame;
    contentRect.size.height = self.view.frame.size.height - _keyboardHeight;
    _contentScroll.frame = contentRect;
    
    float adjustmentHeight = [self getHeightAdjustmentValueForControl:(UIView *)control];
    if (adjustmentHeight == _contentScroll.contentOffset.y) {
        return;
    }
    [_contentScroll setContentOffset:CGPointMake(_contentScroll.contentOffset.x, adjustmentHeight)
                            animated:NO];
    
}

- (void)setViewFrameToDefault {
    
    [_contentScroll setContentOffset:CGPointMake(0,0)
                            animated:NO];
    
    CGRect contentRect = _contentScroll.frame;
    contentRect.size.height = self.view.frame.size.height;
    _contentScroll.frame = contentRect;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    _keyboardHeight = keyboardFrame.size.height;
    _keyboardAnimationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _keyboardAnimationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    id _currentControl = _arrayOfControls[_currentControlIndex][RKControlKey];
    [self adjustViewFrameForControl:_currentControl];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setViewFrameToDefault];
}

- (float)getHeightAdjustmentValueForControl:(UIView *)control {

    float keyboardLimit = self.view.frame.size.height - _keyboardHeight;
    float controlBottomEdge = control.frame.origin.y + control.frame.size.height;
    float allowedLimit = keyboardLimit - _bottomOffsetToKeyboard;
    if (controlBottomEdge >= allowedLimit) {
        return MAX((controlBottomEdge - allowedLimit),30);
    } else {
        return 0;
    }
}

@end
