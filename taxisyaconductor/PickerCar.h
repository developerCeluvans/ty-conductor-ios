//
//  PickerCar.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerCar : UIAlertView <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView *_pickerView;
    NSMutableArray *_options;
}

@property (readonly) NSString *enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message options:(NSMutableArray*)options delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
