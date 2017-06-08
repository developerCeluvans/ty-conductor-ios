//
//  Register.h
//  taxisya
//
//  Created by NTTak3 on 26/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYFormatter.h"
#import "TYSLogin.h"
#import "RecoveryPassVWC.h"

typedef enum{

    CurrentTypeViewLogin,
    CurrentTypeViewRegistry

} CurrentTypeView;

@protocol RegisterDelegate;

@interface Register : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, TYSLoginDelegate, RecoveryPassVWCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTxtUser;
@property (weak, nonatomic) IBOutlet UITextField *loginTxtPass;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnLogin;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnRegister;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnRecover;
@property (weak, nonatomic) IBOutlet UIButton *registerBtnRegister;
@property (weak, nonatomic) IBOutlet UIButton *registerBtnLogin;

@property (nonatomic, assign) id <RegisterDelegate>                 delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymen;

@property (nonatomic, strong) IBOutlet UIScrollView                 *scrvwFrom;
@property (nonatomic, strong) IBOutlet UILabel                      *lbIngresa;
@property (nonatomic, strong) IBOutlet UILabel                      *lbTus;
@property (nonatomic, strong) IBOutlet UILabel                      *lbName;
@property (nonatomic, strong) IBOutlet UILabel                      *lbPass;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfUser;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfPass;

@property (nonatomic, assign) CurrentTypeView                       currentTypeView;

@property (nonatomic, strong) IBOutlet UIScrollView                 *scrvwRegistry;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg1;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg2;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg3;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg4;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg5;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg6;
@property (nonatomic, strong) IBOutlet UILabel                      *lbReg7;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfRName;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfRLastName;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfRUsser;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfRPass;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfRCellPhone;

@property (nonatomic, strong) TYSLogin                              *tysLogin;

@property (nonatomic, strong) IBOutlet UIView                       *vwLoading;
@property (nonatomic, assign) BOOL                                  isLoadingVWShowing;

@property (nonatomic, strong) RecoveryPassVWC                       *recoveryPassVWC;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UILabel *registerTitleOne;
@property (weak, nonatomic) IBOutlet UILabel *registerTitleTwo;
@property (weak, nonatomic) IBOutlet UILabel *registerTitleThree;
@property (weak, nonatomic) IBOutlet UILabel *logintTitleOne;
@property (weak, nonatomic) IBOutlet UILabel *loginTitleTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnPayments;

@property (weak, nonatomic) IBOutlet UIButton *btnIngresar;
@property (weak, nonatomic) IBOutlet UIButton *btnYaTengoCuenta;
- (IBAction)goPayment:(id)sender;

- (void)show:(BOOL)show;
- (IBAction)goBack:(id)sender;
- (IBAction)goLogin:(id)sender;
- (IBAction)goRegistry:(id)sender;
- (IBAction)onHideKeyBoard:(id)sender;
- (IBAction)goRegistrationLogin:(id)sender;
- (IBAction)goRegistrationAccess:(id)sender;
- (IBAction)goLoginRecoveryPass:(id)sender;

- (void)closeKeyBoard;

@end

@protocol RegisterDelegate <NSObject>

- (void)RegisterVWCLoginsuccesfull:(BOOL)op;

@optional

- (void)RegisterVWCGoBack;

@end
