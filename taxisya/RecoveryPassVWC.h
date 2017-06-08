//
//  RecoveryPassVWC.h
//  taxisya
//
//  Created by NTTak3 on 8/11/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSLogin.h"

@protocol RecoveryPassVWCDelegate;

@interface RecoveryPassVWC : UIViewController <TYSLoginDelegate>

@property (nonatomic, assign) id <RecoveryPassVWCDelegate>          delegate;

@property (nonatomic, strong) IBOutlet UIView                       *vwEmail;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfEmail;

@property (nonatomic, strong) IBOutlet UIScrollView                 *scrvwCodigo;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfCodigo;
@property (nonatomic, strong) IBOutlet UITextField                  *txtfPass;

@property (nonatomic, strong) TYSLogin                              *tysLogin;

@property (nonatomic, strong) IBOutlet UIView                       *vwLoading;
@property (weak, nonatomic) IBOutlet UILabel *confirmTitle;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtnFinalizar;

@property (weak, nonatomic) IBOutlet UILabel *recoverTitle;
@property (weak, nonatomic) IBOutlet UIButton *recoverBtnFinalizar;

- (void)show:(BOOL)show animated:(BOOL)animated;

@end

@protocol RecoveryPassVWCDelegate <NSObject>
- (void)RecoveryPassGoLogin;
@end
