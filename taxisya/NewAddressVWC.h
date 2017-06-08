//
//  NewAddressVWC.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 8/28/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAddressVWC : UIViewController <UITextFieldDelegate>

//@property (nonatomic, assign) id <NewAddressVWCDelegate>   delegate;

@property (nonatomic, strong) UIView                    *vwSuperVW;
@property (nonatomic, strong) IBOutlet UIView           *vwFooter;
@property (nonatomic, strong) IBOutlet UILabel          *lbFooter;
@property (nonatomic, assign) BOOL                      isVWFooterForEditing;


@property (weak, nonatomic) IBOutlet UITextField *addressName;
@property (weak, nonatomic) IBOutlet UITextField *addressAddress;
@property (weak, nonatomic) IBOutlet UITextField *addressComment;
- (IBAction)saveAddress:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil superView:(UIView *)superVW;

@end
