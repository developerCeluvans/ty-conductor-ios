//
//  UIView+FormScroll.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/25/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import "UIView+FormScroll.h"

@implementation UIView (FormScroll)

-(void)scrollToY:(float)y
{
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
}

-(void)scrollToView:(UIView *)view
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y; //15;
    NSLog(@"scrollToView 1 %f",y);
    y -= (y/1.7);
    NSLog(@"scrollToView 2 %f",y);
    y = 254;
    [self scrollToY:-y];
}

-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
}

@end
