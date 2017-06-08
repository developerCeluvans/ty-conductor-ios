//
//  UIView+Xib.h
//  GroceryGlee
//
//  Created by Takeshi Kajino Morales on 10/07/12.
//  Copyright (c) 2012 NogardTools. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Xib)

+ (UIView *)viewFromNib:(NSString *)nibName bundle:(NSBundle *)bundle;

@end
