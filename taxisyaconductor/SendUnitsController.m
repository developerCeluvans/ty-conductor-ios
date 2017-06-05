//
//  SendUnitsController.m
//  taxisyaconductor
//
//  Created by developer on 26/05/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendUnitsController.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"
#import "DirectionService.h"
#import "ServicesViewController.h"
#import "MapViewController.h"

@interface SendUnitsController ()

@end

@implementation SendUnitsController {
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
    //GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Cover the back button (cannot do this in viewWillAppear -- too soon)
    if ( backCover == nil ) {
        backCover = [[UIControl alloc] initWithFrame:CGRectMake( 0, 0, 80, 44)];
#if TARGET_IPHONE_SIMULATOR
        // show the cover for testing
        backCover.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.15];
#endif
        [backCover addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar addSubview:backCover];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [backCover removeFromSuperview];
    backCover = nil;
    [self.timerPosition invalidate];
    self.timerPosition = nil;
    
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"SendUnitsController viewDidLayoutSubviews w: %f h: %f",self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - statusService
-(void) checkStatusService {
    
    NSLog(@"checkStatusService");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId};
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    
    NSLog(@"checkStatusService - %@ %@",driverId, serviceId);
    [api serviceStatus:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"serviceStatus response: service_id: %@ status_id %@",
                  dictionary[@"id"],
                  dictionary[@"status_id"]);
            
            long statusId = [dictionary[@"status_id"] integerValue];
            
            if (statusId >=6) {
                NSLog(@"service cancelado");
                [self.timer invalidate];
                
                // show toast
                if (statusId != 8) {
                    if (_delegate && [_delegate respondsToSelector:@selector(showToastWhenServiceCancelled:)]) {
                        [_delegate showToastWhenServiceCancelled:statusId];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"serviceStatus error: %@",response);
        }
    }];
}


#pragma mark - Utils
-(void)readServices {
    self.servicesArray = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.servicesArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"services"]] ;
    NSLog(@"  readServices %ld",(unsigned long)[self.servicesArray count]);
}

-(void)saveServices {
    // save array
    NSLog(@"    saveServices");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.servicesArray];
    [defaults setObject:data forKey:@"services"];
    [defaults synchronize];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
self.sendUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)+5, screenHeight - 60, (screenWidth - 30) / 2, 50)];
[self.sendUnitsButton setTitle:NSLocalizedString(@"enviar",nil) forState:UIControlStateNormal];
[self.sendUnitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[self.sendUnitsButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
[self.sendUnitsButton addTarget:self action:@selector(sendUnitsAction:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.sendUnitsButton];
[self.sendUnitsButton setHidden:YES];

self.noUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)+5, screenHeight - 60, (screenWidth - 30) / 2, 50)];
[self.noUnitsButton setTitle:NSLocalizedString(@"enviar",nil) forState:UIControlStateNormal];
[self.noUnitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
[self.noUnitsButton setBackgroundColor:[UIColor colorWithRed:0.211f green:0.211f blue:0.211f alpha:1.0f]];
[self.noUnitsButton addTarget:self action:@selector(noUnitsAction:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.sendUnitsButton];
[self.noUnitsButton setHidden:NO];
    
self.units = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 190, 280, 38)];
self.units.borderStyle = UITextBorderStyleRoundedRect;
self.units.autocapitalizationType = UITextAutocapitalizationTypeNone;
[self.units setPlaceholder:NSLocalizedString(@"Unidades",nil)];
self.units.delegate = self;
self.units.keyboardType = UIKeyboardTypeDecimalPad;
self.units.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}


-(void)noUnitsAction:(id)sender{
    
    int unit = 27;
    
    
    if(_units ==  NULL){
        
        [_sendUnitsButton setHidden:NO];
        [_noUnitsButton setHidden:YES];
        
    }if (_units <= unit){
    
        UIAlertController *alert= [UIAlertController
                            alertControllerWithTitle:@"Importante"
                            message:@"Digita las unidades superiores a 28"
                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Enviar" style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action){
                            UITextField *textField = alert.textFields[0];
                            NSLog(@"no units", textField.text);
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        [_sendUnitsButton setHidden:YES];
        [_noUnitsButton setHidden:NO];
    }
    
}

-(void)sendUnitsAction:(id)sender {
    
    [_sendUnitsButton setHidden:NO];
    [_noUnitsButton setHidden:YES];
    
    NSLog(@"finishAction -");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [NSString stringWithFormat:@"%ld",self.service.serviceId];
    NSString *lat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
    NSString *units =[NSString stringWithFormat:@"%d",self.service.units];
    
#if TARGET_IPHONE_SIMULATOR
    lat = @"4.7434892";
    lng = @"-74.0572775";
#endif
    //[self readServices];
    NSDictionary *params = @{@"driver_id":driverId,
                             @"service_id": serviceId,
                             @"to_lat":lat,
                             @"units":units,
                             @"to_lng":lng};
    NSLog(@"params %@",params);
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api serviceFinish:params success:^(BOOL success, id response) {
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)response;
            NSLog(@"serviceFinish response: %@",dictionary);
            
            [self.timer invalidate];
            
            // marcar estado servicio
            long index = [self.servicesArray indexOfObject:self.service];
            
            self.service.statusId = 5;
            [self.servicesArray replaceObjectAtIndex:index withObject:self.service];
            
            [self saveServices];
        }
        else {
            [self.view makeToast:NSLocalizedString(@"error_finish",nil)];
            
            NSLog(@"serviceFinish error: %@",response);
        }
        [self.timer invalidate];
        
        // check si servicio es
        if (self.isRecover) {
            [self.locationManager stopUpdatingLocation];
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            
            ServicesViewController *servicesVC = [[ServicesViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:servicesVC animated:NO];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}


@end

