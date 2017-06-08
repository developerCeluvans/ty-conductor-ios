//
//  UIView+FormScroll.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/25/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;

@end
