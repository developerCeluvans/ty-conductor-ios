//
//  AddressOldItemVWC.h
//  taxisya
//
//  Created by NTTak3 on 24/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAddress.h"

@interface AddressOldItemVWC : UIView

@property (nonatomic, strong) IBOutlet UILabel                  *lbTitle;
@property (nonatomic, strong) IBOutlet UIImageView              *imgvw;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer   *tap;

@property (nonatomic, assign) id                                target;
@property (nonatomic, assign) SEL                               selector;

@property (nonatomic, strong) TYAddress                         *tyAddress;

- (void)setTarget:(id)target selector:(SEL)sel address:(TYAddress *)address;

- (IBAction)onTap:(id)sender;

@end
