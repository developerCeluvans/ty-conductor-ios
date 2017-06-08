//
//  AddressOldItemVWC.m
//  taxisya
//
//  Created by NTTak3 on 24/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "AddressOldItemVWC.h"
#import <objc/message.h>

@interface AddressOldItemVWC ()

@end

@implementation AddressOldItemVWC

@synthesize imgvw           = _imgvw;
@synthesize tap             = _tap;
@synthesize lbTitle         = _lbTitle;

@synthesize target          = _target;
@synthesize selector        = _selector;

@synthesize tyAddress       = _tyAddress;


- (void)setTarget:(id)target selector:(SEL)sel address:(TYAddress *)address{
    
    self.selector = sel;
    self.target = target;
    self.tyAddress = address;
    
    [self setupView];
    
}

- (void)setupView{
    
//    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeTap:)];
//    self.tap.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:_tap];
    
    [_lbTitle setText:[NSString stringWithFormat:@"%@ %@ # %@ - %@ %@ %@", _tyAddress.address1, _tyAddress.address2,    _tyAddress.address3, _tyAddress.address4, _tyAddress.address5, _tyAddress.address6]];

}

- (void)makeTap:(UITapGestureRecognizer *)tap{
    
    if(tap.state == UIGestureRecognizerStateChanged || tap.state == UIGestureRecognizerStateEnded){
        
        [_imgvw setImage:[UIImage imageNamed:@"address-old.png"]];
    
    }else{
        
        [_target performSelector:NSSelectorFromString(@"itemPressed:") withObject:self afterDelay:0];
        
        
        [_imgvw setImage:[UIImage imageNamed:@"address-old-over.png"]];
        
    }
    
}

- (void)onTap:(id)sender{
    
    [_target performSelector:_selector withObject:self afterDelay:0];

}

@end
