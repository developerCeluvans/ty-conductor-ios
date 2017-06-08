//
//  AddressVWC.h
//  taxisya
//
//  Created by NTTak3 on 22/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressOldVWC.h"


@protocol AddressVWCDelegate;

@interface AddressVWC : UIViewController <UITextFieldDelegate, AddressOldVWCDelegate>

@property (nonatomic, assign) id <AddressVWCDelegate>   delegate;

@property (nonatomic, strong) UIView                    *vwSuperVW;
@property (nonatomic, strong) IBOutlet UIView           *vwFooter;
@property (nonatomic, strong) IBOutlet UILabel          *lbFooter;
@property (nonatomic, assign) BOOL                      isVWFooterForEditing;

@property (nonatomic, assign) BOOL                      isDown;

@property (nonatomic, strong) IBOutlet UIView           *vwAddressContainer;
@property (nonatomic, strong) IBOutlet UIView           *vwOldAddressContainer;
@property (nonatomic, strong) AddressOldVWC             *addresOldVWC;
@property (nonatomic, strong) IBOutlet UIScrollView     *scrvwForm;
@property (nonatomic, strong) IBOutlet UIButton         *btnOldDirections;
@property (nonatomic, strong) IBOutlet UILabel          *lbAddress;
@property (nonatomic, strong) IBOutlet UILabel          *lbAddressCity;
@property (nonatomic, strong) IBOutlet UILabel          *lbAddress1;
@property (nonatomic, strong) IBOutlet UITextField      *txtf2;
@property (nonatomic, strong) IBOutlet UITextField      *txtf3;
@property (nonatomic, strong) IBOutlet UITextField      *txtf4;
@property (nonatomic, strong) IBOutlet UITextField      *txtf5;
@property (nonatomic, strong) IBOutlet UITextField      *txtf6;
@property (nonatomic, strong) TYAddress                 *tyAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil superView:(UIView *)superVW;

- (IBAction)showOldAddress:(id)sender;
//List of address
- (IBAction)onOldAddress:(id)sender;

- (IBAction)onService:(id)sender;

- (IBAction)onAddress1:(id)sender;

- (void)setAddressFromLocation:(NSString *)addres1 address2:(NSString *)address2;

- (void)setAddressFromLocation:(NSString *)addres1 address2:(NSString *)address2 neighborhood:(NSString *)neighborhood;

- (BOOL)currentAddressAreValid;

- (void)setAddressFromPicker:(NSString *)address1;

- (void)cleanTextFiedls;


@end

@protocol AddressVWCDelegate <NSObject>

- (void)AddressVWCIsDown:(BOOL)down;
- (void)AddressVWCNeedPickerAddress1;
- (void)AddressVWCNeedAuth;

@end
