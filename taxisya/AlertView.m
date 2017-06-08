//
//  AlertView.m
//  taxisya
//
//  Created by Guillermo Blanco on 01/08/14.
//  Copyright (c) 2014 imaginamos. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

- (id)initWithTitle:(NSString *)title {
    self = [super initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self setValue:progress forKey:@"accessoryView"];
        [progress startAnimating];
    }
    return self;
}

@end
