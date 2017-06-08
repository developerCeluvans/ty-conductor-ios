//
//  UIView+Xib.m
//  GroceryGlee
//
//  Created by Takeshi Kajino Morales on 10/07/12.
//  Copyright (c) 2012 NogardTools. All rights reserved.
//cd 

#import "UIView+Xib.h"

@implementation UIView (Xib)

+ (UIView *)viewFromNib:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (!nibName || [nibName length] == 0) {
        return nil;
    }
    
    UIView *view = nil;
    
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSArray *loadedObjects = [bundle loadNibNamed:nibName owner:nil options:nil];
    view = [loadedObjects lastObject];
    
    return view;
}


@end
