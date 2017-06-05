//
//  LoginViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+MD5Addition.h"
#import "NSString+MD5.h"
#import "ApiTaxisya.h"
#import "PickerCar.h"
#import "Car.h"
#import "UIView+Toast.h"
#import "RegionViewController.h"
#import "RegisterViewController.h"
#import "RecoverViewController.h"
#import "ConfirmViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)initWithRegister:(BOOL)aRegister {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isLogin = aRegister;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.plateIndex = 0;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_isLogin) {
        self.navigationItem.hidesBackButton = YES;
    }

    NSLog(@"LoginViewController viewWillAppear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;

    // make title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 34)];
    NSString *stringTitle = [NSString stringWithFormat:@"%@ %@",
                             NSLocalizedString(@"title_login_first",nil),
                             NSLocalizedString(@"title_login_last",nil)];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setText:stringTitle];
    [self.titleLabel setFont:[self.titleLabel.font fontWithSize:22]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: self.titleLabel.attributedText];

    // set color for last title
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]
                 range:NSMakeRange([NSLocalizedString(@"title_login_first",nil) length] + 1, [NSLocalizedString(@"title_login_last",nil) length])];
    [self.titleLabel setAttributedText: text];
    [self.view addSubview:self.titleLabel];

    // subtitle
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 98, screenWidth, 18)];
    [self.subtitleLabel setTextColor:[UIColor grayColor]];
    [self.subtitleLabel setText:NSLocalizedString(@"subtitle_login",nil)];
    [self.subtitleLabel setFont:[self.subtitleLabel.font fontWithSize:16]];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subtitleLabel];

    // input login
    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 124, 280, 38)];
    self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.loginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.loginTextField setPlaceholder:NSLocalizedString(@"hint_email",nil)];
    self.loginTextField.delegate = self;
    self.loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.loginTextField];

    // input password
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 170, 280, 38)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"hint_password",nil)];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.passwordTextField];

    // button login
    self.signInButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 216, 280, 50)];
    [self.signInButton setTitle:NSLocalizedString(@"signin_button",nil) forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signInButton setBackgroundColor:[UIColor greenColor]];
    [self.signInButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signInButton];

    // message
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 264, 280, 45)];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setTextColor:[UIColor blackColor]];
    [self.messageLabel setText:NSLocalizedString(@"message_login",nil)];
    [self.messageLabel setFont:[self.subtitleLabel.font fontWithSize:16]];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.messageLabel];

    // address
//    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, screenWidth, 18)];
//    [self.addressLabel setTextColor:[UIColor blackColor]];
//    [self.addressLabel setText:NSLocalizedString(@"address_login",nil)];
//    [self.addressLabel setFont:[self.addressLabel.font fontWithSize:16]];
//    self.addressLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:self.addressLabel];


    // button register
    self.signUpButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 328, 280, 50)];
    [self.signUpButton setTitle:NSLocalizedString(@"signup_button",nil) forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.signUpButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];

    // recover password
    self.recoverButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 378, 280, 50)];
    [self.recoverButton setTitle:NSLocalizedString(@"recover_button",nil) forState:UIControlStateNormal];
    [self.recoverButton setTitleColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f] forState:UIControlStateNormal];
    [self.recoverButton setFont:[self.subtitleLabel.font fontWithSize:14]];

    [self.recoverButton setBackgroundColor:[UIColor clearColor]];
    [self.recoverButton addTarget:self action:@selector(recoverAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recoverButton];

    // confirm

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"recover_email"];

    if (email != nil) {
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 428, 280, 50)];
        [self.confirmButton setTitle:NSLocalizedString(@"confirm_button",nil) forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f] forState:UIControlStateNormal];
        [self.confirmButton setFont:[self.subtitleLabel.font fontWithSize:14]];

        [self.confirmButton setBackgroundColor:[UIColor clearColor]];
        [self.confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.confirmButton];
    }



    // phone
//    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, screenWidth, 18)];
//    [self.phoneLabel setTextColor:[UIColor blackColor]];
//    [self.phoneLabel setText:NSLocalizedString(@"phone_login",nil)];
//    [self.phoneLabel setFont:[self.phoneLabel.font fontWithSize:16]];
//    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:self.phoneLabel];



}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"LoginViewController viewDidAppear ");
    if (self.isFinished) {
        [self.view makeToast:NSLocalizedString(@"register_ok_message",nil)];
    }
}

-(void)loginAction:(id)sender {
    NSLog(@"    loginAction");

    if (![self validateFields]) return;

    NSString *login = self.loginTextField.text;
    NSString *passwordInsecure = self.passwordTextField.text;
    //NSString *passwordSecure = [passwordInsecure MD5String];
    NSString *passwordSecure = [passwordInsecure MD5];


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    if (uuid == nil) {
        uuid = @"4e7b54db144ef812428c4111c5f6c7bcedbbea75875f690dc900c1d49cb36a57";
    }
    NSDictionary *params = @{@"type":@"1", @"login": login, @"pwd": passwordSecure, @"uuid" : uuid};
    self.plateForChoose = [[NSMutableArray alloc] init];
    NSLog(@"driverLogin: %@", params);
    [self.view endEditing:YES];

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverLogin:params success:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"-> dictionary %@",dictionary);
            if ([dictionary[@"error"] isEqualToString:@"0"]) {

                NSLog(@"driverLogin response: %@",dictionary);
                NSLog(@"driver_id = %@",dictionary[@"id"]);

                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:dictionary[@"id"] forKey:@"driver_id"];
                [defaults setObject:dictionary[@"name"] forKey:@"name"];

                [defaults setObject:login forKey:@"login"];
                [defaults setObject:passwordSecure forKey:@"password"];
                [defaults synchronize];

                [self parseCars:dictionary];
            }
            else if ([dictionary[@"error"] isEqualToString:@"1"]) {
                [self.view makeToast:NSLocalizedString(@"error_one",nil)];
            }
            else if ([dictionary[@"error"] isEqualToString:@"2"]) {
                [self.view makeToast:NSLocalizedString(@"error_two",nil)];
            }
            else if ([dictionary[@"error"] isEqualToString:@"3"]) {
                [self.view makeToast:NSLocalizedString(@"error_three",nil)];
            }
            else {
                NSLog(@"error otro");
            }

        }
        else {
             NSLog(@"driverLogin error: %@",result);
            [self.view makeToast:NSLocalizedString(@"error_net",nil)];
        }
    }];
}

-(void)registerAction:(id)sender {
    NSLog(@"    registerAction");

    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    registerVC.delegate = self;
    [self.navigationController pushViewController:registerVC animated:NO];

//    RegionViewController *regionVC = [[RegionViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:regionVC animated:YES];
}

-(void)recoverAction:(id)sender {
    NSLog(@"    recoverAction");
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    RecoverViewController *recoverVC = [[RecoverViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:recoverVC animated:NO];

}

-(void)confirmAction:(id)sender {
    NSLog(@"    confirmAction");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"recover_email"];

    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    ConfirmViewController *confirmVC = [[ConfirmViewController alloc] initWithNibName:nil bundle:nil];
    confirmVC.email = email;
    [self.navigationController pushViewController:confirmVC animated:NO];


}


#pragma marks - Utils
-(BOOL)validateFields {
    if (([self.loginTextField.text length] > 0) && ([self.passwordTextField.text length] > 0)) return YES;
    return NO;
}

-(void)confirmPlate {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *carId = [NSString stringWithFormat:@"%ld", [[self.plateForChoose objectAtIndex:self.plateIndex] carId]];

    NSDictionary *params = @{@"driver_id": driverId,
                             @"car_id": carId};
    NSLog(@"confirmPlate %@",params);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverUpdateCar:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"driverUpdateCar response: %@",dictionary);
        }
        else {
            NSLog(@"driverUpdateCar error: %@",response);
        }
    }];
}

-(void)parseCars:(NSDictionary *) dictionary {

    for (NSDictionary *d in dictionary[@"cars"]) {
        Car *car = [[Car alloc]
                            initWithObject:[d[@"id"] integerValue] plate:d[@"placa"]];
        [self.plateForChoose addObject:car];
    }
    if ([self.plateForChoose count] > 0) {
        [self.view endEditing:YES];

        [self showDialogSelectCar];
    }
}

-(void)showDialogSelectCar {

    CustomIOSAlertView *carView = [[CustomIOSAlertView alloc] init];
    [carView setContainerView:[self createCarView]];
    [carView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"car_confirm_button",nil), nil]];
    [carView setDelegate:self];

    [carView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);

        // plate selected
        NSLog(@" placa %ld %@", [[self.plateForChoose objectAtIndex:self.plateIndex] carId] ,
              [[self.plateForChoose objectAtIndex:self.plateIndex] carPlate]);

        [alertView close];
        [self confirmPlate];
        [self clearTemporaryRegister];
        self.plateForChoose = nil;
        [self.navigationController popToRootViewControllerAnimated:NO];

    }];
    [carView setUseMotionEffects:true];
    [carView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex{
    
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIView *)createCarView{
    
    UIView *carsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 180)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 30)];
    [titleLabel setText:NSLocalizedString(@"title_car",nil)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [carsView addSubview:titleLabel];

    UIPickerView *carPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 50,270, 120)];
    [carPickedView setDataSource: self];
    [carPickedView setDelegate: self];
    carPickedView.showsSelectionIndicator = YES;
    [carsView addSubview:carPickedView];

    return carsView;
}

-(void)clearTemporaryRegister {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:@"register_name"];
    [defaults removeObjectForKey:@"register_identity"];
    [defaults removeObjectForKey:@"register_email"];
    [defaults removeObjectForKey:@"register_license"];
    [defaults removeObjectForKey:@"register_phone"];
    [defaults removeObjectForKey:@"register_cellphone"];
    [defaults removeObjectForKey:@"register_address"];
    [defaults removeObjectForKey:@"register_password"];
    [defaults removeObjectForKey:@"register_car_plate"];
    [defaults removeObjectForKey:@"register_car_brand"];
    [defaults removeObjectForKey:@"register_car_line"];
    [defaults removeObjectForKey:@"register_car_mobile_id"];
    [defaults removeObjectForKey:@"register_car_year"];
    [defaults removeObjectForKey:@"register_car_company"];
    [defaults removeObjectForKey:@"register_photo"];
    [defaults removeObjectForKey:@"register_doc1"];
    [defaults removeObjectForKey:@"register_doc2"];
    [defaults removeObjectForKey:@"register_doc3"];
    [defaults removeObjectForKey:@"register_doc4"];

    [defaults synchronize];
}

#pragma marks - UIPickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //NSLog(@"numberOfRowsInComponent: %d", [self.dateForChoose count]);
    return [self.plateForChoose count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //NSLog(@"titleForRow %@", [self.dateForChoose objectAtIndex: row]);
    return [[self.plateForChoose objectAtIndex: row] carPlate];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this [%2ld, %2ld]: %@", (unsigned long)row, (unsigned long)component, [self.plateForChoose objectAtIndex: row]);
    self.plateIndex = row;
    NSLog(@"count - %ld", (unsigned long)[self.plateForChoose count]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma marks - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

#pragma mark - RegisterViewControllerDelegate
-(void)showToastWhenRegisterFinish:(BOOL) finish  {
    NSLog(@"showToastWhenRegisterFinished: %@", @"ended");
    self.isFinished = finish;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
