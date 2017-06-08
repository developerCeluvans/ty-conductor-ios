//
//  AppDelegate.m
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "AppDelegate.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TYUsserProfile.h"
#import "HTTPSyncRequest.h"
#import "JSON.h"
#import "MenuVWC.h"
//#import <PaymentezSDK/PaymentezSDK-Swift.h>

@implementation AppDelegate

NSString *idTaxista;

static BOOL receiveNotification = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [Fabric with:@[[Crashlytics class]]];
    // desarrollo
    //[PaymentezSDKClient setEnvironment:@"TAXISYA" secretKey:@"oDX4b0Yk4usp0ptEf1XFK00KQSxAgV" testMode:YES];
     // producción
    //[PaymentezSDKClient setEnvironment:@"TAXISYA" secretKey:@"jN2Dk59eDX1h7W7NtiV3YYbzCFSHRY" testMode:NO];

    //[GMSServices provideAPIKey:@"AIzaSyAJZPs0Tz4zcgdtLm69R7JLdlKM4fSvzsk"];
    [GMSServices provideAPIKey:@"AIzaSyD9VwkKUjLgFKOQ5FX9zEoyTiAbN0095jU"];

  
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    self.window.rootViewController = self.viewController;
    MenuVWC *menuVWC = [[MenuVWC alloc] initWithNibName:@"MenuVWC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:menuVWC];
    menuVWC.callRequestServiceOption = NO;
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];


// TEST SIN PUSH
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }

    NSLog(@"%@", [[[NSUUID alloc] init] UUIDString]);

//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    if(IS_IOS8){
//        [locationManager requestWhenInUseAuthorization];
//        [locationManager requestAlwaysAuthorization];
//    }
//    [locationManager startUpdatingLocation];


    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    if(remoteNotif){

        [self application:application didReceiveRemoteNotification:	remoteNotif];

    }

    [self deleteTaxiAccepted];
    [self deleteTaxiArrived];
    [self deleteServiceQualified];

    [self validateSession];

    self.isArrived = FALSE;

    return YES;
}

- (void)hideKeyBoard{

    [self.window endEditing:YES];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    receiveNotification = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_hide_keyboard" object:nil userInfo:nil];

    [self setRequestInBackground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [self hideKeyBoard];

    [self performSelector:@selector(update_Profile) withObject:Nil afterDelay:1];

    [self validateVersion];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateVersion) name:@"VERSION" object:nil];

//    [self validateSolicitudService];
    [self getServiceCurrent];
    [self validateSession];

    [self delRequestInBackground];
    //[TYUsserProfile SetUsserInfo:@"" ForKey:USSER_LAST_SERVICE];
}

- (void)validateVersion {
    [[[HTTPSyncRequest alloc] init] validateVersion:self];
}

- (void)update_Profile {
    if(!receiveNotification){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_map_address" object:nil userInfo:nil];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application{
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {

    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"Tocken es %@", token);
    if(token && token.length > 10)
    {

        NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

        dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSLog(@"Tocken asignado %@", dt);
        [TYUsserProfile SetUsserInfo:dt ForKey:USSER_DEVICE_PUSH_TOKEN];

    }

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
	NSLog(@" XXX %s Failed to get token, error: %@", __FUNCTION__, [error localizedDescription]);
}

- (void) notificationConfirm:(NSDictionary *)userInfo {

    id kind_id = [[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"kind_id"];

    idTaxista = (NSString*)[[[[userInfo
                               objectForKey:@"aps"]
                               objectForKey:@"extra"]
                               objectForKey:@"driver"]
                               objectForKey:@"id"];

    NSInteger kind_id_num = [kind_id integerValue];

    if(kind_id_num == 2 || kind_id_num == 4 || kind_id_num == 5){

        double delayInSeconds = 1;


        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.viewController showViewService];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_confirm" object:nil userInfo:userInfo];
        });

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_confirm" object:nil userInfo:userInfo];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"service_alert_timeout_title",nil)
                                      
                                                                message:NSLocalizedString(@"service_alert_timeout_message",nil)
                                                               delegate:nil cancelButtonTitle:NSLocalizedString(@"service_alert_timeout_accept",nil) otherButtonTitles:nil, nil];
    
    
    [notificationAlert show];
    // NSLog(@"didReceiveLocalNotification");
}

- (void)showNewService:(NSDictionary *)userInfo {
    [self.viewController showViewService];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_confirm" object:nil userInfo:userInfo];
}

- (void)cancelTimers {
    [self.validateStatusTimer invalidate];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

        // Receive notification
        NSLog(@"Recibe la Push ----------------------------------------------------------");
        //NSLog(@"Recibe la Push %@", userInfo);
        receiveNotification = YES;
        id num = [[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"push_type"];
        long push_type = [num integerValue];
        NSLog(@"remote notification - push_type = %ld",push_type);

        switch (push_type){
            case SISTEM_CLOSE_SESSION:
                [self showCloseSession];
                break;
            case SISTEM_MESSAGE:
                [self showMessage:[[userInfo objectForKey:@"aps"] objectForKey:@"message"]];
                break;

            case CONFIRM_SERVICE:
                if ([self showedTaxiAccepted]) {

                    NSLog(@"userInfo %@",userInfo);
                    NSLog(@"userInfo service_id %@", [[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"]);

                    [self deleteServiceQualified];
                    [self deleteServiceCancelled];
                    [TYUsserProfile SetUsserInfo:[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"]  ForKey:USSER_LAST_SERVICE];
                    //[TYUsserProfile SetUsserInfo:data[@"user_id"] ForKey:USSER_ID];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_confirm_service" object:nil userInfo: [[userInfo objectForKey:@"aps"] objectForKey:@"extra"] ];
                    self.isArrived = FALSE;

                }
                break;

            case TAXI_GO:
                NSLog(@"TAXI_GO %@",userInfo);
                break;

            case TAXI_ARRIVED:
                if ([self showedTaxiArrived]) {

                    NSLog(@"TaixsyaUsuarios good -    [4] SERVICE %@ ",[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"]);
                    
                    NSLog(@"TaixsyaUsuarios -    [4] SERVICE %@ ", [[userInfo objectForKey:@"aps"] objectForKey:@"service_id"]);
                    [self deleteTaxiAccepted];
                    [self confirmTaxiArrived];
                    [self deleteServiceQualified];
                    [self deleteServiceCancelled];
                    [TYUsserProfile SetUsserInfo:[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"] ForKey:USSER_LAST_SERVICE];
                    //[TYUsserProfile SetUsserInfo:data[@"user_id"] ForKey:USSER_ID];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_arrived" object:nil userInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] ];

                    [self taxiArrived];
                    self.isArrived = TRUE;
                }
                break;

            case DRIVER_FINALIZATION:
                self.isArrived = FALSE;
                [self cancelTimers];
                [self deleteTaxiAccepted];
                [self deleteTaxiArrived];
                [self deleteServiceCancelled];
                
                NSLog(@"TaixsyaUsuarios good -    [5] SERVICE %@ ",[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"]);
                NSLog(@"TaixsyaUsuarios -    [5] SERVICE %@ ", [[userInfo objectForKey:@"aps"] objectForKey:@"service_id"] );
                NSLog(@"STATUS 5 data service_id %@",[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"] );
                
                if ( [[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"qualification"]  isKindOfClass:[NSNull class]]){
                    [self cancelTimers];
                    [self confirmServiceQualification];
                    [TYUsserProfile SetUsserInfo:[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"service_id"] ForKey:USSER_LAST_SERVICE];
                    [TYUsserProfile SetUsserInfo:[[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"user_id"] ForKey:USSER_ID];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_finish_service" object:nil userInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] ];
                }
                else {
                    NSLog(@"Verifica otro servicio previo calificado");
                    [TYUsserProfile SetUsserInfo:@"0" ForKey:USSER_LAST_SERVICE];
                }
                break;

            case DRIVER_CANCEL_SERVICE:
                NSLog(@"RECIBE UNA NOTIFICACION DRIVER_CANCEL---------------------------------------------------------------");

                if ([self showedServiceCancelled]) {
                    self.isArrived = FALSE;
                    [self cancelTimers];

                    [self deleteTaxiAccepted];
                    [self deleteTaxiArrived];
                    [self deleteServiceCancelled];

                    [self confirmServiceCancelled];
                    [self deleteServiceQualified];
                    NSLog(@"SE CANCELO SIN NOTIFICACOIN 1");
                    NSLog(@"TaixsyaUsuarios -    [8] SERVICE %@ ", [[userInfo objectForKey:@"aps"] objectForKey:@"service_id"] );
                    
                    [TYUsserProfile SetUsserInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"service_id"] ForKey:USSER_LAST_SERVICE];
                    //[TYUsserProfile SetUsserInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"user_id"] ForKey:USSER_ID];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_driver_cancel_service" object:nil userInfo:[self createDataPush:userInfo pushType:@"8"]];
                }
                break;


            case SISTEM_CANCEL_SERVICE:
                NSLog(@"RECIBE UNA NOTIFICACION SISTEM_CANCEL---------------------------------------------------------------");
//                [self cancelTimers];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:userInfo];
                break;
            default:
                break;
        }
}

- (void)taxiArrived {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"El taxi ha llegado" message:nil delegate:self cancelButtonTitle:@"Entendido" otherButtonTitles:nil, nil];
    [alertView setTag:102];
    [alertView show];
    [self taxiTanks];
}

-(void)taxiTanks {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_arrived_alert" object:nil];
}

- (void)showCloseSession {
    if([TYUsserProfile IsUsserRegistred]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sesión Cerrada" message:@"¡Se ha iniciado sesión desde otro dispositivo!" delegate:nil cancelButtonTitle:@"Entendido" otherButtonTitles:nil];
        [alertView show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_close_session" object:nil];
        [TYUsserProfile RemoveUsserWithUsser];
    }
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Información" message:message delegate:nil cancelButtonTitle:@"Cerrar" otherButtonTitles:nil];
    [alertView show];
}

- (void)didCompleteRequest:(int)request withError:(NSError *)error {
    // TOTO: ver de quitar esta alerta cuando se agrgue el nuevo chequeo
//    [self.viewController.alertView dismissWithClickedButtonIndex:0 animated:YES];
//    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
//    self.alertView = [[UIAlertView alloc] initWithTitle:@"Ocurrió un error de conexión" message:@"No está conectado a Internet. Comprueba tu configuración de red." delegate:nil cancelButtonTitle:@"Entendido" otherButtonTitles:nil];
//    [self.alertView show];
    NSLog(@"didCompleteRequest error de conexión");
}

- (void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {
    //NSLog(@"REPONDIENDO %@", data);
    [self.viewController.alertView dismissWithClickedButtonIndex:0 animated:YES];
    if(request == 0){
        int userVersion = [[data[@"userVersions"][0][@"version"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        int bundleVersion = [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        NSLog(@"Bundle Version %d User Version %d", bundleVersion, userVersion);

        if(bundleVersion < userVersion){
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"¡Actualización disponible!" message:@"Hay disponible una nueva versión de Taxisya" delegate:self cancelButtonTitle:@"Actualizar" otherButtonTitles:nil];
            [alerView setTag:0];
            [alerView show];
        }

    }else if(request == 1){

        [self parseService:data];

    }
    else if(request == 3){
        NSLog(@"DATOS LOGIN %@", data);
        if(![data[@"active"] boolValue]){
            //[self showCloseSession];
        }
    }
}

-(void)parseService:(NSDictionary *)data {
    NSLog(@"parseService ini %@",data);

    //if([self isPendingRequestInBackground]) return;
    
    long statusId = [[data objectForKey:@"status_id"] integerValue];
    NSLog(@"parseService ini %ld",statusId);

    if (statusId < 6) {
        if([self isPendingRequestInBackground]) return;
    }
    
    switch (statusId) {
        case SISTEM_CLOSE_SESSION:
            [self showCloseSession];
            break;

        case 2:
            if ([self showedTaxiAccepted]) {
                NSLog(@"TaixsyaUsuarios -    [2] SERVICE %@ ", data[@"id"]);
                //[self notificationConfirm:[self createDataPush:data pushType:@"4"]];
                //[self confirmTaxiAccepted];
                [self deleteServiceQualified];
                [self deleteServiceCancelled];
                [TYUsserProfile SetUsserInfo:data[@"id"] ForKey:USSER_LAST_SERVICE];
                [TYUsserProfile SetUsserInfo:data[@"user_id"] ForKey:USSER_ID];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_confirm_service" object:nil userInfo:data];
                self.isArrived = FALSE;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_position" object:nil userInfo:data[@"driver"]];
            break;

        case 4:
            if ([self showedTaxiArrived]) {
                NSLog(@"TaixsyaUsuarios -    [4] SERVICE %@ ", data[@"id"]);
                [self deleteTaxiAccepted];
                [self confirmTaxiArrived];
                [self deleteServiceQualified];
                [self deleteServiceCancelled];
                [TYUsserProfile SetUsserInfo:data[@"id"] ForKey:USSER_LAST_SERVICE];
                [TYUsserProfile SetUsserInfo:data[@"user_id"] ForKey:USSER_ID];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_arrived" object:nil userInfo:data];

                [self taxiArrived];
                self.isArrived = TRUE;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_position" object:nil userInfo:data[@"driver"]];
            break;

        case 5:
            self.isArrived = FALSE;
            [self cancelTimers];
            [self deleteTaxiAccepted];
            [self deleteTaxiArrived];
            [self deleteServiceCancelled];
            NSLog(@"TaixsyaUsuarios -    [5] SERVICE %@ ", data[@"id"]);
            NSLog(@"STATUS 5 data service_id %@", data[@"id"]);

            if ([data[@"qualification"] isKindOfClass:[NSNull class]]){
                [self cancelTimers];
                [self confirmServiceQualification];
                [TYUsserProfile SetUsserInfo:data[@"id"] ForKey:USSER_LAST_SERVICE];
                [TYUsserProfile SetUsserInfo:data[@"user_id"] ForKey:USSER_ID];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_taxi_finish_service" object:nil userInfo:data];
            }
            else {
                NSLog(@"Verifica otro servicio previo calificado");
                [TYUsserProfile SetUsserInfo:@"0" ForKey:USSER_LAST_SERVICE];
            }
            break;

        case 6:
            NSLog(@"STATUS 6");
            if ([self showedServiceCancelled]) {
            self.isArrived = FALSE;
                
            [self cancelTimers];
            [self confirmServiceCancelled];
            [self deleteTaxiAccepted];
            [self deleteTaxiArrived];
            [self deleteServiceQualified];
            [self deleteServiceCancelled];
            NSLog(@"TaixsyaUsuarios -    [6] SERVICE %@ ", data[@"id"]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_user_cancel_service" object:nil userInfo:[self createDataPush:data pushType:@"6"]];
            }
            break;

        case 7:
            if ([self showedServiceCancelled]) {
                self.isArrived = FALSE;
                [self cancelTimers];


                [self confirmServiceCancelled];
                [self deleteTaxiAccepted];
                [self deleteTaxiArrived];
                [self deleteServiceQualified];
                [self deleteTaxiArrived];
                NSLog(@"SE CANCELO SIN NOTIFICACOIN 1");
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:[self createDataPush:data pushType:@"8"]];
                NSLog(@"TaixsyaUsuarios -    [7] SERVICE %@ ", data[@"id"]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:[self createDataPush:data pushType:@"7"]];
            }
            break;

        case 8:
            if ([self showedServiceCancelled]) {
                self.isArrived = FALSE;
                [self cancelTimers];

                [self deleteTaxiAccepted];
                [self deleteTaxiArrived];
                [self deleteServiceCancelled];

                [self confirmServiceCancelled];
                [self deleteServiceQualified];
                NSLog(@"SE CANCELO SIN NOTIFICACOIN 1");
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:[self createDataPush:data pushType:@"8"]];
                NSLog(@"TaixsyaUsuarios -    [8] SERVICE %@ ", data[@"id"]);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push_driver_cancel_service" object:nil userInfo:[self createDataPush:data pushType:@"8"]];
            }
            break;



        default:
            break;
    }

}

- (NSDictionary *)createDataPush:(NSDictionary *)dataRequest pushType:(NSString *)typePush {
    //NSDictionary *driverData = [NSDictionary dictionaryWithObjectsAndKeys:dataRequest[@"driver_id"], @"id", nil];
    NSDictionary *driverData = dataRequest[@"driver"];
    NSDictionary *extraInfo = [NSDictionary dictionaryWithObjectsAndKeys:driverData, @"driver", dataRequest[@"status_id"], @"kind_id", typePush, @"push_type", nil];

    NSDictionary *apsData = [NSDictionary dictionaryWithObjectsAndKeys:extraInfo, @"extra", nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:apsData, @"aps", nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag != 102){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id652371914"]];
    }
}

- (void)validateStatus {
    //NSString *serviceId =[TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE];

    NSLog(@"validateStatus %@", [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE]);
    if ( [[TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE] integerValue] > 0 ) {

        NSLog(@" validateStatus = %@ %@",
              [TYUsserProfile UsserInfoForKey:USSER_ID],
              [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE] );
    [[[HTTPSyncRequest alloc] init] validateCurrentServiceData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                                [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE], @"service_id",
                                                                nil] delegate:self];
    }
    else {
        NSLog(@" validateStatus = %@ %@",
        [TYUsserProfile UsserInfoForKey:USSER_ID],
        [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE] );

    [[[HTTPSyncRequest alloc] init] validateCurrentServiceData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                                nil] delegate:self];
    }
}

- (void)getServicioVigente {
    NSLog(@"LLAMA AL SERVICIO VIGENTE------------------------------------------------------------------");
    [[[HTTPSyncRequest alloc] init] validateCurrentServiceData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [TYUsserProfile UsserInfoForKey:USSER_ID], @"user_id",
                                                                nil] delegate:self];
}

- (void)validateSession {
    [[[HTTPSyncRequest alloc] init] validateSession:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [TYUsserProfile UsserInfoForKey:USSER_EMAIL], @"login",
                                                                [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN], @"uuid",
                                                                nil] delegate:self];
}

- (void)validateSolicitudService {
    [self.validateStatusTimer invalidate];
    self.isArrived = FALSE;
    self.validateStatusTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(validateStatus) userInfo:nil repeats:YES];
}

- (void)validateCancelSolicitudService {
    [self.validateStatusTimer invalidate];
    self.validateStatusTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(validateStatus) userInfo:nil repeats:YES];

}

- (void)getServiceCurrent {
    [self cancelTimers];
    [self getServicioVigente];
}

-(bool) showedTaxiAccepted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *arrived = [defaults objectForKey:@"taxi_accepted"];
    if (arrived == nil) {
        return TRUE;
    }
    return FALSE;

}

-(void) confirmTaxiAccepted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"taxi_accepted"];
}

-(void) deleteTaxiAccepted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"taxi_accepted"];
}


-(bool) showedTaxiArrived {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *arrived = [defaults objectForKey:@"taxi_arrived"];
    if (arrived == nil) {
        return TRUE;
    }
    return FALSE;
}

-(bool) showedServiceCancelled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cancelled = [defaults objectForKey:@"service_cancelled"];
    if (cancelled == nil) {
        return TRUE;
    }
    return FALSE;

}

-(void) confirmServiceCancelled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"service_cancelled"];
}

-(void) deleteServiceCancelled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"service_cancelled"];
}

-(void) confirmTaxiArrived {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"taxi_arrived"];
}

-(void) deleteTaxiArrived {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"taxi_arrived"];
}


-(bool) showedServiceQualification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *arrived = [defaults objectForKey:@"service_qualification"];
    if (arrived == nil) {
        return TRUE;
    }
    return FALSE;
}

-(void) confirmServiceQualification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"service_qualification"];
}

-(void) deleteServiceQualified {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"service_qualification"];
}

-(bool)isPendingRequestInBackground {
    NSLog(@"isPendingRequestInBackground ");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *arrived = [defaults objectForKey:@"request_pending"];
    if (arrived == nil) {
        return FALSE;
    }
    return TRUE;
}

-(void)setRequestInBackground {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"request_pending"];
}

-(void)delRequestInBackground {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"request_pending"];
}

@end
