//
//  TYSTaxi.m
//  taxisya
//
//  Created by NTTak3 on 3/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYSTaxi.h"
#import "TYUsserProfile.h"
#import "TYSLogin.h"
#import "Functions.h"
#import "JSON.h"

@implementation TYSTaxi
{

    TYSLogin *tysLogin;

}

@synthesize delegate                    = _delegate;
@synthesize requestService              = _requestService;
@synthesize requestServiceStatus        = _requestServiceStatus;
@synthesize requestTaxiInfo             = _requestTaxiInfo;
@synthesize requestCancelService        = _requestCancelService;
@synthesize requestQualityService       = _requestQualityService;

- (id)initwithDelegate:(id<TYSTaxiDelegate>)delegate{

    if(self == [super init]){

        self.delegate = delegate;

//        NSString *idUser = [TYUsserProfile UsserInfoForKey:USSER_ID];

//        if (idUser && idUser.length) {
//
//            NSString *email = [TYUsserProfile UsserInfoForKey:USSER_EMAIL];
//            NSString *pass = [TYUsserProfile UsserInfoForKey:USSER_PASSWORD];
//
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:email forKey:@"login"];
//            [dic setObject:pass forKey:@"pwd"];
//
//            tysLogin = [[TYSLogin alloc] initwithDelegate:nil];
//            [tysLogin requestLoginType:TYSLoginTypeLogin object:dic];
//
//        }

    }

    return self;

}

- (void)dealloc{

    [self clearDelegateAndCancel];

}

- (void)clearDelegateAndCancel{

    [_requestService clearDelegatesAndCancel];
    self.requestService = nil;

    [_requestServiceStatus clearDelegatesAndCancel];
    self.requestServiceStatus = nil;

    [_requestTaxiInfo clearDelegatesAndCancel];
    self.requestTaxiInfo = nil;

    [_requestCancelService clearDelegatesAndCancel];
    self.requestCancelService = nil;

    [_requestQualityService clearDelegatesAndCancel];
    self.requestQualityService = nil;

    [_requestCancelAutomatic clearDelegatesAndCancel];
    self.requestCancelAutomatic = nil;

}

- (void)sendType:(TYSTaxiType)type withResponse:(NSString *)response status:(ServiceStatus)status
{
    [_delegate TYSTaxiType:type response:response status:status];
}

- (void)requestTaxiType:(TYSTaxiType)type object:(id)object{

    NSLog(@"ENTRA A LLAMR EL WEBSERVICE");

    if(type == TYSTaxiTypeRequestService)
    {

        if(_requestService)
        {

            [_requestService clearDelegatesAndCancel];

            self.requestService = nil;

        }

        TYAddress *address = (TYAddress *)object;

        NSString *dir1 =    address.address1;
        NSString *dir2 =    address.address2;
        NSString *dir3 =    address.address3;
        NSString *dir4 =    address.address4;
        NSString *dir5 =    address.address5;
        NSString *dir6 =    address.address6;
        NSString *lat  =    address.latitude;
        NSString *lon  =    address.longitude;

        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        //NSString *email =   [TYUsserProfile UsserInfoForKey:USSER_EMAIL];
        //NSString *passw =   [TYUsserProfile UsserInfoForKey:USSER_PASSWORD];

        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = URL_SERVICE_REQUEST_SERVICE_NEW;

        NSLog(@"URL -> %@",url);

        self.requestService = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        self.requestService.delegate = self;

        [self.requestService setRequestMethod:@"POST"];

        //Time Out

        [_requestService setTimeOutSeconds:60*15];

        [_requestService setDidFinishSelector:@selector(requestServiceFinished:)];

        [_requestService setDidFailSelector:@selector(requestServiceFail:)];


        //[_requestService setPostValue:idUsu forKey:@"user_id"];
        //[_requestService setPostValue:email forKey:@"login"];
        //[_requestService setPostValue:passw forKey:@"pwd"];

        [_requestService setPostValue:[Functions getCorrectlyAddress:dir1]  forKey:@"index_id"];
        NSLog(@"index_id = %@", dir1);
        [_requestService setPostValue:[Functions getCorrectlyAddress:dir2]  forKey:@"comp1"];
        NSLog(@"comp1 = %@", dir2);
        [_requestService setPostValue:[Functions getCorrectlyAddress:dir3]  forKey:@"comp2"];
        NSLog(@"comp2 = %@", dir3);
        [_requestService setPostValue:[Functions getCorrectlyAddress:dir4]  forKey:@"no"];
        NSLog(@"no = %@", dir3);
        [_requestService setPostValue:[Functions getCorrectlyAddress:dir5]  forKey:@"obs"];
        NSLog(@"obs = %@", dir5);
        [_requestService setPostValue:[Functions getCorrectlyAddress:dir6]  forKey:@"barrio"];
        NSLog(@"barrio = %@", dir6);
        [_requestService setPostValue:lat   forKey:@"lat"];
        NSLog(@"lat = %@", lat);
        [_requestService setPostValue:lon   forKey:@"lng"];
        NSLog(@"lng = %@", lon);
        [_requestService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);

//        NSLog(@"Datos %@", [NSJSONSerialization JSONObjectWithData:_requestService. options:NSJSONReadingAllowFragments error:nil]);

        [_requestService startAsynchronous];

    }else if (type == TYSTaxiTypeServiceStatus)
    {

        if(_requestServiceStatus)
        {

            [_requestServiceStatus clearDelegatesAndCancel];
            self.requestServiceStatus = nil;

        }

        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestServiceStatus = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_REQUEST_SERVICE_STATUS];
        self.requestServiceStatus.delegate = self;

        [_requestServiceStatus setPostValue:service_pending forKey:@"service_id"];
        [_requestServiceStatus setPostValue:idUsu forKey:@"id"];
        [_requestServiceStatus setPostValue:token forKey:@"uuid"];
        [_requestServiceStatus setDidFinishSelector:@selector(requestServiceStatusFinished:)];
        [_requestServiceStatus setDidFailSelector:@selector(requestServiceStatusFail:)];
        [_requestServiceStatus startAsynchronous];

    }else if (type == TYSTaxiTypeTaxiInfo){

        if(_requestTaxiInfo)
        {

            [_requestTaxiInfo clearDelegatesAndCancel];
            self.requestTaxiInfo = nil;

        }

        NSString *idTaxista = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestTaxiInfo = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_TAXI_INFO];
        _requestTaxiInfo.delegate = self;
        [_requestTaxiInfo setPostValue:idTaxista forKey:@"driver_id"];
        [_requestTaxiInfo setPostValue:idUsu forKey:@"id"];
        [_requestTaxiInfo setPostValue:token forKey:@"uuid"];
        [_requestTaxiInfo setDidFinishSelector:@selector(requestTaxiInfoFinished:)];
        [_requestTaxiInfo setDidFailSelector:@selector(requestTaxiFail:)];
        [_requestTaxiInfo startAsynchronous];

    }else if (type == TYSTaxiTypeCancelService)
    {

        if(_requestCancelService)
        {

            [_requestCancelService clearDelegatesAndCancel];
            self.requestCancelService = nil;

        }

        // NSString *service =   (NSString *)object;

        NSString *idUsu   =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        // NSString *token   =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelService = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];

        _requestCancelService.delegate =  self;
        [_requestCancelService setRequestMethod:@"POST"];
//        [_requestCancelService setDidFinishSelector:@selector(CancelServiceFinished:)];
//        [_requestCancelService setDidFailSelector:@selector(CancelServiceFail:)];
        [_requestCancelService startSynchronous];

        NSError *error = [_requestCancelService error];
        if (!error) {
            NSString *response = [_requestCancelService responseString];
            NSLog(@"response %@",response);


        }else{
            NSLog(@"%@",[ error description]);
        }

    }else if (type == TYSTaxiTypeCancelAutomatic)
    {

        if(_requestCancelAutomatic)
        {

            [_requestCancelAutomatic clearDelegatesAndCancel];
            self.requestCancelAutomatic = nil;

        }

        //NSString *service = (NSString *)object;
        NSString *idUsu   = [TYUsserProfile UsserInfoForKey:USSER_ID];
        //NSString *token   = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelAutomatic = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        [_requestCancelAutomatic setPostValue:@"1" forKey:@"by_system"];

        [_requestCancelAutomatic startAsynchronous];



    }else if (type == TYSTaxiTypeQualityService){

        if(_requestQualityService)
        {

            [_requestQualityService clearDelegatesAndCancel];
            self.requestQualityService = nil;

        }
        //Aqui esta pendiente aqui vamos USSER_HAVE_SERVICE_PENDING
//        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_SERVICE_ID_FOR_QUALITY];
        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE];
        NSString *type = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestQualityService = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_QUALITY_SERVICE];
        NSLog(@"URL Qualify %@", URL_SERVICE_QUALITY_SERVICE);
        [_requestQualityService setPostValue:service_pending forKey:@"service_id"];
        NSLog(@"service_id = %@", service_pending);
        [_requestQualityService setPostValue:type forKey:@"qualification"];
        NSLog(@"qualification = %@", type);
        [_requestQualityService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);
        [_requestQualityService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestQualityService startAsynchronous];

        [TYUsserProfile SetUsserInfo:@"-1"  ForKey:USSER_HAVE_SERVICE_PENDING];
        //[TYUsserProfile SetUsserInfo:@"0"  ForKey:USSER_HAVE_SERVICE_PENDING];
        //[TYUsserProfile SetUsserInfo:@"" ForKey:USSER_LAST_SERVICE];
        NSError *error = _requestQualityService.error;

       if(!error){

           NSString *response = _requestQualityService.responseString;

           NSLog(@"QUALIFICATION ERROR RESPONSE :: %@", response);

       }else{
           NSLog(@"%@",[error localizedDescription]);
       }
    }
}



// test +
- (void)requestTaxiType2:(TYSTaxiType)type
                  object:(id)object
                  barrio:(NSString *)barrio
                 latitud:(NSString *)lat
                longitud:(NSString *) lng {

    NSLog(@"ENTRA A LLAMR EL WEBSERVICE");

    if(type == TYSTaxiTypeRequestService)
    {

        if(_requestService)
        {

            [_requestService clearDelegatesAndCancel];

            self.requestService = nil;

        }

        // TYAddress *address = (TYAddress *)object;
        // NSString *dir1 =    address.address1;
        // NSString *dir2 =    address.address2;
        // NSString *dir3 =    address.address3;
        // NSString *dir4 =    address.address4;
        // NSString *dir5 =    address.address5;
        // NSString *dir6 =    address.address6;


        NSString *fullAddress = (NSString *) object;

        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_REQUEST_SERVICE_NEW_ADDRESS stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];


        NSLog(@"URL -> %@",url);

        self.requestService = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        self.requestService.delegate = self;

        [self.requestService setRequestMethod:@"POST"];

        //Time Out

        [_requestService setTimeOutSeconds:60*15];

        [_requestService setDidFinishSelector:@selector(requestServiceFinished:)];

        [_requestService setDidFailSelector:@selector(requestServiceFail:)];



//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir1]  forKey:@"index_id"];
//        NSLog(@"index_id = %@", dir1);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir2]  forKey:@"comp1"];
//        NSLog(@"comp1 = %@", dir2);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir3]  forKey:@"comp2"];
//        NSLog(@"comp2 = %@", dir3);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir4]  forKey:@"no"];
//        NSLog(@"no = %@", dir3);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir5]  forKey:@"obs"];
//        NSLog(@"obs = %@", dir5);

        [_requestService setPostValue:[Functions getCorrectlyAddress:fullAddress] forKey:@"address"];

        NSLog(@"address = %@", fullAddress);


        [_requestService setPostValue:[Functions getCorrectlyAddress:barrio]  forKey:@"barrio"];
        NSLog(@"barrio = %@", barrio);
        [_requestService setPostValue:lat   forKey:@"lat"];
        NSLog(@"lat = %@", lat);
        [_requestService setPostValue:lng   forKey:@"lng"];
        NSLog(@"lng = %@", lng);
        [_requestService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);

//        NSLog(@"Datos %@", [NSJSONSerialization JSONObjectWithData:_requestService. options:NSJSONReadingAllowFragments error:nil]);

        [_requestService startAsynchronous];

    }else if (type == TYSTaxiTypeServiceStatus)
    {

        if(_requestServiceStatus)
        {

            [_requestServiceStatus clearDelegatesAndCancel];
            self.requestServiceStatus = nil;

        }

        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestServiceStatus = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_REQUEST_SERVICE_STATUS];
        self.requestServiceStatus.delegate = self;

        [_requestServiceStatus setPostValue:service_pending forKey:@"service_id"];
        [_requestServiceStatus setPostValue:idUsu forKey:@"id"];
        [_requestServiceStatus setPostValue:token forKey:@"uuid"];
        [_requestServiceStatus setDidFinishSelector:@selector(requestServiceStatusFinished:)];
        [_requestServiceStatus setDidFailSelector:@selector(requestServiceStatusFail:)];
        [_requestServiceStatus startAsynchronous];

    }else if (type == TYSTaxiTypeTaxiInfo){

        if(_requestTaxiInfo)
        {

            [_requestTaxiInfo clearDelegatesAndCancel];
            self.requestTaxiInfo = nil;

        }

        NSString *idTaxista = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestTaxiInfo = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_TAXI_INFO];
        _requestTaxiInfo.delegate = self;
        [_requestTaxiInfo setPostValue:idTaxista forKey:@"driver_id"];
        [_requestTaxiInfo setPostValue:idUsu forKey:@"id"];
        [_requestTaxiInfo setPostValue:token forKey:@"uuid"];
        [_requestTaxiInfo setDidFinishSelector:@selector(requestTaxiInfoFinished:)];
        [_requestTaxiInfo setDidFailSelector:@selector(requestTaxiFail:)];
        [_requestTaxiInfo startAsynchronous];

    }else if (type == TYSTaxiTypeCancelService)
    {

        if(_requestCancelService)
        {

            [_requestCancelService clearDelegatesAndCancel];
            self.requestCancelService = nil;

        }

        // NSString *service =   (NSString *)object;

        NSString *idUsu   =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        // NSString *token   =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelService = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];

        _requestCancelService.delegate =  self;
        [_requestCancelService setRequestMethod:@"POST"];
//        [_requestCancelService setDidFinishSelector:@selector(CancelServiceFinished:)];
//        [_requestCancelService setDidFailSelector:@selector(CancelServiceFail:)];
        [_requestCancelService startSynchronous];

        NSError *error = [_requestCancelService error];
        if (!error) {
            NSString *response = [_requestCancelService responseString];
            NSLog(@"%@",response);

        }else{
            NSLog(@"%@",[error description]);
        }

    }else if (type == TYSTaxiTypeCancelAutomatic)
    {

        if(_requestCancelAutomatic)
        {

            [_requestCancelAutomatic clearDelegatesAndCancel];
            self.requestCancelAutomatic = nil;

        }

        //NSString *service = (NSString *)object;
        NSString *idUsu   = [TYUsserProfile UsserInfoForKey:USSER_ID];
        //NSString *token   = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelAutomatic = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        [_requestCancelAutomatic setPostValue:@"1" forKey:@"by_system"];

        [_requestCancelAutomatic startAsynchronous];



    }else if (type == TYSTaxiTypeQualityService){

        if(_requestQualityService)
        {

            [_requestQualityService clearDelegatesAndCancel];
            self.requestQualityService = nil;

        }
        //Aqui esta pendiente aqui vamos USSER_HAVE_SERVICE_PENDING
//        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_SERVICE_ID_FOR_QUALITY];
        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE];
        NSString *type = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestQualityService = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_QUALITY_SERVICE];
        NSLog(@"URL Qualify %@", URL_SERVICE_QUALITY_SERVICE);
        [_requestQualityService setPostValue:service_pending forKey:@"service_id"];
        NSLog(@"service_id = %@", service_pending);
        [_requestQualityService setPostValue:type forKey:@"qualification"];
        NSLog(@"qualification = %@", type);
        [_requestQualityService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);
        [_requestQualityService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestQualityService startAsynchronous];

        [TYUsserProfile SetUsserInfo:@"-1"  ForKey:USSER_HAVE_SERVICE_PENDING];
        [TYUsserProfile SetUsserInfo:@"0"  ForKey:USSER_HAVE_SERVICE_PENDING];

        //[TYUsserProfile SetUsserInfo:@"" ForKey:USSER_LAST_SERVICE];

    }

}

// test -
- (void)requestTaxiType3:(TYSTaxiType)type object:(id)object barrio:(NSString *)barrio latitud:(NSString *)lat longitud:(NSString *) lng payType:(int)payType payReference:(NSString *)payReference email:(NSString *)email cardReference:(NSString *)cardReference ticket:(NSString *) ticket {
NSLog(@"ENTRA A LLAMR EL WEBSERVICE");

    if(type == TYSTaxiTypeRequestService)
    {

        if(_requestService)
        {

            [_requestService clearDelegatesAndCancel];

            self.requestService = nil;

        }


        NSString *fullAddress = (NSString *) object;

        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];
        
        NSString *cellphone = [TYUsserProfile UsserInfoForKey:USSER_CELLPHONE];
        
        NSString *code = [cellphone substringFromIndex: [cellphone length] - 2];
  
        NSString *url = [URL_SERVICE_REQUEST_SERVICE_NEW_ADDRESS stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];


        NSLog(@"URL -> %@",url);

        self.requestService = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        self.requestService.delegate = self;

        [self.requestService setRequestMethod:@"POST"];

        //Time Out

        [_requestService setTimeOutSeconds:60*15];

        [_requestService setDidFinishSelector:@selector(requestServiceFinished:)];

        [_requestService setDidFailSelector:@selector(requestServiceFail:)];



//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir1]  forKey:@"index_id"];
//        NSLog(@"index_id = %@", dir1);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir2]  forKey:@"comp1"];
//        NSLog(@"comp1 = %@", dir2);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir3]  forKey:@"comp2"];
//        NSLog(@"comp2 = %@", dir3);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir4]  forKey:@"no"];
//        NSLog(@"no = %@", dir3);
//        [_requestService setPostValue:[Functions getCorrectlyAddress:dir5]  forKey:@"obs"];
//        NSLog(@"obs = %@", dir5);

        [_requestService setPostValue:[Functions getCorrectlyAddress:fullAddress] forKey:@"address"];

        NSLog(@"address = %@", fullAddress);


        [_requestService setPostValue:[Functions getCorrectlyAddress:barrio]  forKey:@"barrio"];
        NSLog(@"barrio = %@", barrio);
        [_requestService setPostValue:lat   forKey:@"lat"];
        NSLog(@"lat = %@", lat);
        [_requestService setPostValue:lng   forKey:@"lng"];
        NSLog(@"lng = %@", lng);
        [_requestService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);


        // payment +
        [_requestService setPostValue:
         
         [NSString stringWithFormat:@"%i",payType] forKey:@"pay_type"];
        NSLog(@"payType = %i", payType);
        [_requestService setPostValue:payReference forKey:@"pay_reference"];
        NSLog(@"payReference = %@", payReference);
        [_requestService setPostValue:email forKey:@"user_email"];
        NSLog(@"email = %@", email);

        if (payType == 3) {
            [_requestService setPostValue:ticket forKey:@"user_card_reference"];
        }
        else {
            [_requestService setPostValue:cardReference forKey:@"user_card_reference"];
        }
        NSLog(@"cardReference = %@", cardReference);
        // payment -
        [_requestService setPostValue:code forKey:@"code"];
        NSLog(@"code = %@", code);

        

        NSLog(@"request 3 %@", _requestService);



        //NSLog(@"Datos %@", [NSJSONSerialization JSONObjectWithData:_requestService. options:NSJSONReadingAllowFragments error:nil]);

        [_requestService startAsynchronous];

    }else if (type == TYSTaxiTypeServiceStatus)
    {

        if(_requestServiceStatus)
        {

            [_requestServiceStatus clearDelegatesAndCancel];
            self.requestServiceStatus = nil;

        }

        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestServiceStatus = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_REQUEST_SERVICE_STATUS];
        self.requestServiceStatus.delegate = self;

        [_requestServiceStatus setPostValue:service_pending forKey:@"service_id"];
        [_requestServiceStatus setPostValue:idUsu forKey:@"id"];
        [_requestServiceStatus setPostValue:token forKey:@"uuid"];
        [_requestServiceStatus setDidFinishSelector:@selector(requestServiceStatusFinished:)];
        [_requestServiceStatus setDidFailSelector:@selector(requestServiceStatusFail:)];
        [_requestServiceStatus startAsynchronous];

    }else if (type == TYSTaxiTypeTaxiInfo){

        if(_requestTaxiInfo)
        {

            [_requestTaxiInfo clearDelegatesAndCancel];
            self.requestTaxiInfo = nil;

        }

        NSString *idTaxista = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestTaxiInfo = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_TAXI_INFO];
        _requestTaxiInfo.delegate = self;
        [_requestTaxiInfo setPostValue:idTaxista forKey:@"driver_id"];
        [_requestTaxiInfo setPostValue:idUsu forKey:@"id"];
        [_requestTaxiInfo setPostValue:token forKey:@"uuid"];
        [_requestTaxiInfo setDidFinishSelector:@selector(requestTaxiInfoFinished:)];
        [_requestTaxiInfo setDidFailSelector:@selector(requestTaxiFail:)];
        [_requestTaxiInfo startAsynchronous];

    }else if (type == TYSTaxiTypeCancelService)
    {

        if(_requestCancelService)
        {

            [_requestCancelService clearDelegatesAndCancel];
            self.requestCancelService = nil;

        }

        // NSString *service =   (NSString *)object;

        NSString *idUsu   =   [TYUsserProfile UsserInfoForKey:USSER_ID];

        // NSString *token   =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelService = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];

        _requestCancelService.delegate =  self;
        [_requestCancelService setRequestMethod:@"POST"];
//        [_requestCancelService setDidFinishSelector:@selector(CancelServiceFinished:)];
//        [_requestCancelService setDidFailSelector:@selector(CancelServiceFail:)];
        [_requestCancelService startSynchronous];

        NSError *error = [_requestCancelService error];
        if (!error) {
            NSString *response = [_requestCancelService responseString];
            NSLog(@"%@",response);

        }else{
            NSLog(@"%@",[error description]);
        }

    }else if (type == TYSTaxiTypeCancelAutomatic)
    {

        if(_requestCancelAutomatic)
        {

            [_requestCancelAutomatic clearDelegatesAndCancel];
            self.requestCancelAutomatic = nil;

        }

        //NSString *service = (NSString *)object;
        NSString *idUsu   = [TYUsserProfile UsserInfoForKey:USSER_ID];
        //NSString *token   = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSString *url = [URL_SERVICE_CANCEL_SERVICE_NEW stringByReplacingOccurrencesOfString:@"{id_user}" withString:idUsu];

        self.requestCancelAutomatic = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];

        [_requestCancelAutomatic setPostValue:@"1" forKey:@"by_system"];

        [_requestCancelAutomatic startAsynchronous];



    }else if (type == TYSTaxiTypeQualityService){

        if(_requestQualityService)
        {

            [_requestQualityService clearDelegatesAndCancel];
            self.requestQualityService = nil;

        }
        //Aqui esta pendiente aqui vamos USSER_HAVE_SERVICE_PENDING
//        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_SERVICE_ID_FOR_QUALITY];
        NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_LAST_SERVICE];
        NSString *type = (NSString *)object;
        NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        self.requestQualityService = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_QUALITY_SERVICE];
        NSLog(@"URL Qualify %@", URL_SERVICE_QUALITY_SERVICE);
        [_requestQualityService setPostValue:service_pending forKey:@"service_id"];
        NSLog(@"service_id = %@", service_pending);
        [_requestQualityService setPostValue:type forKey:@"qualification"];
        NSLog(@"qualification = %@", type);
        [_requestQualityService setPostValue:idUsu forKey:@"user_id"];
        NSLog(@"user_id = %@", idUsu);
        [_requestQualityService setPostValue:token forKey:@"uuid"];
        NSLog(@"uuid = %@", token);
        [_requestQualityService startAsynchronous];

        [TYUsserProfile SetUsserInfo:@"-1"  ForKey:USSER_HAVE_SERVICE_PENDING];
        [TYUsserProfile SetUsserInfo:@"0"  ForKey:USSER_HAVE_SERVICE_PENDING];

        //[TYUsserProfile SetUsserInfo:@"" ForKey:USSER_LAST_SERVICE];

    }

}


- (void)requestServiceFinished:(ASIHTTPRequest *)request
{

    NSLog(@"FINISHED");

    NSString *response = request.responseString;

    if(response.length)
    {

        [self sendType:TYSTaxiTypeRequestService withResponse:response status:ServiceStatusOk];

    }else
    {

        [self requestServiceFail:nil];

    }

}

- (void)requestServiceFail:(ASIHTTPRequest *)request
{
    NSLog(@"FAIL %@",[request.error description]);
    [self sendType:TYSTaxiTypeRequestService withResponse:nil status:ServiceStatusFailServer];
}

-(void)createAddressStatusFinished:(ASIHTTPRequest *)request{
    NSString *response = request.responseString;
    if (response.length) {
        [self sendType:TYSCreateAddress withResponse:response status:CreateAddressStatusOk];
    }
    else {
        [self requestServiceStatusFail:nil];
    }
}

- (void)createAddressStatusFail:(ASIHTTPRequest *)request{

    [self sendType:TYSCreateAddress withResponse:nil status:CreateAddressStatusFail];

}


-(void)deleteAddressStatusFinished:(ASIHTTPRequest *)request{
    NSString *response = request.responseString;
    if (response.length) {
        [self sendType:TYSDeleteAddress withResponse:response status:DeleteAddressStatusOk];
    }
    else {
        [self requestServiceStatusFail:nil];
    }
}

- (void)deleteAddressStatusFail:(ASIHTTPRequest *)request{

    [self sendType:TYSDeleteAddress withResponse:nil status:DeleteAddressStatusFail];

}










- (void)requestServiceStatusFinished:(ASIHTTPRequest *)request{

    NSString *response = request.responseString;

    if(response.length)
    {

        [self sendType:TYSTaxiTypeServiceStatus withResponse:response status:ServiceStatusOk];

    }else{

        [self requestServiceStatusFail:nil];

    }

}

- (void)requestServiceStatusFail:(ASIHTTPRequest *)request{

    [self sendType:TYSTaxiTypeServiceStatus withResponse:nil status:ServiceStatusOk];

}

- (void)requestTaxiInfoFinished:(ASIHTTPRequest *)request{

    NSLog(@"ENTRA TRAE DOS VECES INFO TAXI--------------------------------------------------------------------------------");

    NSString *response = request.responseString;

    if(response.length)
    {

        [self sendType:TYSTaxiTypeTaxiInfo withResponse:response status:ServiceStatusOk];

    }else{

        [self requestTaxiFail:nil];

    }

}

- (void)requestTaxiFail:(ASIHTTPRequest *)request{

    [self sendType:TYSTaxiTypeTaxiInfo withResponse:nil status:ServiceStatusOk];

}


// create address +
-(void)createAddress:(NSString *)address
               barrio:(NSString *)barrio
                 obs:(NSString *)obs
                 order:(NSString *)order
               name:(NSString *)name
                lat:(NSString *)lat
                lng:(NSString *)lng {
    if(_requestServiceStatus) {
            [_requestServiceStatus clearDelegatesAndCancel];
            self.requestServiceStatus = nil;
    }

    //NSString *service_pending = [TYUsserProfile UsserInfoForKey:USSER_HAVE_SERVICE_PENDING];
    NSString *idUsu =   [TYUsserProfile UsserInfoForKey:USSER_ID];
    //NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

    self.requestServiceStatus = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_CREATE_ADDRESS];
    self.requestServiceStatus.delegate = self;

    [_requestServiceStatus setPostValue:address forKey:@"address"];
    [_requestServiceStatus setPostValue:barrio forKey:@"barrio"];
    [_requestServiceStatus setPostValue:obs forKey:@"obs"];
    [_requestServiceStatus setPostValue:idUsu forKey:@"user_id"];
    [_requestServiceStatus setPostValue:order forKey:@"user_pref_order"];
    [_requestServiceStatus setPostValue:lat forKey:@"lat"];
    [_requestServiceStatus setPostValue:lng forKey:@"lng"];
    [_requestServiceStatus setPostValue:name forKey:@"nombre"];

    [_requestServiceStatus setDidFinishSelector:@selector(createAddressStatusFinished:)];
    [_requestServiceStatus setDidFailSelector:@selector(createAddressStatusFail:)];
    [_requestServiceStatus startAsynchronous];

}
// create address -


// delete address +
-(void)deleteAddress:(NSString *) addressId {
    if(_requestServiceStatus) {
            [_requestServiceStatus clearDelegatesAndCancel];
            self.requestServiceStatus = nil;
    }

    self.requestServiceStatus = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_DELETE_ADDRESS];
    self.requestServiceStatus.delegate = self;

    [_requestServiceStatus setPostValue:addressId forKey:@"address_id"];

    [_requestServiceStatus setDidFinishSelector:@selector(deleteAddressStatusFinished:)];
    [_requestServiceStatus setDidFailSelector:@selector(deleteAddressStatusFail:)];
    [_requestServiceStatus startAsynchronous];

}
// delete address -

#pragma mark -
#pragma mark - ServicesDelegate

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status{

    //NSLog(@" RESPUESTA :: %@", response);

    if(type == TYSTaxiTypeRequestService)
    {

        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *values = [response JSONValue];

            if(values)
            {

                //[self makeLogicRequestService:values];

            }else{

                //[self clearservicepending];

                //[self sendDelegateFailWithRequestType:type];

            }

        }else{

            //[self sendDelegateFailWithRequestType:type];

        }


    }else if (type == TYSTaxiTypeServiceStatus){


        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *dictionary = [response JSONValue];

            if(dictionary){

                //[self makeLogicServiceStatusWithDictionary:dictionary];

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

                //[self makeLogigTaxiInfoWithDictionary:dic];

            }

        }

    }else if(type ==  TYSTaxiTypeCancelService)
    {
        if(status == ServiceStatusOk)
        {

            NSMutableDictionary *dic = [response JSONValue];

            if (dic)
            {
                //[self makelogicCancelService:dic];
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




- (void)CancelServiceFinished:(ASIHTTPRequest *)request{

    NSString *response = request.responseString;

    NSLog(@"%@", response);


    if(response.length)
    {

        [self sendType:TYSTaxiTypeCancelService withResponse:response status:ServiceStatusOk];

    }else{

        [self requestTaxiFail:nil];

    }

}

- (void)CancelServiceFail:(ASIHTTPRequest *)request
{

     UIAlertView *alert =

    [[UIAlertView alloc] initWithTitle:@"Importante"
                               message:@"El servicio no pudo ser cancelado."
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [self requestTaxiType:TYSTaxiTypeCancelService object:nil];
}
@end
