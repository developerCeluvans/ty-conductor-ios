//
//  RecoverViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 6/7/16.
//  Copyright © 2016 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RecoverViewController : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *loginTextField;
@property (strong, nonatomic) UIButton *recoverButton;

@end
