//
//  AddressVWC.m
//  taxisya
//
//  Created by NTTak3 on 22/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "AddressVWC.h"
#import <QuartzCore/QuartzCore.h>
#import "TYUsserProfile.h"
#import "Functions.h"


@interface AddressVWC ()



@end

@implementation AddressVWC

@synthesize delegate                        = _delegate;

@synthesize vwSuperVW                       = _vwSuperVW;
@synthesize vwFooter                        = _vwFooter;
@synthesize lbFooter                        = _lbFooter;
@synthesize isVWFooterForEditing            = _isVWFooterForEditing;

@synthesize isDown                          = _isDown;

@synthesize vwOldAddressContainer           = _vwOldAddressContainer;
@synthesize addresOldVWC                    = _addresOldVWC;
@synthesize vwAddressContainer              = _vwAddressContainer;
@synthesize scrvwForm                       = _scrvwForm;
@synthesize btnOldDirections                = _btnOldDirections;
@synthesize lbAddress                       = _lbAddress;
@synthesize lbAddressCity                   = _lbAddressCity;
@synthesize lbAddress1                      = _lbAddress1;
@synthesize txtf2                           = _txtf2;
@synthesize txtf3                           = _txtf3;
@synthesize txtf4                           = _txtf4;
@synthesize txtf5                           = _txtf5;
@synthesize txtf6                           = _txtf6;
@synthesize tyAddress                       = _tyAddress;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil superView:(UIView *)superVW
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.vwSuperVW = superVW;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];

    [self createPanGesture];

    [self setupShadow];




}


-(void)show {
    
}

-(void)show:(BOOL) show {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup{


    [self.lbAddress setFont:UI_FONT_1(18)];
    [self.lbAddressCity setFont:UI_FONT_1(14)];
    [self.lbAddress1 setFont:UI_FONT_1(14)];
    [self.txtf2 setFont:UI_FONT_1(13)];
    [self.txtf3 setFont:UI_FONT_1(13)];
    [self.txtf4 setFont:UI_FONT_1(13)];
    [self.txtf5 setFont:UI_FONT_1(13)];
    [self.txtf6 setFont:UI_FONT_1(13)];

    [self.lbFooter setFont:UI_FONT_1(15)];

    self.isVWFooterForEditing = NO;

    if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){


        [_vwSuperVW setFrame:CGRectMake(0, -(_vwSuperVW.frame.size.height - 100), 320, _vwSuperVW.frame.size.height)];


    }else{

        [_vwSuperVW setFrame:CGRectMake(0, -(_vwSuperVW.frame.size.height - 99), 320, _vwSuperVW.frame.size.height)];


    }


    self.tyAddress = [[TYAddress alloc] init];


}




- (void)createPanGesture{

    _isDown = NO;

    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handlePan:)];
    [self.vwSuperVW addGestureRecognizer:pgr];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    [self.vwFooter addGestureRecognizer:tap];

}


- (void)setupShadow{

    self.vwFooter.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwFooter.layer.shadowOffset = CGSizeMake(0, -3);
    self.vwFooter.layer.shadowOpacity = 0.2f;

}

- (void)handleTap:(UITapGestureRecognizer *)tap{

    if(_isDown){

        [self animateDown:NO];

    }else{

        [self animateDown:YES];

    }

}


-(void)handlePan:(UIPanGestureRecognizer*)pgr;
{
    if (pgr.state == UIGestureRecognizerStateChanged) {

        [self closeKeyBoard:nil];


        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view];


        center = CGPointMake(center.x,
                             center.y + translation.y);
        pgr.view.center = center;
        [pgr setTranslation:CGPointZero inView:pgr.view];


        float max = 47;
        float currenty = self.vwSuperVW.frame.origin.y;

        if(currenty >= max){

            _isDown = YES;

            [_vwSuperVW setFrame:CGRectMake(0, 47, 320, _vwSuperVW.frame.size.height)];

            [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address-close.png"] forState:UIControlStateNormal];
            [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address-close.png"] forState:UIControlStateHighlighted];

            return;

        }


    } else if (pgr.state == UIGestureRecognizerStateEnded || pgr.state == UIGestureRecognizerStateFailed || pgr.state == UIGestureRecognizerStateCancelled){

        float currenty = self.vwSuperVW.frame.origin.y;

        if(currenty < -220 || (_isDown && currenty < 30 && currenty > -160)){

            [self animateDown:NO];

        } else{

            [self animateDown:YES];

        }
    }
}

- (void)animateDown:(BOOL)down{

    if(down){

        _isDown = YES;

        [_delegate AddressVWCIsDown:YES];

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_vwSuperVW setFrame:CGRectMake(0, 47, 320, _vwSuperVW.frame.size.height)];

                         }
                         completion:^(BOOL f){


                         }];

        [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address-close.png"] forState:UIControlStateNormal];
        [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address-close.png"] forState:UIControlStateHighlighted];


    }else{

        [self closeKeyBoard:nil];

        _isDown = NO;

        [_delegate AddressVWCIsDown:NO];

        [UIView animateWithDuration:0.3
                         animations:^(void){


                             if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){


                                 [_vwSuperVW setFrame:CGRectMake(0, -(_vwSuperVW.frame.size.height - 100), 320, _vwSuperVW.frame.size.height)];


                             }else{

                                 [_vwSuperVW setFrame:CGRectMake(0, -(_vwSuperVW.frame.size.height - 99), 320, _vwSuperVW.frame.size.height)];


                             }


                         }
                         completion:^(BOOL f){

                             [self showAddressCreation:YES];

                         }];

        [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address.png"] forState:UIControlStateNormal];
        [_btnOldDirections setImage:[UIImage imageNamed:@"btn-old-address.png"] forState:UIControlStateHighlighted];

    }

}

- (IBAction)showOldAddress:(id)sender{

    [self handleTap:nil];

}


- (IBAction)closeKeyBoard:(id)sender{

        if(_isVWFooterForEditing){



            _isVWFooterForEditing = NO;

            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){

                                 [_vwFooter setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                 [_scrvwForm setContentSize:CGSizeMake(0, _scrvwForm.frame.size.height)];

                             }
                             completion:^(BOOL f){

                                 [_scrvwForm setContentOffset:CGPointMake(0, 0) animated:YES ];

                             }];

        }

    [_txtf2 resignFirstResponder];
    [_txtf3 resignFirstResponder];
    [_txtf4 resignFirstResponder];
    [_txtf5 resignFirstResponder];
    [_txtf6 resignFirstResponder];

}

- (IBAction)onOldAddress:(id)sender{

    if(![TYUsserProfile IsUsserRegistred]){

        [_delegate AddressVWCNeedAuth];

    }else{

        [self closeKeyBoard:nil];

        [self showAddressCreation:NO];

    }

}


-(void)onService:(id)sender {
    
}

- (IBAction)onAddress1:(id)sender{

    [_delegate AddressVWCNeedPickerAddress1];

    [self closeKeyBoard:nil];

}

- (void)setAddressFromLocation:(NSString *)addres1 address2:(NSString *)address2{

    NSArray *array = [addres1 componentsSeparatedByString:@" "];

    NSString *dir1 = nil;
    NSString *dir2 = nil;
    NSString *dir3 = nil;

    for(int i = 0; i < array.count; i++){

        if (i == 0){

            dir1 = [array objectAtIndex:i];

        }else if(i == 1){

            dir2 = [array objectAtIndex:i];

        }else if(i == 2){



        }else if (i == 3){

            dir3 = [array objectAtIndex:i];

        }
    }

    if(dir1)[_lbAddress1 setText:dir1];
    if(dir2)[_txtf2 setText:dir2];
    if(dir3){

        NSArray *array = [dir3 componentsSeparatedByString:@"-"];

        if(array.count >= 2){

            [_txtf3 setText:[array objectAtIndex:0]];

        }else{

            [_txtf3 setText:dir3];

        }

    }

    [self updateFooterLabel];

}

- (void)setAddressFromLocation:(NSString *)addres1 address2:(NSString *)address2 neighborhood:(NSString *)neighborhood
{
    [_txtf6 setText:neighborhood];

    [self setAddressFromLocation:addres1 address2:address2];
}



- (BOOL)currentAddressAreValid{

    if (_txtf5.text.length <= 0) {
        _tyAddress.address5 = @"";
    }

    if(_tyAddress.address1.length > 0 && _tyAddress.address2.length > 0 && _tyAddress.address3.length >
       0 && _tyAddress.address4.length > 0 && _tyAddress.address4.length > 0 )
    {

        return YES;

    }

    return NO;

}

- (void)setAddressFromPicker:(NSString *)address1{

    [_lbAddress1 setText:address1];

    [self updateFooterLabel];

}

- (void)cleanTextFiedls
{
    [_txtf2 setText:@""];
    [_txtf3 setText:@""];
    [_txtf4 setText:@""];
    [_txtf5 setText:@""];
    [_txtf6 setText:@""];

    [self updateFooterLabel];

    [_lbFooter setText:@"Buscando dirección... "];
}

- (void)showAddressCreation:(BOOL)show{

    if(show){

        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             [_vwAddressContainer setTransform:CGAffineTransformMakeTranslation(0, 0)];
//                             [_vwAddressContainer setAlpha:1];
                             [_vwOldAddressContainer setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
//                             [_vwOldAddressContainer setAlpha:0];


                         }
                         completion:^(BOOL f){

                         }];

    }else{

        if(!_addresOldVWC){

            self.addresOldVWC = [[AddressOldVWC alloc] initWithNibName:@"AddressOldVWC" bundle:nil delegate:self];

            [_vwOldAddressContainer addSubview:_addresOldVWC.view];

        }

        [_addresOldVWC show];

        [_vwOldAddressContainer setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];

        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             [_vwAddressContainer setTransform:CGAffineTransformMakeTranslation(- self.view.frame.size.width, 0)];

//                             [_vwAddressContainer setAlpha:0];

                             [_vwOldAddressContainer setTransform:CGAffineTransformMakeTranslation(0, 0)];

//                             [_vwOldAddressContainer setAlpha:1];

                         }
                         completion:^(BOOL f){

                         }];

    }


}

- (void)updateFooterLabel{

    _tyAddress.address1 = _lbAddress1.text;
    _tyAddress.address2 = _txtf2.text;
    _tyAddress.address3 = _txtf3.text;
    _tyAddress.address4 = _txtf4.text;
    _tyAddress.address5 = _txtf5.text;
    _tyAddress.address6 = _txtf6.text;


    NSString *add1 = _lbAddress1.text;
    if(!add1)add1 = @"";
    NSString *add2 = _txtf2.text;
    if(!add2)add2 = @"";
    NSString *add3 = _txtf3.text;
    if(!add3)add3 = @"";
    NSString *add4 = _txtf4.text;
    if(!add4)add4 = @"";
    NSString *add5 = _txtf5.text;
    if(!add5)add5 = @"";
    NSString *add6 = _txtf6.text;
    if(!add6)add6 = @"";

    NSString *fullAddress = [NSString stringWithFormat:@"%@ %@ # %@ - %@ %@ %@", add1, add2, add3, add4, add5, add6];

    [_lbFooter setText:[Functions getCorrectlyAddress:fullAddress]];

}

#pragma mark -
#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [self performSelector:@selector(updateFooterLabel) withObject:nil afterDelay:0.2];

    return YES;


}


- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(!_isVWFooterForEditing){

        _isVWFooterForEditing = YES;

        if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

            [_scrvwForm setContentSize:CGSizeMake(0, _scrvwForm.frame.size.height * 1.3)];

            [_scrvwForm setContentOffset:CGPointMake(0, _txtf2.frame.origin.y - _txtf2.frame.size.height - 145) animated:YES];

        }else{

            [_scrvwForm setContentSize:CGSizeMake(0, _scrvwForm.frame.size.height * 1.5)];

            [_scrvwForm setContentOffset:CGPointMake(0, _txtf2.frame.origin.y - _txtf2.frame.size.height - 70) animated:YES];

        }

        if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

            [UIView animateWithDuration:0.3
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){

                                 [_vwFooter setTransform:CGAffineTransformMakeTranslation(0, -16)];

                             }
                             completion:^(BOOL f){

                             }];


        }else{

            [UIView animateWithDuration:0.4
                                  delay:0.2
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){

                                 [_vwFooter setTransform:CGAffineTransformMakeTranslation(0, -103)];

                             }
                             completion:^(BOOL f){

                             }];


        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{



}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self closeKeyBoard:nil];

    return YES;

}

- (BOOL)textFieldShouldClear:(UITextField *)textField{

    [self performSelector:@selector(updateFooterLabel) withObject:nil afterDelay:0.2];

    return YES;
}

#pragma mark -
#pragma mark AddressOldVWC

- (void)AddressOldVWCAddressSelected:(TYAddress *)address{

    self.tyAddress = address;

    _lbAddress1.text = _tyAddress.address1;
    _txtf2.text = _tyAddress.address2;
    _txtf3.text = _tyAddress.address3;
    _txtf4.text = _tyAddress.address4;
    _txtf5.text = _tyAddress.address5;
    _txtf6.text = _tyAddress.address6;

    [self updateFooterLabel];

    [self showAddressCreation:YES];

}

- (void)AddressOldVWCGoBack{


}


@end
