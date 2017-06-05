//
//  ConfirmViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 6/7/16.
//  Copyright © 2016 Imaginamos. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"
#import "LoginViewController.h"
#import "NSString+MD5.h"


@interface ConfirmViewController ()
{
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
}
@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
    // Cover the back button (cannot do this in viewWillAppear -- too soon)
    if ( backCover == nil ) {
        backCover = [[UIControl alloc] initWithFrame:CGRectMake( 0, 0, 80, 44)];
#if TARGET_IPHONE_SIMULATOR
        // show the cover for testing
        backCover.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.15];
#endif
        [backCover addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar addSubview:backCover];
    }

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [backCover removeFromSuperview];
    backCover = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"ConfirmViewController viewWillAppear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    // make title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 34)];
    NSString *stringTitle = [NSString stringWithFormat:@"%@",
                             NSLocalizedString(@"recover_password",nil)];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.titleLabel setText:stringTitle];
    [self.titleLabel setFont:[self.titleLabel.font fontWithSize:22]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];

    // input login
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 105, 280, 38)];
    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.codeTextField setPlaceholder:NSLocalizedString(@"confirm_code",nil)];
    self.codeTextField.delegate = self;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.codeTextField];


    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 155, 280, 38)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"password_input",nil)];
    self.passwordTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.passwordTextField];


    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 205, 280, 50)];
    [self.confirmButton setTitle:NSLocalizedString(@"finished",nil) forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.confirmButton addTarget:self action:@selector(confirmationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];

}

- (void)goBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmationAction:(id)sender {

    NSLog(@"confirmationAction - %@", self.email);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];

    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextField.text;


    if (([code length] <= 0) || ([password length] <= 0)   ) {
        // show toast
        [self.view makeToast:NSLocalizedString(@"not_fields",nil)];
        return;
    }

    NSString *passwordSecure = [password MD5];
    
    NSDictionary *params = @{@"isDriver":@"driver",@"email": self.email,@"token": code,@"password": passwordSecure};
    NSLog(@"confirmationAction %@", params);

    [api codeConfirm:params success:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"-> dictionary %@",dictionary);

            long error = [[dictionary objectForKey:@"error"] integerValue];
            if (error == 0) {
                //
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"recover_email"];
                [defaults synchronize];
                
                LoginViewController *loginVC = [[LoginViewController alloc] initWithRegister:YES];
                [self.navigationController pushViewController:loginVC animated:NO];
                //[self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"error");
        }
    }];

}

@end
