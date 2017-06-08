//
//  Register.m
//  taxisya
//
//  Created by NTTak3 on 26/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "Register.h"
#import "TYUsserProfile.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "HTTPSyncRequest.h"
#import "PaymentVC.h"

@interface Register ()

@end

@implementation Register

@synthesize delegate                    = _delegate;

@synthesize scrvwFrom                   = _scrvwFrom;
@synthesize lbIngresa                   = _lbIngresa;
@synthesize lbTus                       = _lbTus;
@synthesize lbName                      = _lbName;
@synthesize lbPass                      = _lbPass;
@synthesize txtfUser                    = _txtfUser;
@synthesize txtfPass                    = _txtfPass;

@synthesize currentTypeView             = _currentTypeView;

@synthesize scrvwRegistry               = _scrvwRegistry;
@synthesize lbReg1                      = _lbReg1;
@synthesize lbReg2                      = _lbReg2;
@synthesize lbReg3                      = _lbReg3;
@synthesize lbReg4                      = _lbReg4;
@synthesize lbReg5                      = _lbReg5;
@synthesize lbReg6                      = _lbReg6;
@synthesize lbReg7                      = _lbReg7;
@synthesize txtfRName                   = _txtfRName;
@synthesize txtfRLastName               = _txtfRLastName;
@synthesize txtfRUsser                  = _txtfRUsser;
@synthesize txtfRPass                   = _txtfRPass;
@synthesize txtfRCellPhone              = _txtfRCellPhone;

@synthesize tysLogin                    = _tysLogin;

@synthesize vwLoading                   = _vwLoading;
@synthesize isLoadingVWShowing          = _isLoadingVWShowing;

@synthesize recoveryPassVWC             = _recoveryPassVWC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    // Do any additional setup after loading the view from its nib.

    [_lbIngresa setFont:UI_FONT_1(23)];
    [_lbTus setFont:UI_FONT_1(22)];
    [_lbName setFont:UI_FONT_1(16)];
    [_lbPass setFont:UI_FONT_1(16)];
    [_txtfPass setFont:UI_FONT_1(16)];
    [_txtfUser setFont:UI_FONT_1(16)];

    [_lbReg1 setFont:UI_FONT_1(23)];
    [_lbReg2 setFont:UI_FONT_1(22)];
    [_lbReg3 setFont:UI_FONT_1(16)];
    [_lbReg4 setFont:UI_FONT_1(16)];
    [_lbReg5 setFont:UI_FONT_1(16)];
    [_lbReg6 setFont:UI_FONT_1(16)];
    [_lbReg7 setFont:UI_FONT_1(16)];
    [_txtfRName setFont:UI_FONT_1(16)];
    [_txtfRLastName setFont:UI_FONT_1(16)];
    [_txtfRPass setFont:UI_FONT_1(16)];
    [_txtfRUsser setFont:UI_FONT_1(16)];
    [_txtfRCellPhone setFont:UI_FONT_1(16)];



    // register
    [_txtfRLastName setPlaceholder:NSLocalizedString(@"register_name",nil)];
    [_txtfRUsser setPlaceholder:NSLocalizedString(@"register_email",nil)];
    [_txtfRCellPhone setPlaceholder:NSLocalizedString(@"register_cellphone",nil)];
    [_txtfRPass setPlaceholder:NSLocalizedString(@"register_password",nil)];


    // login
    [_loginTxtUser setPlaceholder:NSLocalizedString(@"register_email",nil)];
    [_loginTxtPass setPlaceholder:NSLocalizedString(@"register_password",nil)];

    [_loginBtnRegister setTitle:NSLocalizedString(@"register_btn_register",nil) forState:UIControlStateNormal];

    [_loginBtnLogin setTitle:NSLocalizedString(@"register_btn_sign_in",nil) forState:UIControlStateNormal];

    [_loginBtnRecover setTitle:NSLocalizedString(@"login_btn_recover",nil) forState:UIControlStateNormal];



    _registerTitleOne.text = NSLocalizedString(@"register_title_1",nil);
    _registerTitleTwo.text = NSLocalizedString(@"register_title_2",nil);
    _registerTitleThree.text = NSLocalizedString(@"register_title_3",nil);

    _logintTitleOne .text = NSLocalizedString(@"login_title_1",nil);
    _loginTitleTwo .text = NSLocalizedString(@"login_title_2",nil);


    self.currentTypeView = CurrentTypeViewRegistry;

    [_scrvwFrom setBackgroundColor:UI_COLOR_247];
    [_scrvwRegistry setBackgroundColor:UI_COLOR_247];
    [_scrvwRegistry setContentSize:CGSizeMake(0, _scrvwRegistry.frame.size.height + 220)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack:) name:@"push_close_session" object:nil];
    
    [self show:YES];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPayment:(id)sender {
    PaymentVC *paymentVC = [[PaymentVC alloc] initWithNibName:@"PaymentVC" bundle:nil];
    paymentVC.delegate = self;
    [self.navigationController pushViewController:paymentVC animated:YES];

}

- (void)show:(BOOL)show{

    if(show){

        _currentTypeView = CurrentTypeViewRegistry;
        [_scrvwFrom setTransform:CGAffineTransformMakeTranslation(_scrvwRegistry.frame.size.width, 0)];
        [_scrvwFrom setAlpha:0];
        [_scrvwRegistry setTransform:CGAffineTransformIdentity];
        [_scrvwRegistry setAlpha:1];

        [self.txtfRLastName setText:[TYUsserProfile UsserInfoForKey:USSER_NAME]];
        [self.txtfRUsser setText:[TYUsserProfile UsserInfoForKey:USSER_EMAIL]];
        [self.txtfRCellPhone setText:[TYUsserProfile UsserInfoForKey:USSER_CELLPHONE]];
        [self.txtfRPass setText:[TYUsserProfile UsserInfoForKey:USSER_PASSWORD]];

        if([TYUsserProfile IsUsserRegistred]){

            [self.txtfRUsser setEnabled:NO];
            [self.txtfRUsser setAlpha:0.5];

            [self.btnIngresar setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
            [self.btnIngresar setBackgroundImage:[UIImage imageNamed:@"btn_p"] forState:UIControlStateHighlighted];
            [self.btnIngresar setTitle:NSLocalizedString(@"profile_button_update",nil) forState:UIControlStateNormal];

            [self.btnPayments setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
            [self.btnPayments setBackgroundImage:[UIImage imageNamed:@"btn_p"] forState:UIControlStateHighlighted];
            [self.btnPayments setTitle:NSLocalizedString(@"profile_button_payment",nil) forState:UIControlStateNormal];


            [self.btnYaTengoCuenta setBackgroundImage:[UIImage imageNamed:@"btn_gris_n"] forState:UIControlStateNormal];
            [self.btnYaTengoCuenta setBackgroundImage:[UIImage imageNamed:@"btn_gris_p"] forState:UIControlStateHighlighted];
            [self.btnYaTengoCuenta setTitle:NSLocalizedString(@"profile_button_logout",nil) forState:UIControlStateNormal];
        }else{

            [self.txtfRUsser setEnabled:YES];
            [self.txtfRUsser setAlpha:1];
            [self.btnIngresar setBackgroundImage:[UIImage imageNamed:@"btn_n"] forState:UIControlStateNormal];
            [self.btnIngresar setBackgroundImage:[UIImage imageNamed:@"btn_p"] forState:UIControlStateHighlighted];
            [self.btnIngresar setTitle:NSLocalizedString(@"profile_button_register",nil) forState:UIControlStateNormal];

            [self.btnPayments setHidden:YES];

            [self.btnYaTengoCuenta setBackgroundImage:[UIImage imageNamed:@"btn_gris_n"] forState:UIControlStateNormal];
            [self.btnYaTengoCuenta setBackgroundImage:[UIImage imageNamed:@"btn_gris_p"] forState:UIControlStateHighlighted];
            [self.btnYaTengoCuenta setTitle:NSLocalizedString(@"profile_button_login",nil) forState:UIControlStateNormal];

        }

        self.view.alpha = 0;
        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);

        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             self.view.alpha = 1;
                             self.view.transform = CGAffineTransformIdentity;

                         }
                         completion:^(BOOL f){


                         }];

    }else{

        [self closeKeyBoard];

        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             self.view.alpha = 0;
                             self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);

                         }
                         completion:^(BOOL f){



                         }];

    }

}

- (void)goBack:(id)sender
{

    [self closeKeyBoard];

    if(_isLoadingVWShowing){

        [_tysLogin clearDelegateAndCancel];

        [self showloading:NO];

    }

    if(_currentTypeView == CurrentTypeViewLogin){

        [self showVWRegistry:NO];

    }else{

        if(_delegate && [_delegate respondsToSelector:@selector(RegisterVWCGoBack)]){

            [_delegate RegisterVWCGoBack];

        }else{

            //[self show:NO];
            [self.navigationController popViewControllerAnimated:NO];
        }

    }

}

- (void)goLogin:(id)sender{


    if([self validateLogin])
    {

        [self closeKeyBoard];

        _currentTypeView = CurrentTypeViewLogin;

        [self showloading:YES];

        [self initServiceIfNeeded];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:_txtfUser.text forKey:@"login"];
        [dic setObject:_txtfPass.text forKey:@"pwd"];

        [_tysLogin requestLoginType:TYSLoginTypeLogin object:dic];

    }

}

- (BOOL)validateLogin{

    if(_txtfUser.text.length){

        if([TYFormatter FormatterValidateEmail:_txtfUser.text]){

            if(_txtfPass.text.length){

                return YES;

            }else{

                [self showAlertWithMessage:NSLocalizedString(@"register_alert_1",nil) tag:1002 title:NSLocalizedString(@"register_alert_title",nil)];

            }

        }else{

            [self showAlertWithMessage:NSLocalizedString(@"register_alert_2",nil) tag:1001 title:NSLocalizedString(@"register_alert_title",nil)];

        }

    }else{

        [self showAlertWithMessage:NSLocalizedString(@"register_alert_3",nil) tag:1000 title:NSLocalizedString(@"register_alert_title",nil)];

    }


    return NO;

}

- (BOOL)validateRegistry{

        if(_txtfRLastName.text.length){

            if(_txtfRUsser.text.length){

                if([TYFormatter FormatterValidateEmail:_txtfRUsser.text]){

                    if(_txtfRCellPhone.text.length){

                        if([TYFormatter FormatterValidateNumbers:_txtfRCellPhone.text]){

                            if(_txtfRPass.text.length){

                                return YES;

                            }else{

                                [self showAlertWithMessage:NSLocalizedString(@"register_alert_1",nil) tag:2006 title:NSLocalizedString(@"register_alert_title",nil)];

                            }

                        }else{

                            [self showAlertWithMessage:NSLocalizedString(@"register_alert_5",nil) tag:2005 title:NSLocalizedString(@"register_alert_title",nil)];

                        }


                    }else{

                        [self showAlertWithMessage:NSLocalizedString(@"register_alert_6",nil) tag:2004 title:NSLocalizedString(@"register_alert_title",nil)];

                    }


                }else{

                    [self showAlertWithMessage:NSLocalizedString(@"register_alert_2",nil) tag:2003 title:NSLocalizedString(@"register_alert_title",nil)];

                }


            }else{

                [self showAlertWithMessage:NSLocalizedString(@"register_alert_3",nil) tag:2002 title:NSLocalizedString(@"register_alert_title",nil)];

            }


        }else{

            [self showAlertWithMessage:NSLocalizedString(@"register_alert_9",nil) tag:2001 title:NSLocalizedString(@"register_alert_title",nil)];

        }


    return NO;

}

- (void)initServiceIfNeeded{

    if(!_tysLogin){

        self.tysLogin = [[TYSLogin alloc] initwithDelegate:self];

    }

}

- (void)showAlertWithMessage:(NSString *)msg tag:(int)tag title:(NSString *)title{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"Aceptar"
                                           otherButtonTitles:nil];

    alert.tag = tag;

    [alert show];

}


- (void)showAlertWithMessage:(NSString *)msg tag:(int)tag{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:msg
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"register_alert_button",nil)
                                         otherButtonTitles:nil];

    alert.tag = tag;

    [alert show];

}

- (void)goRegistry:(id)sender{

    //_currentTypeView = CurrentTypeViewRegistry;
    _currentTypeView = CurrentTypeViewLogin;

    [self goBack:nil];

}

- (void)onHideKeyBoard:(id)sender{

    [self closeKeyBoard];

}

- (void)goRegistrationLogin:(id)sender{

    [self closeKeyBoard];

    if([self validateRegistry]){

        [self showloading:YES];

        [self initServiceIfNeeded];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

        [dic setObject:_txtfRLastName.text forKey:@"name"];
        [dic setObject:_txtfRLastName.text forKey:@"lastname"];
        [dic setObject:_txtfRUsser.text forKey:@"email"];
        [dic setObject:_txtfRCellPhone.text forKey:@"cellphone"];
        [dic setObject:_txtfRPass.text forKey:@"pwd"];

        [_tysLogin requestLoginType:TYSLoginTypeRegister object:dic];

    }

}

- (void)goRegistrationAccess:(id)sender{
    if([TYUsserProfile IsUsserRegistred]){
        [[[HTTPSyncRequest alloc] init] validateLogout:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [TYUsserProfile UsserInfoForKey:USSER_EMAIL], @"login",
                                                        [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN], @"uuid",
                                                        [[TYUsserProfile UsserInfoForKey:USSER_PASSWORD] MD5String], @"pwd",
                                                        nil] delegate:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_close_session" object:nil];
        [TYUsserProfile RemoveUsserWithUsser];
        [self.txtfRLastName setText:[TYUsserProfile UsserInfoForKey:USSER_NAME]];
        [self.txtfRUsser setText:[TYUsserProfile UsserInfoForKey:USSER_EMAIL]];
        [self.txtfRCellPhone setText:[TYUsserProfile UsserInfoForKey:USSER_CELLPHONE]];
        [self.txtfRPass setText:[TYUsserProfile UsserInfoForKey:USSER_PASSWORD]];

        [self goBack:nil];
    }else{
        [self showVWRegistry:YES];
    }
}

- (void)goLoginRecoveryPass:(id)sender
{
    [self closeKeyBoard];
    [self initAndShowRecoveryPassword];
}

- (void)showVWRegistry:(BOOL)show{

    [self closeKeyBoard];

    if (show){

        _currentTypeView = CurrentTypeViewLogin;

        [_scrvwFrom setTransform:CGAffineTransformMakeTranslation(_scrvwFrom.frame.size.width, 0)];
        [_scrvwFrom setAlpha:0];

        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             [_scrvwFrom setTransform:CGAffineTransformIdentity];
                             [_scrvwFrom setAlpha:1];
                             [_scrvwRegistry setTransform:CGAffineTransformMakeTranslation(-self.scrvwFrom.frame.size.width, 0)];
                             [_scrvwRegistry setAlpha:0];

                         }
                         completion:^(BOOL f){



                         }];

    }else{

        _currentTypeView = CurrentTypeViewRegistry;

        [self closeKeyBoard];

        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             [_scrvwFrom setTransform:CGAffineTransformMakeTranslation(_scrvwFrom.frame.size.width, 0)];
                             [_scrvwFrom setAlpha:0];
                             [_scrvwRegistry setTransform:CGAffineTransformIdentity];
                             [_scrvwRegistry setAlpha:1];

                         }
                         completion:^(BOOL f){



                         }];

    }

}

- (void)closeKeyBoard{

    AppDelegate *DELEGATE = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [DELEGATE hideKeyBoard];

    if(_currentTypeView == CurrentTypeViewLogin){

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_scrvwFrom setContentOffset:CGPointMake(0, 0)];

                         }
                         completion:^(BOOL f){

                             [_scrvwFrom setContentSize:CGSizeMake(0, 0)];

                         }];

    }else{

        [UIView animateWithDuration:0.3
                         animations:^(void){

//                             [_scrvwRegistry setContentOffset:CGPointMake(0, 0)];

                             [_scrvwRegistry setContentSize:CGSizeMake(0, _scrvwRegistry.frame.size.height + 120)];

                         }
                         completion:^(BOOL f){



                         }];
    }

}

- (void)showloading:(BOOL)show{

    if(show){

        _isLoadingVWShowing = YES;

        [self.view bringSubviewToFront:_vwLoading];

        [_vwLoading setHidden:NO];

    }else{

        _isLoadingVWShowing = NO;

        [_vwLoading setHidden:YES];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }

}

#pragma mark -
#pragma mark - UITExtFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(_currentTypeView == CurrentTypeViewLogin){

        if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

            [_scrvwFrom setContentSize:CGSizeMake(0, _scrvwFrom.frame.size.height * 1.25)];

            [_scrvwFrom setContentOffset:CGPointMake(0, 15) animated:YES];

        }else{

            [_scrvwFrom setContentSize:CGSizeMake(0, _scrvwFrom.frame.size.height * 1.3)];

            [_scrvwFrom setContentOffset:CGPointMake(0, (textField.frame.origin.y + 25) - textField.frame.size.height - 70) animated:YES];

        }

    }else{

        if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

            [_scrvwRegistry setContentSize:CGSizeMake(0, _scrvwFrom.frame.size.height * 1.55)];

            [_scrvwRegistry setContentOffset:CGPointMake(0, (textField.frame.origin.y - 90)) animated:YES];

        }else{

            [_scrvwRegistry setContentSize:CGSizeMake(0, _scrvwFrom.frame.size.height * 1.68)];

            [_scrvwRegistry setContentOffset:CGPointMake(0, textField.frame.origin.y - 40) animated:YES];

        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self closeKeyBoard];

    return YES;

}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(alertView.tag == 1000){

        [_txtfUser becomeFirstResponder];

    }else if (alertView.tag == 1001){

        [self.txtfRUsser setText:@""];
        [_txtfUser becomeFirstResponder];

    }else if (alertView.tag == 1002){

        [_txtfPass becomeFirstResponder];

    }else if (alertView.tag == 2000){

        [self.txtfRName becomeFirstResponder];

    }else if (alertView.tag == 2001){

        [self.txtfRLastName becomeFirstResponder];

    }else if (alertView.tag == 2002){

        [self.txtfRUsser becomeFirstResponder];

    }else if (alertView.tag == 2003){

        [self.txtfRUsser setText:@""];
        [self.txtfRUsser becomeFirstResponder];

    }else if (alertView.tag == 2004){

        [self.txtfRCellPhone becomeFirstResponder];

    }else if (alertView.tag == 2005){

        [self.txtfRCellPhone setText:@""];
        [self.txtfRCellPhone becomeFirstResponder];

    }else if (alertView.tag == 2006){

        [self.txtfPass becomeFirstResponder];

    }

}

#pragma mark -
#pragma mark RecoveryPasswordVWC

- (void)initAndShowRecoveryPassword
{
    if(!_recoveryPassVWC){
        self.recoveryPassVWC = [[RecoveryPassVWC alloc] initWithNibName:@"RecoveryPassVWC" bundle:nil];
        self.recoveryPassVWC.delegate = self;
        [self.view addSubview:_recoveryPassVWC.view];
    }

    [self.view bringSubviewToFront:_recoveryPassVWC.view];
    [self.recoveryPassVWC show:YES animated:YES];

}

- (void)RecoveryPassGoLogin
{
//    [self goRegistrationLogin:nil];
    [_txtfUser setText:_recoveryPassVWC.txtfEmail.text];

}

#pragma mark -
#pragma mark - TYServicesDelegate

- (void)TYSLoginType:(TYSLoginType)type response:(NSString *)response status:(ServiceStatus)status{

    [self showloading:NO];

    NSLog(@"%@",response);

    if(type == TYSLoginTypeLogin){


        if(status == ServiceStatusOk){

            NSDictionary *dic = [response JSONValue];

            if(dic){

                NSLog(@"%@",[dic description]);

                NSString *error = [dic objectForKey:@"error"];

                if(error && [error isEqualToString:@"1"]){

                    [self showAlertWithMessage:NSLocalizedString(@"register_alert_10",nil) tag:0];

                }else{

                    NSString *cellphone =   [dic objectForKey:@"cellphone"];
                    NSString *email =       [dic objectForKey:@"email"];
                    NSString *usuID =       [dic objectForKey:@"id"];
                    NSString *lastname =    [dic objectForKey:@"lastname"];
                    NSString *name =        [dic objectForKey:@"name"];

                    [TYUsserProfile CreateUsserWithUsserId:usuID
                                                      name:name
                                                   surname:lastname
                                                     email:email
                                                 cellPhone:cellphone
                                                  password:_txtfPass.text];


//                    [_delegate RegisterVWCLoginsuccesfull:YES];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] getServiceCurrent];
                    [self goBack:nil];

                    [self show:NO];

                }

            }else{
                [self showAlertWithMessage:NSLocalizedString(@"register_alert_11",nil) tag:0];
            }

        }else{

            [self showAlertWithMessage:NSLocalizedString(@"register_alert_11",nil) tag:0];

        }

    }else if (type == TYSLoginTypeRegister){

        if(status == ServiceStatusOk){

            NSDictionary *values = [response JSONValue];

            if(values){

                NSString *error = [values objectForKey:@"error"];

                if(error && [error isEqualToString:@"1"]){

                    [self showAlertWithMessage:NSLocalizedString(@"register_alert_12",nil) tag:0];

                }else{

                    NSString *cellphone =       [values objectForKey:@"cellphone"];
                    NSString *email =           [values objectForKey:@"email"];
                    NSString *usuID =           [values objectForKey:@"id"];
                    NSString *lname =           [values objectForKey:@"lastname"];
                    NSString *name =            [values objectForKey:@"name"];

                    [TYUsserProfile CreateUsserWithUsserId:usuID
                                                      name:name
                                                   surname:lname
                                                     email:email
                                                 cellPhone:cellphone
                                                  password:_txtfRPass.text];


                    [_delegate RegisterVWCLoginsuccesfull:YES];

                    [self show:NO];

                }

            }else{

                [self showAlertWithMessage:NSLocalizedString(@"register_alert_11",nil) tag:0];

            }

        }else{

            [self showAlertWithMessage:NSLocalizedString(@"register_alert_11",nil) tag:0];

        }

    }

}

-(void)cardSelected:(NSString *)card {
    NSLog(@"cardSelected %@",card);

    if (card != nil) {
        //self.paymentSelection.selectedSegmentIndex = 1;
        NSLog(@"    paymented selected %@",card);
        
    }
}

- (IBAction)btnPayments:(id)sender {
}
@end
