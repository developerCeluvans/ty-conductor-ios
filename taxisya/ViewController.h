//
//  ViewController.h
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuVWC.h"
#import "ServiceVWC.h"
#import "AgendaVWC.h"
#import "HistoryVWC.h"
#import "TYServiceProgress.h"

@interface ViewController : UIViewController <RegisterDelegate, MenuVWCDelegate, ServiceVWCDelegate, TYServiceProgressDelegate, AgendaVWCDelegate, HistoryVWCDelegate>

@property (nonatomic, strong) MenuVWC                  *menuVWC;
@property (nonatomic, strong) ServiceVWC               *serviceVWC;
@property (nonatomic, strong) AgendaVWC                *agendaVWC;
@property (nonatomic, strong) HistoryVWC               *history;
@property (nonatomic, strong) Register                *registerVWC;
@property (nonatomic, strong) TYServiceProgress        *tyServiceProgress;
@property (nonatomic, assign) MenuOption               currentMenuOption;
@property (nonatomic, strong) UIAlertView *alertView;

- (void)showViewService;


@end
