//
//  QualityService.h
//  taxisya
//
//  Created by NTTak3 on 29/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYUsserProfile.h"
#import "TYServiceProgress.h"


#define QUALITY_TYPE_MUY_BUENO              @"1"
#define QUALITY_TYPE_BUENO                  @"2"
#define QUALITY_TYPE_MALO                   @"3"

@protocol QualityServiceDelegate;

@interface QualityService : UIViewController <TYServiceProgressDelegate,HTTPRequestDelegate>


@property (nonatomic, assign) id <QualityServiceDelegate>               delegate;

@property (nonatomic, strong) IBOutlet UILabel                          *lb1;
@property (nonatomic, strong) IBOutlet UILabel                          *lb2;
@property (nonatomic, strong) IBOutlet UILabel                          *lb3;
@property (weak, nonatomic) IBOutlet UIButton *buttonVeryGood;
@property (weak, nonatomic) IBOutlet UIButton *buttonOkay;
@property (weak, nonatomic) IBOutlet UIButton *buttonBad;
@property (nonatomic, strong) TYServiceProgress        *tyServiceProgress;


- (void)show:(BOOL)show;

- (IBAction)goBack:(id)sender;
- (IBAction)onMuyBueno:(id)sender;
- (IBAction)onBueno:(id)sender;
- (IBAction)onMalo:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<QualityServiceDelegate>)delegate;

@end

@protocol QualityServiceDelegate <NSObject>

- (void)QualityServiceTypePressed:(NSString *)type;

- (void)QualityServiceNeedRemove;

@end
