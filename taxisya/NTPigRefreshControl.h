//
//  NTPigRefreshControl.h
//  Opinions
//
//  Created by NTTak3 on 12/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTPigRefreshControl : UIControl

- (id)initInScrollView:(UIScrollView *)scrollView;

- (void)stopAnimating;

@end
