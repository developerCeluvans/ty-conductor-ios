//
//  RequestServiceVWC.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 9/4/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressView.h"

@protocol RequestServiceDelegate <NSObject>

- (void)actionCancelService;

@end


@interface RequestServiceVWC : UIViewController <CustomProgressViewDelegate>
{
 CustomProgressView *customProgressView;
}


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property(retain) CALayer *mask;

@property (nonatomic, assign) id <RequestServiceDelegate> delegate;

@property (nonatomic, strong) UIView                    *vwSuperVW;
@property (nonatomic, strong) IBOutlet UIView           *vwFooter;
@property (nonatomic, strong) IBOutlet UILabel          *lbFooter;
@property (nonatomic, assign) BOOL                      isVWFooterForEditing;

@property (weak, nonatomic) IBOutlet UITextField *addressName;
@property (weak, nonatomic) IBOutlet UITextField *addressAddress;
@property (weak, nonatomic) IBOutlet UITextField *addressComment;

- (void)show:(BOOL)show;
- (void)show:(BOOL)show animated:(BOOL)animated;

@end
