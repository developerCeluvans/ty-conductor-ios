//
//  RecoveryPassVWC.m
//  taxisya
//
//  Created by NTTak3 on 8/11/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "RecoveryPassVWC.h"
#import "TYFormatter.h"
#import "JSON.h"
#import "AppDelegate.h"



@interface RecoveryPassVWC ()
- (IBAction)onBack:(id)sender;
- (IBAction)onEmailEnter:(id)sender;
- (IBAction)onCodEnter:(id)sender;
@end

@implementation RecoveryPassVWC

@synthesize delegate            = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Init the services object
        [self initServiceIfNeeded];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    // Do any additional setup after loading the view from its nib.
    [_vwEmail setBackgroundColor:UI_COLOR_247];
    [_scrvwCodigo setBackgroundColor:UI_COLOR_247];

    [_scrvwCodigo setContentSize:CGSizeMake(0, _scrvwCodigo.frame.size.height * 1.25)];

    [_txtfEmail setPlaceholder:NSLocalizedString(@"recover_email",nil)];
    [_recoverTitle setText:NSLocalizedString(@"recover_title", nil)];
    [_recoverBtnFinalizar setTitle:NSLocalizedString(@"recover_btn_finish", nil) forState:UIControlStateNormal];




}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show:(BOOL)show animated:(BOOL)animated
{


    [self showCod:NO];

    [_txtfEmail becomeFirstResponder];

    if(show){

        [self.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
        [self.view setAlpha:0];

        if(animated){

            [UIView animateWithDuration:0.3
                             animations:^(void){

                                 [self.view setTransform:CGAffineTransformIdentity];
                                 [self.view setAlpha:1];

                             }
                             completion:^(BOOL f){

                             }];

        }else{

            [self.view setTransform:CGAffineTransformIdentity];
            [self.view setAlpha:1];

        }

    }else{

        [self closeKeyboard];

        if(animated){

            [UIView animateWithDuration:0.3
                             animations:^(void){

                                 [self.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
                                 [self.view setAlpha:0];

                             }
                             completion:^(BOOL f){

                             }];

        }else{

            [self.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
            [self.view setAlpha:0];

        }

    }
}

- (void)showAlertWithMessage:(NSString *)message tag:(int)tag{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil, nil];

    alert.tag = tag;

    [alert show];

}

- (void)closeKeyboard
{
    AppDelegate *DELEGATE = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [DELEGATE hideKeyBoard];
}

- (void)onBack:(id)sender{
    [_tysLogin  clearDelegateAndCancel];
    [self show:NO animated:YES];
}


- (void)onEmailEnter:(id)sender
{
    if(_txtfEmail && _txtfEmail.text){

        if([TYFormatter FormatterValidateEmail:_txtfEmail.text]){

            // Make the service request for the recovery email
            [_tysLogin requestLoginType:TYSLoginTypeRecoveryEmail object:_txtfEmail.text];
            // Show the loading
            [self closeKeyboard];
            [self.view bringSubviewToFront:_vwLoading];

        }else{
            [self showAlertWithMessage:NSLocalizedString(@"recover_input_valid_email",nil) tag:0];
        }
    }else{
        [self showAlertWithMessage:NSLocalizedString(@"recover_input_email",nil) tag:0];
    }
}

- (void)onCodEnter:(id)sender
{
    if(_txtfCodigo && _txtfCodigo.text.length){

        if(_txtfPass && _txtfPass.text.length){

            NSMutableDictionary *dictionary = [NSMutableDictionary new];
            [dictionary setObject:_txtfEmail.text forKey:@"email"];
            [dictionary setObject:_txtfCodigo.text forKey:@"token"];
            [dictionary setObject:_txtfPass.text forKey:@"password"];

            // Make the service request for the recovery check email
            [_tysLogin requestLoginType:TYSloginTypeRecoveryEmailCheck object:dictionary];
            // Show the loading
            [self closeKeyboard];
            [self.view bringSubviewToFront:_vwLoading];

        }else{
            [self showAlertWithMessage:NSLocalizedString(@"recover_input_password",nil) tag:0];
        }
    }else{
        [self showAlertWithMessage:NSLocalizedString(@"recover_input_code",nil) tag:0];
    }
}

- (void)showCod:(BOOL)show{

    [self closeKeyboard];

    [_scrvwCodigo setContentOffset:CGPointZero];

    if(show){

        [_scrvwCodigo setHidden:NO];

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             /*
                              * Hidde the cod view
                              */

                             [_scrvwCodigo setAlpha:1];

                         }];

    }else{

        /*
         * Hidde the cod view
         */

        [_scrvwCodigo setAlpha:0];
        [_scrvwCodigo setHidden:YES];

    }

}

#pragma mark -
#pragma mark - UITExtFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    [_scrvwCodigo setContentOffset:CGPointMake(0, textField.frame.origin.y - 45) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self closeKeyboard];

    return YES;

}

#pragma mark -
#pragma mark Services

- (void)initServiceIfNeeded{

    if(!_tysLogin){

        self.tysLogin = [[TYSLogin alloc] initwithDelegate:self];

    }

}

- (void)makeLogicRequestTypeRecoveryEmailWithResponse:(NSString *)response status:(ServiceStatus)status
{
    NSLog(@" RESPONSE EMAIL ___________ %@", response);

    if(status == ServiceStatusOk){

        NSMutableDictionary *dic = [response JSONValue];

        NSString *error = [dic objectForKey:@"error"];

        int num = [error intValue];

        if(num > 0){

            [self showAlertWithMessage:NSLocalizedString(@"recover_email_not_registered",nil) tag:0];

        }else{

            [self showAlertWithMessage:NSLocalizedString(@"recover_input_code_received",nil) tag:0];

            //Show the cod view
            [self showCod:YES];

        }

    }else{

        [self showAlertWithMessage:NSLocalizedString(@"check_internet_connection",nil) tag:0];

    }
}

- (void)makeLogicRequestTypeRecoveryEmailCheckWithResponse:(NSString *)response status:(ServiceStatus)status
{

    NSLog(@" RESPONSE EMAIL CHECK ___________ %@", response);

    if(status == ServiceStatusOk){

        NSMutableDictionary *dic = [response JSONValue];

        NSString *error = [dic objectForKey:@"error"];

        int num = [error intValue];

        if(num > 0){

            [self showAlertWithMessage:NSLocalizedString(@"recover_error_code_register",nil) tag:0];

        }else{

            //Go to the login
            [self show:NO animated:YES];
            [_delegate RecoveryPassGoLogin];

        }

    }else{

        [self showAlertWithMessage:NSLocalizedString(@"check_internet_connection",nil) tag:0];

    }
}


- (void)TYSLoginType:(TYSLoginType)type response:(NSString *)response status:(ServiceStatus)status
{
    //Hide the loading VW
    [self.view sendSubviewToBack:_vwLoading];

    if(type == TYSLoginTypeRecoveryEmail){

        [self makeLogicRequestTypeRecoveryEmailWithResponse:response status:status];

    }else if (type == TYSloginTypeRecoveryEmailCheck){

        [self makeLogicRequestTypeRecoveryEmailCheckWithResponse:response status:status];
    }
}

@end
