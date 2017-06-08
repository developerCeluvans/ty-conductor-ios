//
//  QualityService.m
//  taxisya
//
//  Created by NTTak3 on 29/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "QualityService.h"
#import "AppDelegate.h"
#import "HTTPSyncRequest.h"

@interface QualityService ()

@end

@implementation QualityService

@synthesize delegate                = _delegate;
@synthesize lb1                     = _lb1;
@synthesize lb2                     = _lb2;
@synthesize lb3                     = _lb3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<QualityServiceDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.delegate = delegate;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    [_lb1 setFont:UI_FONT_1(20)];
    [_lb2 setFont:UI_FONT_1(20)];
    [_lb3 setFont:UI_FONT_1(17)];

    [_lb1 setText:NSLocalizedString(@"quality_title",nil)];
    [_lb2 setText:NSLocalizedString(@"quality_subtitle",nil)];
    [_lb3 setText:NSLocalizedString(@"quality_message",nil)];
    [_buttonVeryGood setTitle:NSLocalizedString(@"quality_button_very_good",nil) forState:UIControlStateNormal];
    [_buttonOkay setTitle:NSLocalizedString(@"quality_button_okay",nil) forState:UIControlStateNormal];
    [_buttonBad setTitle:NSLocalizedString(@"quality_button_bad",nil) forState:UIControlStateNormal];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack:) name:@"push_close_session" object:nil];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show:(BOOL)show{

    if(show){
        self.view.alpha = 1;
         // 02/05/2016
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] cancelTimers];
    }else{
        // prueba sin animación +
        self.view.alpha = 0;
        [_delegate QualityServiceNeedRemove];
    }

}

-(void) dealloc {
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] cancelTimers];
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] validateSolicitudService];
}

- (IBAction)goBack:(id)sender{
    [self show:NO];
}

- (IBAction)onBueno:(id)sender{
    [self QualityServiceTypePressed:QUALITY_TYPE_BUENO];
    //[self show:NO];
}

- (IBAction)onMuyBueno:(id)sender{
    NSLog(@"Entra al muy bueno al dar cliec");
    [self QualityServiceTypePressed:QUALITY_TYPE_MUY_BUENO];
    //[self show:NO];
}

- (IBAction)onMalo:(id)sender{
    [self QualityServiceTypePressed:QUALITY_TYPE_MALO];
    //[self show:NO];
}

- (void)QualityServiceTypePressed:(NSString *)type{
    NSLog(@"QualityServiceTypePressed ");
    
    [self initTaxiServicesIfNeeded];
    
    //[_tyServiceProgress requestQualityService:type];
    NSLog(@"%@,%@",[TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id");
    NSLog(@"%@,%@",[TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE], @"service_id");
    NSLog(@"%@,%@",[TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE], @"service_id");
    
    NSLog(@"%@,%@",type,@"qualification");
    
    [[[HTTPSyncRequest alloc] init] qualificationService:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                          [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE], @"service_id",
                                                          [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN],@"uuid",
                                                          type,@"qualification",nil] delegate:self];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"call_request_service" object:self userInfo:@{@"data": @"call_request_service"}];
    
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initTaxiServicesIfNeeded{
    
    if(!_tyServiceProgress)
    {
        
        self.tyServiceProgress = [[TYServiceProgress alloc] initWithDelegate:self];
        
    }
    
}

#pragma mark - HTTPRequest Delegate

- (void)didCompleteWithError:(NSError *)error {
    
}

- (void)didCompleteReceiveData:(NSDictionary *)data {
    
}

-(void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {
    NSLog(@"REPONDIENDO %i %@", request, data);
    if (request == 5) {
        long error = [[data objectForKey:@"error"] integerValue];
        if (error == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"call_request_service" object:self userInfo:@{@"data": @"call_request_service"}];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)didCompleteRequest:(int)request withError:(NSError *)error {
    NSLog(@"RESPONDIENDO CON ERROR %i %@",request, error );
    
}

@end
