//
//  CustomProgressView.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 8/25/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgressView : UIView {
    float current_value;
    float new_to_value;

    UILabel *ProgressLbl;

    id delegate;

    BOOL IsAnimationInProgress;
}

@property id delegate;
@property float current_value;

- (id)init;
- (void)setProgress:(NSNumber*)value;

@end

@protocol CustomProgressViewDelegate
- (void)didFinishAnimation:(CustomProgressView*)progressView;

@end
