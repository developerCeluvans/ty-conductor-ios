

//
//  TYServiceProgress.m
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYServiceProgress.h"
#import "TYUsserProfile.h"
#import "JSON.h"
//#import "HTTPSyncRequest.h"
#import "AppDelegate.h"

@implementation TYServiceProgress

@synthesize delegate                        = _delegate;
@synthesize tysTaxi                         = _tysTaxi;
@synthesize timerAssignmentTaxi             = _timerAssignmentTaxi;
@synthesize idTaxista                       = _idTaxista;
@synthesize timerPositionTaxi               = _timerPositionTaxi;
@synthesize areFoundingTaxiPosition         = _areFoundingTaxiPosition;
@synthesize countTIMER                      = _countTIMER;

- (id)initWithDelegate:(id<TYServiceProgressDelegate>)delegate{

    if(self == [super init])
    {

        self.delegate = delegate;

        [self initServiceIfNeeded];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"push_confirm" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelservice:) name:@"push_cancel_service" object:nil];

        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxicancelservice:) name:@"push_driver_cancel_service" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemcancelservice:) name:@"push_system_service" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarriveds:) name:@"push_show_view_qual" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiarriveds_push:) name:@"push_show_view_qual_push" object:nil];

    }

    return self;

}


- (void) pushNotificationReceived: (NSNotification*)aNotification
{

    NSString *iddriver =

    (NSString*)[[[[[aNotification userInfo]
                   objectForKey:@"aps"]
                  objectForKey:@"extra"]
                 objectForKey:@"driver"]
                objectForKey:@"id"];

    //NSLog(@"TaixsyaUsuarios -     pushNotificationReceived:  taxiConfirm: %@",[[[[aNotification userInfo] objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"driver"]  );


    NSLog(@"driver: %@", [[[[aNotification userInfo] objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"driver"] );
    //NSLog(@"El id del Vehiculo %@", iddriver);
    [TYUsserProfile SetUsserInfo:iddriver ForKey:USSER_HAVE_SERVICE_PENDING];
    [TYUsserProfile SetUsserInfo:iddriver ForKey:USSER_SERVICE_ID_FOR_QUALITY];

    [_tysTaxi requestTaxiType:TYSTaxiTypeTaxiInfo object:iddriver];

    //[self setTaxiPofile:profile];

    NSMutableDictionary *driverDict = [[[[aNotification userInfo] objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"driver"];

    NSLog(@"TaixsyaUsuarios -     pushNotificationReceived:  taxiConfirm: driverDict: %@",driverDict[@"id"]);

    [self makeLogicServiceStatusWithDictionary:driverDict];

}

- (void) cancelservice: (NSNotification*)aNorification
{
    [_tysTaxi clearDelegateAndCancel];

    _tysTaxi.delegate = nil;

    self.tysTaxi = nil;

    [self startTimerAssigmentTaxi:NO];

    [self startTimerPositionTaxi:NO];

    [self clearservicepending];

    //[_delegate TYServiceProgressOperatorCancelForDriverTheService];
}

- (void) taxicancelservice: (NSNotification*)aNorification
{
    [_tysTaxi clearDelegateAndCancel];

    _tysTaxi.delegate = nil;

    self.tysTaxi = nil;

    [self startTimerAssigmentTaxi:NO];

    [self startTimerPositionTaxi:NO];

    [self clearservicepending];

    [_delegate TYServiceProgressOperatorCancelForDriverTheService];
}

- (void) systemcancelservice: (NSNotification*)aNorification
{
    [_tysTaxi clearDelegateAndCancel];

    _tysTaxi.delegate = nil;

    self.tysTaxi = nil;

    [self startTimerAssigmentTaxi:NO];

    [self startTimerPositionTaxi:NO];

    [self clearservicepending];

    [_delegate TYServiceProgressOperatorCancelTheService];

}


- (void) taxiarriveds: (NSNotification*)aNorification {
    [self startTimerAssigmentTaxi:NO];
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {

                       [self startTimerPositionTaxi:NO];

                   });
    [_delegate TYServiceProgressTaxiAreWaitingForUsser];
    [self clearservicepending];
}

- (void) taxiarriveds_push: (NSNotification*)aNorification {
    [self startTimerAssigmentTaxi:NO];
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {

                       [self startTimerPositionTaxi:NO];

                   });
    [self clearservicepending];
}

- (void)dealloc{

    [_tysTaxi clearDelegateAndCancel];

}

- (void)initServiceIfNeeded
{

    if(!_tysTaxi)
    {

        self.tysTaxi = [[TYSTaxi alloc] initwithDelegate:self];

    }

}

- (void)clearservicepending{

    [TYUsserProfile SetUsserInfo:@"-1" ForKey:USSER_HAVE_SERVICE_PENDING];

}

- (void)requestServiceWithAddress:(TYAddress *)address{

    if(address){

        _countTIMER = 0;

        _idTaxista = @"";

        [self initServiceIfNeeded];

        [_tysTaxi requestTaxiType:TYSTaxiTypeRequestService object:address];

    }

}

- (void)requestCancerService{

    [_tysTaxi clearDelegateAndCancel];

    _tysTaxi.delegate = nil;

    self.tysTaxi = nil;

    [self startTimerAssigmentTaxi:NO];

    [self startTimerPositionTaxi:NO];


    if([self usserHaveServicePending])
    {

        NSLog(@"______________ CANCEL THE SERVICE");

        [self initServiceIfNeeded];

        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];

        [_tysTaxi requestTaxiType:TYSTaxiTypeCancelService object:service_pending];

        [_tysTaxi clearDelegateAndCancel];


    }else{

        NSLog(@"__________ DONT HAV SERVICE FUCKKKKKK");

    }

    // Clear the service
    [self clearservicepending];



}

- (void)requestCancelAutomatic{

    [_tysTaxi clearDelegateAndCancel];
    _tysTaxi.delegate = nil;
    self.tysTaxi = nil;

    [self startTimerAssigmentTaxi:NO];

    [self startTimerPositionTaxi:NO];

    if([self usserHaveServicePending])
    {

        [self initServiceIfNeeded];

        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];

        [_tysTaxi requestTaxiType:TYSTaxiTypeCancelAutomatic object:service_pending];

        // Clear the service

        [self clearservicepending];

    }

    [_delegate TYServiceProgressOperatorCancelTheService];

}

- (void)requestQualityService:(NSString *)type{

    if ([self usserHaveServicePending]) {

    }

    [self initServiceIfNeeded];
    [_tysTaxi requestTaxiType:TYSTaxiTypeQualityService object:type];

}

- (void)sendDelegateFailWithRequestType:(TYSTaxiType)type{

    [_delegate TYServiceProgressFailConnectionInRequestType:type];

}

- (void)startTimerAssigmentTaxi:(BOOL)start{

    if(start)
    {

        if([self usserHaveServicePending])
        {

            if(_timerAssignmentTaxi)
            {

                [_timerAssignmentTaxi invalidate];
                self.timerAssignmentTaxi = nil;

            }

            self.timerAssignmentTaxi = [NSTimer timerWithTimeInterval:3
                                                               target:self
                                                             selector:@selector(requestAssigmentTaxi)
                                                             userInfo:nil
                                                              repeats:YES];

            [[NSRunLoop currentRunLoop] addTimer:_timerAssignmentTaxi forMode:NSDefaultRunLoopMode];

        }

    }else{

        [_timerAssignmentTaxi invalidate];
        self.timerAssignmentTaxi = nil;
        _idTaxista = @"";

    }

}

- (void)startTimerPositionTaxi:(BOOL)start{

    if(start)
    {

        _areFoundingTaxiPosition = YES;

        if(_timerPositionTaxi)
        {

            [_timerPositionTaxi invalidate];
            self.timerPositionTaxi = nil;

        }

        self.timerPositionTaxi = [NSTimer timerWithTimeInterval:4
                                                         target:self
                                                       selector:@selector(requestTaxiPosition)
                                                       userInfo:nil
                                                        repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:_timerPositionTaxi forMode:NSDefaultRunLoopMode];


    }else{

        _areFoundingTaxiPosition = NO;
        _idTaxista = @"";

        [_timerPositionTaxi invalidate];
        self.timerPositionTaxi = nil;



    }

}


- (void)requestAssigmentTaxi{

    _countTIMER += 1;

    NSLog(@"aaaaaaa ::: %i", _countTIMER);

    if([self validatecountTIMER:_countTIMER])
    {

        [self initServiceIfNeeded];

        [_tysTaxi requestTaxiType:TYSTaxiTypeServiceStatus object:nil];

    }

}

- (BOOL)validatecountTIMER:(int)countTimer{

    if(countTimer >= 60 && _idTaxista.length <= 0){



        [self requestCancelAutomatic];

        return NO;

    }

    return YES;

}

- (void)requestTaxiPosition{

    if(_idTaxista.length){

        [self initServiceIfNeeded];

        [_tysTaxi requestTaxiType:TYSTaxiTypeTaxiInfo object:_idTaxista];

    }else{

        NSLog(@"%s \n Lopp taxista position INVALIDATED \n because:_idTaxista.length:false", __PRETTY_FUNCTION__);

        [self startTimerPositionTaxi:NO];

    }

}

- (BOOL)usserHaveServicePending{

    NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];

    int num = -1;

    @try {
        num = [service_pending intValue];
    }
    @catch (NSException *exception) {
        num = -1;
    }
    @finally {

        if(num > 0) return YES;

    }

    return NO;

}

- (void)checkServicePendingIfNeeded
{
    if([self usserHaveServicePending]){

        NSLog(@"____________________________ checkServicePendingIfNeeded ___________________");

        [self requestAssigmentTaxi];

    }
}

- (void)makeLogicRequestService:(NSMutableDictionary *)values
{

    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [values description]);

    bool isSuscees = (bool) [values objectForKey:@"success"];

    if(isSuscees)
    {

        NSString *idService = [values objectForKey:@"service_id"];

        int serviceID = -1;

        @try {
            serviceID = [idService integerValue];
        }
        @catch (NSException *exception) {
            serviceID = -1;
        }
        @finally {

            if(serviceID > 0){
                NSLog(@" INICIA TIMER CON SERVICIO %@", idService);
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_HAVE_SERVICE_PENDING];
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_LAST_SERVICE];
                [TYUsserProfile SetUsserInfo:idService ForKey:USSER_SERVICE_ID_FOR_QUALITY];

                [(AppDelegate *)[[UIApplication sharedApplication] delegate] validateSolicitudService];

            }else{

                [self clearservicepending];

            }
        }

    }else{

        [self clearservicepending];

        [self sendDelegateFailWithRequestType:TYSTaxiTypeRequestService];

        return;
    }


}

- (void)makeLogicServiceStatusWithDictionary:(NSMutableDictionary *)dictionary{

    //NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [dictionary description]);

    NSString *status = [dictionary objectForKey:@"status_id"];

    NSLog(@" ESTADO DEL SERVICIO %@",status);

    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:status
    //                                                    message:nil
    //                                                   delegate:nil
    //                                          cancelButtonTitle:@"Ok"
    //                                          otherButtonTitles:nil, nil];
    //
    //    [alert show];


    if([status isEqualToString:STATUS_ASSIGNED])
    {

        NSString *idTaxi = [dictionary objectForKey:@"driver_id"];

        self.idTaxista = idTaxi;

        if (!_areFoundingTaxiPosition)
        {

            [self startTimerPositionTaxi:YES];

        }

    }else if ([status isEqualToString:STATUS_CANCELED])
    {

        [_tysTaxi clearDelegateAndCancel];
        _tysTaxi.delegate = nil;
        self.tysTaxi = nil;

        [self startTimerAssigmentTaxi:NO];

        [self startTimerPositionTaxi:NO];

        [self clearservicepending];

        [_delegate TYServiceProgressOperatorCancelTheService];

    }else if ([status isEqualToString:STATUS_CANCELED_FOR_DRIVER1] || [status isEqualToString:STATUS_CANCELED_FOR_DRIVER2]){

        [_tysTaxi clearDelegateAndCancel];
        _tysTaxi.delegate = nil;
        self.tysTaxi = nil;

        [self startTimerAssigmentTaxi:NO];

        [self startTimerPositionTaxi:NO];

        [self clearservicepending];


        [_delegate TYServiceProgressOperatorCancelForDriverTheService];

    }else if ( [status isEqualToString:STATUS_CANCELED_FOR_DRIVER]){

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_system_service" object:nil userInfo:nil];

    }
    else if ([status isEqualToString:STATUS_ENDED])
    {

        NSLog(@"\n\n hppppppp _____________ TONTO HP ");
        //
        //        [self startTimerAssigmentTaxi:NO];
        //
        //        [self startTimerPositionTaxi:NO];

        //        double delayInSeconds = 4.0;
        //
        //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        //
        //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //
        //
        //
        //        });
        //

        [[NSNotificationCenter defaultCenter] postNotificationName:@"push_arrived" object:nil userInfo:nil];

        NSLog(@"PUSH ARRIVEDD  FUCK");


    }else if ([status isEqualToString:STATUS_PENDING]){




    }else if ([status isEqualToString:STATUS_RUNNING]){



    }else{



    }

}


- (void)makelogicCancelService:(NSMutableDictionary *) dictionary
{
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [dictionary description]);

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [_tysTaxi requestTaxiType:TYSTaxiTypeRequestService object:nil];
}

- (void)makeLogigTaxiInfoWithDictionary:(NSMutableDictionary *)dictionary{

    //NSLog(@"%s \n %@", __PRETTY_FUNCTION__, [dictionary description]);

    NSString *name      =       [dictionary objectForKey:@"name"];
    NSString *lastName  =       [dictionary objectForKey:@"lastname"];
    NSString *placa     =       [dictionary objectForKey:@"placa"];
    NSString *latitude  =       [dictionary objectForKey:@"crt_lat"];
    NSString *longitude =       [dictionary objectForKey:@"crt_lng"];
    NSString *photo =           [dictionary objectForKey:@"picture"];
    NSString *cellphone =       [dictionary objectForKey:@"cellphone"];

    _idTaxista          =       [dictionary objectForKey:@"id"];

    float f_latitude = 0.0f;
    float f_longitude = 0.0f;

    @try {

        f_latitude = [latitude floatValue];
        f_longitude = [longitude floatValue];

    }
    @catch (NSException *exception) {

        f_latitude = 0;
        f_longitude = 0;

    }

    NSLog(@"%f, %f", f_latitude, f_longitude);

    NSMutableDictionary *carDic = [dictionary objectForKey:@"car"];

    NSString *brand         = @"";
    NSString *model         = @"";

    if(carDic)
    {

        brand = [carDic objectForKey:@"car_brand"];
        model = [carDic objectForKey:@"model"];

    }

    TYTaxiProfile *profile = [[TYTaxiProfile alloc] init];
    profile.name = name;
    profile.lastName = lastName;
    profile.placa = placa;
    profile.latitude = f_latitude;
    profile.longitude = f_longitude;
    profile.urlImage = photo;
    profile.idService = _idTaxista;
    profile.phone = cellphone;
    profile.brand = brand;
    profile.model = model;

    NSLog(@"IDDDDDDD2 %@",_idTaxista);

    if(profile)
    {

        [_delegate TYServiceProgressUpdateTaxiInfo:profile];

    }

}


#pragma mark -
#pragma mark - ServicesDelegate

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status{

    NSLog(@" RESPUESTA :: %@", response);

    if(type == TYSTaxiTypeRequestService)
    {

        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *values = [response JSONValue];

            if(values)
            {

                [self makeLogicRequestService:values];

            }else{

                [self clearservicepending];

                [self sendDelegateFailWithRequestType:type];

            }

        }else{

            [self sendDelegateFailWithRequestType:type];

        }


    }else if (type == TYSTaxiTypeServiceStatus){


        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *dictionary = [response JSONValue];

            if(dictionary){

                [self makeLogicServiceStatusWithDictionary:dictionary];

            }

        }else{


        }

    }else if (type == TYSTaxiTypeTaxiInfo)
    {

        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *dic = [response JSONValue];

            if(dic)
            {

                [self makeLogigTaxiInfoWithDictionary:dic];

            }

        }

    }else if(type ==  TYSTaxiTypeCancelService)
    {
        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *dic = [response JSONValue];

            if (dic)
            {
                [self makelogicCancelService:dic];
            }


        }else{

            UIAlertView *alert =

            [[UIAlertView alloc] initWithTitle:@"Importante"
                                       message:@"El servicio no pudo ser cancelado."
                                      delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
            [alert show];
        }
    }

}

@end
