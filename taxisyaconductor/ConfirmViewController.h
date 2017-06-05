//
//  ConfirmViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 6/7/16.
//  Copyright © 2016 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ConfirmViewController : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) NSString *email;


@end
