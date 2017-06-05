//
//  RecoverViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 6/7/16.
//  Copyright © 2016 Imaginamos. All rights reserved.
//

#import "RecoverViewController.h"
#import "ConfirmViewController.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"

@interface RecoverViewController ()
{
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
}

@end

@implementation RecoverViewController



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

    NSLog(@"RecoverViewController viewWillAppear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;


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
    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 105, 280, 38)];
    self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.loginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.loginTextField setPlaceholder:NSLocalizedString(@"email_input",nil)];
    self.loginTextField.delegate = self;
    self.loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.loginTextField];

    self.recoverButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 155, 280, 50)];
    [self.recoverButton setTitle:NSLocalizedString(@"recover_password",nil) forState:UIControlStateNormal];
    [self.recoverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recoverButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.recoverButton addTarget:self action:@selector(recoverAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recoverButton];


}

- (void)goBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)recoverAction:(id)sender {


    ApiTaxisya *api = [ApiTaxisya sharedInstance];

    NSString *email = self.loginTextField.text;

    if ([email length] <= 0) {
        // show toast
        [self.view makeToast:NSLocalizedString(@"not_fields",nil)];
        return;
    }


    NSDictionary *params = @{@"isDriver":@"driver",
                             @"email": email
                             };
    [api recoverPassword:params success:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"-> dictionary %@",dictionary);

            long error = [[dictionary objectForKey:@"error"] integerValue];
            if (error == 0) {
                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:email forKey:@"recover_email"];

                ConfirmViewController *confirmVC = [[ConfirmViewController alloc]
                                                initWithNibName:nil bundle:nil];

                confirmVC.email = email;
                [self.navigationController pushViewController:confirmVC animated:YES];
            }
        }
        else {
            NSLog(@"error");
        }
    }];



}



@end
