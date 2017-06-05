//
//  PickerCar.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "PickerCar.h"

@implementation PickerCar

#define VIEW_TAG 49
#define SUB_LABEL_TAG 52
#define LABEL_TAG 53

#define COMPONENT_WIDTH 250
#define LABEL_WIDTH 10

- (id)initWithTitle:(NSString *)title message:(NSString *)message options:(NSMutableArray*)options delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        _options = options;
        
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView sizeToFit];
        [_pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setShowsSelectionIndicator:TRUE];
        
        // Change from pre iOS 7
        [self setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[self textFieldAtIndex:0] setDelegate:self];
        [[self textFieldAtIndex:0] setInputView:_pickerView];
        [[self textFieldAtIndex:0] becomeFirstResponder];
    }
    return self;
}

#pragma mark -
#pragma mark Picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _pickerView) {
        return [_options count];
    }
    return [_options count];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset {
    
    // Create a new view that contains a label offset from the right.
    CGRect frame = CGRectMake(0.0, 0.0, width, 32.0);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = VIEW_TAG;
    
    frame.size.width = width - offset;
    UILabel *subLabel = [[UILabel alloc] initWithFrame:frame];
    subLabel.textAlignment = UITextAlignmentRight;
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.font = [UIFont systemFontOfSize:24.0];
    subLabel.userInteractionEnabled = NO;
    
    subLabel.tag = SUB_LABEL_TAG;
    
    [view addSubview:subLabel];
    return view;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *fullString = [[textField text] stringByAppendingString:string];
    
    for (NSString* object in _options) {
        if ([object isEqualToString:fullString]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UIView *returnView = nil;
    
    if ((view.tag == VIEW_TAG) || (view.tag == LABEL_TAG)) {
        returnView = view;
    }
    else {
        returnView = [self labelCellWithWidth:COMPONENT_WIDTH rightOffset:LABEL_WIDTH];
    }

    // The text shown in the component is just the number of the component.
    NSString *text = [_options objectAtIndex:row];

    // Where to set the text in depends on what sort of view it is.
    UILabel *theLabel = nil;
    if (returnView.tag == VIEW_TAG) {
        theLabel = (UILabel *)[returnView viewWithTag:SUB_LABEL_TAG];
    }
    else {
        theLabel = (UILabel *)returnView;
    }

    theLabel.text = text;
    return returnView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return COMPONENT_WIDTH;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [[self textFieldAtIndex:0] setText:[_options objectAtIndex:row]];
}

- (NSString *)enteredText
{
    return [[self textFieldAtIndex:0] text];
}

@end
