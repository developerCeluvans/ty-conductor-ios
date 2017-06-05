//
//  LoginViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomIOSAlertView.h"
#import "RegisterViewController.h"

@interface SendUnitsController : UIViewController
@end

@interface LoginViewController : BaseViewController <CustomIOSAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,RegisterViewControllerDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UITextField *loginTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *signInButton;
@property (strong, nonatomic) UIButton *signUpButton;
@property (strong, nonatomic) UIButton *recoverButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) NSMutableArray *plateForChoose;
@property (nonatomic) int plateIndex;
@property (nonatomic) BOOL isLogin;
@property (nonatomic) BOOL isFinished;


-initWithRegister:(BOOL) aRegister;

@end
