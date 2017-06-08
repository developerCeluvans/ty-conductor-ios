//
//  TYSUsser.m
//  taxisya
//
//  Created by NTTak3 on 3/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYSUsser.h"
#import "TYUsserProfile.h"

@implementation TYSUsser

@synthesize delegate                    = _delegate;
@synthesize requestUsserOldAddress      = _requestUsserOldAddress;
@synthesize requestUsserHistory         = _requestUsserHistory;
@synthesize requestUsserHistoryDetail   = _requestUsserHistoryDetail;
@synthesize requestUsserAgend           = _requestUsserAgend;
@synthesize requestUsserAgendHistory    = _requestUsserAgendHistory;


- (id)initwithDelegate:(id<TYSUsserDelegate>)delegate{

    if(self == [super init]){

        self.delegate = delegate;

    }

    return self;

}

- (void)dealloc
{

    [self clearDelegateAndCancel];

}

- (void)sendType:(TYSUsserType)type withResponse:(NSString *)response status:(ServiceStatus)status
{
    [_delegate TYSUsserType:type response:response status:status];

}

- (void)requestUsserType:(TYSUsserType)type object:(id)object{

    if(type == TYSUsserTypeOldAddress){

        if(_requestUsserOldAddress){

            [self.requestUsserOldAddress clearDelegatesAndCancel];
            self.requestUsserOldAddress = nil;

        }

        NSString *usser_id = [TYUsserProfile UsserInfoForKey:USSER_ID];



        self.requestUsserOldAddress = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_OLD_ADDRESS];
        [_requestUsserOldAddress setDelegate:self];
        [_requestUsserOldAddress setPostValue:usser_id forKey:@"user_id"];
        [_requestUsserOldAddress setPostValue:[TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN] forKey:@"uuid"];
        [_requestUsserOldAddress setDidFinishSelector:@selector(requestUsserOldAddressFinished:)];
        [_requestUsserOldAddress setDidFailSelector:@selector(requestUsserOldAddressFail:)];
        [_requestUsserOldAddress startAsynchronous];

    }else if (type == TYSUsserTypeHistory){

        if(_requestUsserHistory){

            [_requestUsserHistory clearDelegatesAndCancel];
            self.requestUsserHistory = nil;

        }

        NSString *idUser = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        NSLog(@"Trayendo Servicios %@", URL_SERVICE_USER_HISTORY);
        self.requestUsserHistory = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_HISTORY];
        _requestUsserHistory.delegate = self;
        [_requestUsserHistory setPostValue:idUser forKey:@"user_id"];
        [_requestUsserHistory setPostValue:token forKey:@"uuid"];
        [_requestUsserHistory setDidFinishSelector:@selector(requestUsserHistoryFinish:)];
        [_requestUsserHistory setDidFailSelector:@selector(requestUsserHistoryFail:)];
        [_requestUsserHistory startAsynchronous];


    }else if (type == TYSUsserTypeHistoryDetail){

        if(_requestUsserHistoryDetail){

            [_requestUsserHistoryDetail clearDelegatesAndCancel];
            self.requestUsserHistoryDetail = nil;

        }


        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:NSMonthCalendarUnit fromDate:[NSDate date]];

        NSString *day = (NSString *)object;
        NSString *month = [NSString stringWithFormat:@"%li", [comps month]];
        NSString *idUser = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token =   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];


        NSLog(@"URL de reclamos %@", URL_SERVICE_USER_HISTORY_DETAIL);
        self.requestUsserHistoryDetail = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_HISTORY_DETAIL];
        _requestUsserHistoryDetail.delegate = self;
        [_requestUsserHistoryDetail setPostValue:idUser forKey:@"user_id"];
        [_requestUsserHistoryDetail setPostValue:month forKey:@"month"];
        [_requestUsserHistoryDetail setPostValue:day forKey:@"day"];
        [_requestUsserHistoryDetail setPostValue:token forKey:@"uuid"];
        [_requestUsserHistoryDetail setDidFailSelector:@selector(requestUsserHistoryDetailFail:)];
        [_requestUsserHistoryDetail setDidFinishSelector:@selector(requestUsserHistoryDetailFinish:)];
        [_requestUsserHistoryDetail startAsynchronous];



    }else if (type == TYSUsserTypeAgend){

        if(_requestUsserAgend){

            [_requestUsserAgend clearDelegatesAndCancel];
            self.requestUsserAgend = nil;

        }

        NSMutableDictionary *dic = (NSMutableDictionary *)object;

        NSString *user_id               = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *service_date_time     = [dic objectForKey:@"service_date_time"];
        NSString *schedule_type         = [dic objectForKey:@"schedule_type"];
//        NSString *address1              = [dic objectForKey:@"address1"];
        NSString *address2              = [dic objectForKey:@"address2"];
//        NSString *address3              = [dic objectForKey:@"address3"];
//        NSString *address4              = [dic objectForKey:@"address4"];
        NSString *address5              = [dic objectForKey:@"address5"];
        NSString *address6              = [dic objectForKey:@"address6"];
        NSString *cityLat               = [dic objectForKey:@"city_lat"];
        NSString *cityLng               = [dic objectForKey:@"city_lng"];
        NSString *destination           = [dic objectForKey:@"destination"];
        NSString *token                 = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

//        NSLog([dic description]);
//        NSLog(user_id);
//        NSLog(token);

        NSLog(@"URL PARA AGENDAMIENO %@", URL_SERVICE_MAKE_SCHEDULE);
        self.requestUsserAgend = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_MAKE_SCHEDULE];
        [_requestUsserAgend setDelegate:self];
        [_requestUsserAgend setPostValue:user_id forKey:@"user_id"];
        [_requestUsserAgend setPostValue:service_date_time forKey:@"service_date_time"];
        [_requestUsserAgend setPostValue:schedule_type forKey:@"schedule_type"];
        //[_requestUsserAgend setPostValue:address1 forKey:@"address_index"];
        //[_requestUsserAgend setPostValue:address2 forKey:@"comp1"];
        [_requestUsserAgend setPostValue:address2 forKey:@"address"];
        //[_requestUsserAgend setPostValue:address3 forKey:@"comp2"];
        //[_requestUsserAgend setPostValue:address4 forKey:@"no"];
        [_requestUsserAgend setPostValue:address5 forKey:@"obs"];
        [_requestUsserAgend setPostValue:address6 forKey:@"barrio"];
        [_requestUsserAgend setPostValue:token forKey:@"uuid"];
        [_requestUsserAgend setPostValue:cityLat forKey:@"city_lat"];
        [_requestUsserAgend setPostValue:cityLng forKey:@"city_lng"];
        [_requestUsserAgend setPostValue:destination forKey:@"destination"];
        [_requestUsserAgend setDidFinishSelector:@selector(requestUsserAgendFinished:)];
        [_requestUsserAgend setDidFailSelector:@selector(requestUsserAgendFail:)];
        [_requestUsserAgend startAsynchronous];

    }else if (type == TYSUsserTypeAgendCancel){

        NSString *schedule_id  = (NSString *)object;
        NSString *user_id               = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token                 = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        ASIFormDataRequest *dirRemove = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_CANCEL_SCHEDULE];
        [dirRemove setDelegate:self];
        [dirRemove setPostValue:schedule_id forKey:@"schedule_id"];
//        [dirRemove addPostValue:schedule_id forKey:@"schedule_id"];
        [dirRemove setPostValue:token forKey:@"uuid"];
        [dirRemove setPostValue:user_id forKey:@"user_id"];
        [dirRemove startAsynchronous];


    }else if (type == TYSUsserTypeAgendFinish){

        NSMutableDictionary *dic = (NSMutableDictionary *)object;

        NSString *schedule_id  = [dic objectForKey:@"schedule_id"];
        NSString *score        = [dic objectForKey:@"score"];
        NSString *user_id               = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token                 = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

        ASIFormDataRequest *dirRemove = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_FINISH_SCHEDULE];
        [dirRemove setDelegate:self];
//        [dirRemove addPostValue:schedule_id forKey:@"schedule_id"];
//        [dirRemove addPostValue:score forKey:@"score"];
        [dirRemove setPostValue:schedule_id forKey:@"schedule_id"];
        [dirRemove setPostValue:score forKey:@"score"];
        [dirRemove setPostValue:token forKey:@"uuid"];
        [dirRemove setPostValue:user_id forKey:@"user_id"];
        [dirRemove startAsynchronous];

    }else if (type == TYSUsserTypeAgendHistory){

        if(_requestUsserAgendHistory){

            [_requestUsserAgendHistory clearDelegatesAndCancel];
            self.requestUsserAgendHistory = nil;

        }

        NSString *user_id  = [TYUsserProfile UsserInfoForKey:USSER_ID];
        NSString *token = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];

//        NSLog(token);
//        NSLog(user_id);


        self.requestUsserAgendHistory = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_USER_SCHEDULE];
        [_requestUsserAgendHistory setDelegate:self];
        [_requestUsserAgendHistory setPostValue:user_id forKey:@"user_id"];
        [_requestUsserAgendHistory setPostValue:token forKey:@"uuid"];
        [_requestUsserAgendHistory setDidFinishSelector:@selector(requestUsserAgendHistoryFinished:)];
        [_requestUsserAgendHistory setDidFailSelector:@selector(requestUsserAgendHistoryFail:)];
        [_requestUsserAgendHistory startAsynchronous];

    }


}

- (void)clearDelegateAndCancel{

    [_requestUsserOldAddress clearDelegatesAndCancel];
    self.requestUsserOldAddress = nil;

    [_requestUsserHistory clearDelegatesAndCancel];
    self.requestUsserHistory = nil;

    [_requestUsserHistoryDetail clearDelegatesAndCancel];
    self.requestUsserHistoryDetail = nil;

    [_requestUsserAgend clearDelegatesAndCancel];
    self.requestUsserAgend = nil;

    [_requestUsserAgendHistory clearDelegatesAndCancel];
    self.requestUsserAgendHistory = nil;


}


- (void)requestUsserOldAddressFinished:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];

    if(response && response.length){

        [self sendType:TYSUsserTypeOldAddress withResponse:response status:ServiceStatusOk];

    }else{

        [self sendType:TYSUsserTypeOldAddress withResponse:response status:ServiceStatusFailConnection];

    }

}

- (void)requestUsserOldAddressFail:(ASIHTTPRequest *)request{

    [self sendType:TYSUsserTypeOldAddress withResponse:nil status:ServiceStatusFailConnection];

}


- (void)requestUsserAgendFinished:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];

    if(response && response.length){

        [self sendType:TYSUsserTypeAgend withResponse:response status:ServiceStatusOk];

    }else{

        [self sendType:TYSUsserTypeAgend withResponse:response status:ServiceStatusFailConnection];

    }


}

- (void)requestUsserAgendFail:(ASIHTTPRequest *)request{


    NSLog(@"%@",[request error].localizedDescription);

    [self sendType:TYSUsserTypeAgend withResponse:nil status:ServiceStatusFailConnection];

}

- (void)requestUsserAgendHistoryFinished:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];

    if(response && response.length){

        [self sendType:TYSUsserTypeAgendHistory withResponse:response status:ServiceStatusOk];

    }else{

        [self sendType:TYSUsserTypeAgendHistory withResponse:response status:ServiceStatusFailConnection];

    }


}

- (void)requestUsserAgendHistoryFail:(ASIHTTPRequest *)request{

    [self sendType:TYSUsserTypeAgendHistory withResponse:nil status:ServiceStatusFailConnection];

}

- (void)requestUsserHistoryFinish:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];

    if(response && response.length){

        [self sendType:TYSUsserTypeHistory withResponse:response status:ServiceStatusOk];

    }else{

        [self sendType:TYSUsserTypeHistory withResponse:response status:ServiceStatusFailConnection];

    }


}

- (void)requestUsserHistoryFail:(ASIHTTPRequest *)request{

    [self sendType:TYSUsserTypeHistory withResponse:nil status:ServiceStatusFailConnection];

}


- (void)requestUsserHistoryDetailFinish:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];

    if(response && response.length){

        [self sendType:TYSUsserTypeHistoryDetail withResponse:response status:ServiceStatusOk];

    }else{

        [self sendType:TYSUsserTypeHistoryDetail withResponse:response status:ServiceStatusFailConnection];

    }


}

- (void)requestUsserHistoryDetailFail:(ASIHTTPRequest *)request{

    [self sendType:TYSUsserTypeHistoryDetail withResponse:nil status:ServiceStatusFailConnection];

}


@end
