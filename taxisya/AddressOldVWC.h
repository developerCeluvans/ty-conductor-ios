//
//  AddressOldVWC.h
//  taxisya
//
//  Created by NTTak3 on 24/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAddress.h"
#import "TYSUsser.h"

@protocol AddressOldVWCDelegate;

@interface AddressOldVWC : UIViewController <TYSUsserDelegate>

@property (nonatomic, assign) id <AddressOldVWCDelegate>    delegate;

@property (nonatomic, strong) IBOutlet UILabel              *lbMis;
@property (nonatomic, strong) IBOutlet UILabel              *lbDirecciones;
@property (nonatomic, strong) IBOutlet UIScrollView         *scrvwDirs;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loading;

@property (nonatomic, strong)TYSUsser                       *tysUsser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<AddressOldVWCDelegate>)delegate;
- (void)show;
- (void)setAddress:(NSMutableArray *)maDirs;


@end

@protocol AddressOldVWCDelegate <NSObject>

- (void)AddressOldVWCGoBack;
- (void)AddressOldVWCAddressSelected:(TYAddress *)address;

@end
