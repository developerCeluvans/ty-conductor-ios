//
//  ViewController.m
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AlertView.h"

@interface ViewController ()
- (void)createViews;
@end

@implementation ViewController

@synthesize menuVWC             = _menuVWC;
@synthesize serviceVWC          = _serviceVWC;
@synthesize agendaVWC           = _agendaVWC;
@synthesize history             = _history;
@synthesize tyServiceProgress   = _tyServiceProgress;


- (void)viewDidLoad {

    [super viewDidLoad];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    [self.view.layer setCornerRadius:10.0f];

    [self createViews];

    [self initTaxiServicesIfNeeded];

    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createViews{

    self.menuVWC = [[MenuVWC alloc] initWithNibName:@"MenuVWC" bundle:nil];
    self.menuVWC.delegate = self;
    [self.view addSubview:_menuVWC.view];

    if(!self.serviceVWC){

        self.serviceVWC = [[ServiceVWC alloc] initWithNibName:@"ServiceVWC" bundle:nil];

        self.serviceVWC.delegate = self;

        [self.view addSubview:self.serviceVWC.view];

        _serviceVWC.view.alpha = 0;

    }

}

- (void)showAlertWithMessage:(NSString *)msg tag:(int)tag{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"Aceptar"
                                           otherButtonTitles:nil];

    alert.tag = tag;
    [alert show];

}

- (void)showViewService{
/*
    if(!self.serviceVWC.loadingVWC.serviceAreFounded){
        NSLog(@"ENCUENTRA MENU SERVICIOO 2-------------------------------------");
        [self MenuVWCOptionPressed:MenuOptionService];
        [self.serviceVWC showLoadingService:YES];
    }else{
        NSLog(@"NO ENCUENTRA SERVICIOO 3-------------------------------------");
    }
*/
    [self MenuVWCOptionPressed:MenuOptionService];
    [self.serviceVWC showLoadingService:YES];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark -
#pragma mark MenuVWCDelegate

- (void)MenuVWCOptionPressed:(MenuOption)option{

    self.currentMenuOption = option;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"VERSION" object:nil];

    if(option == MenuOptionHistory)
    {

        if(!self.history)
        {

            self.history = [[HistoryVWC alloc] initWithNibName:@"HistoryVWC" bundle:nil];
            [self.view addSubview:self.history.view];
            self.history.delegate = self;

        }

        [self.view bringSubviewToFront:_history.view];
        [_history show:YES];


    }else if (option == MenuOptionService){
//        self.alertView = [[AlertView alloc] initWithTitle:NSLocalizedString(@"string_verifing",nil)];
//        [self.alertView show];

        if(!self.serviceVWC)
        {
            NSLog(@"Entra a crear el serviceVWC -------------------------------");
            self.serviceVWC = [[ServiceVWC alloc] initWithNibName:@"ServiceVWC" bundle:nil];
            [self.view addSubview:self.serviceVWC.view];
        }
        NSLog(@"Despues de crear el serviceVWC -------------------------------");

        [self.view bringSubviewToFront:_serviceVWC.view];
        [self.serviceVWC showAnimated];


    }else if (option == MenuOptionAgend){

        if(!self.agendaVWC){

            self.agendaVWC = [[AgendaVWC alloc] initWithNibName:@"AgendaVWC" bundle:nil];
            self.agendaVWC.delegate = self;
            [self.view addSubview:self.agendaVWC.view];

        }

        [self.view bringSubviewToFront:_agendaVWC.view];
        [_agendaVWC show:YES];

    }else if (option == MenuOptionPerfil){

        if(!self.registerVWC){

            self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
            self.registerVWC.delegate = self;
            [self.view addSubview:self.registerVWC.view];

        }

        [self.view bringSubviewToFront:_registerVWC.view];
        [_registerVWC show:YES];

    }

}


#pragma mark -
#pragma mark - ServiceDelegate

- (void)initTaxiServicesIfNeeded{

    if(!_tyServiceProgress)
    {

        self.tyServiceProgress = [[TYServiceProgress alloc] initWithDelegate:self];

    }

}

- (void)ServiceVWCRequestService:(TYAddress *)address
{

    [self initTaxiServicesIfNeeded];

    [_tyServiceProgress requestServiceWithAddress:address];

}

- (void)ServiceVWCCancelService {

    [self initTaxiServicesIfNeeded];
    [_tyServiceProgress requestCancerService];

}

- (void)ServiceVWCCancelServiceAutomatic {

    [self initTaxiServicesIfNeeded];

//    [_tyServiceProgress requestCancerService];

}

- (void)ServiceVWQualityOptionPressed:(NSString *)option{

    [self initTaxiServicesIfNeeded];

    [_tyServiceProgress requestQualityService:option];

}

- (void)ServiceVWCUpdateStatusServiceIfHave{

    [_tyServiceProgress checkServicePendingIfNeeded];

}

#pragma mark -
#pragma mark - TYServiceProgressDelegate

- (void)TYServiceProgressFailConnectionInRequestType:(TYSTaxiType)type{

    if(type == TYSTaxiTypeRequestService)
    {

        [_serviceVWC operatorCancelServiceWithAlert:NO];

    }else{



    }

    [self showAlertWithMessage:@"Verifica tu conexión a internet" tag:0];

}


- (void)TYServiceProgressUpdateTaxiInfo:(TYTaxiProfile *)profile{

//    [self showViewService];
//    [self.serviceVWC showLoadingService:YES];

    [_serviceVWC setTaxiProfile:profile];

}

- (void)TYServiceProgressOperatorCancelTheService{

    [_serviceVWC operatorCancelServiceWithAlert:YES];

}

- (void)TYServiceProgressOperatorCancelForDriverTheService{

    [_serviceVWC operatorCancelForDriverServiceWithAlert:YES];

}
- (void)TYServiceProgressTaxiAreWaitingForUsser{

    [_serviceVWC taxiAreWaitinForUsser];



}

#pragma mark -
#pragma mark - AgendaVWCDelegate

- (void)AgendaVWCNeedRemove{

//    [_agendaVWC.view removeFromSuperview];
//    self.agendaVWC = nil;

}

#pragma mark -
#pragma mark - HistoryVWCDelegate

- (void)HistoryVWCNeedRemove{

    [self.history.view removeFromSuperview];
    self.history = nil;

}

- (void)RegisterVWCLoginsuccesfull:(BOOL)op {
    NSLog(@"Entra al registro");
}

@end

