//
//  HTTPSyncRequest.m
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import "HTTPSyncRequest.h"
#import "TYServices.h"

@implementation HTTPSyncRequest

static BOOL isSync;


- (NSArray *)sortDataForSend:(NSDictionary *)data {
    NSMutableArray *arrayData = [[NSMutableArray alloc] initWithCapacity:[data count]];
    for (NSString *entityName in data) {
        [arrayData addObject:[NSDictionary dictionaryWithObjectsAndKeys:data[entityName], entityName, nil]];
    }
    return arrayData;
}

- (void)didCompleteWithError:(NSError *)error {
    isSync = NO;
//    [_context reset];
}

- (void)didCompleteReceiveData:(NSDictionary *)data {
//    if([data[@"success"] boolValue]){
//        [_context saveToPersistentStoreNotSync];
//    }else{
//        [_context reset];
//    }
//    isSync = NO;
}


- (void)didCompleteRequest:(int)request withError:(NSError *)error {

}

- (void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {

}

- (BOOL)validateVersion:(id <HTTPRequestDelegate>)delegate {
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/app/versions", SERVICES]];
    [request setDelegate:delegate];
    [request configureMethodPOST];
    [request setOperation:0];
    [request resume];
    return YES;
}

- (BOOL)validateSession:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/user/islogued", SERVICES]];
    [request setDelegate:delegate];
    [request configureContentTypeJSON];
    NSLog(@"Data Service Status %@", data);
    [request sendBodyData:data];
    [request setOperation:3];
    [request resume];
    return YES;
}

- (BOOL)validateLogout:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/user/logout", SERVICES]];
    [request setDelegate:delegate];
    [request configureMethodPOST];
    NSLog(@"LOGOUT %@", data);
    [request sendBodyData:data];
    [request setOperation:4];
    [request resume];
    return YES;
}

- (BOOL)validateCurrentServiceData:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    NSLog(@"%@public/service/status", SERVICES);
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/service/status", SERVICES]];
    [request setDelegate:delegate];
    [request configureMethodPOST];
    //[request configureContentTypeJSON];
//    NSString *dataString = [NSString stringWithFormat:@"user_id=%@",[data objectForKey:@"user_id"]];
    NSString *dataString = nil;
    if ([data objectForKey:@"service_id"] != nil) {
        dataString = [NSString stringWithFormat:@"user_id=%@ &service_id=%@  ",
        [data objectForKey:@"user_id"], [data objectForKey:@"service_id"] ];
    }
    else {
        dataString = [NSString stringWithFormat:@"user_id=%@",[data objectForKey:@"user_id"]];        
    }

    NSLog(@"ENVIANDO %@", data);
    NSLog(@"DATA SCTRING %@", dataString);
    [request sendBodyDataString:dataString];
    //[request sendBodyData:data];
    [request setOperation:1];
    [request resume];
    return YES;
}

- (BOOL)createReclamo:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/complain/create?service_id=%@&descript=%@", SERVICES, data[@"service_id"], [data[@"descript"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    [request setDelegate:delegate];
    [request configureContentTypeJSON];
    [request sendBodyData:data];
    [request setOperation:2];
    [request resume];
    return YES;
}

- (BOOL)qualificationService:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    NSLog(@"qualificationService %@public/service/score", SERVICES);
    NSLog(@"qualificationService %@",data);
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/service/score", SERVICES]];
    [request setDelegate:delegate];
    NSLog(@"ENVIANDO %@", data);
    //[request sendBodyData:data];
    
    NSString *dataString = [NSString stringWithFormat:@"service_id=%@&user_id=%@&qualification=%@&uuid=%@",
                            [data objectForKey:@"service_id"],
                            [data objectForKey:@"user_id"],
                            [data objectForKey:@"qualification"],
                            [data objectForKey:@"uuid"]];
    NSLog(@"DATA SCTRING %@", dataString);
    [request sendBodyDataString:dataString];
    
    [request configureMethodPOST];
    [request setOperation:5];
    [request resume];
    return YES;
}


- (BOOL)cancelService:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    NSLog(@"cancelService %@public/v2/user/%@/cancelservice", SERVICES,[data objectForKey:@"user_id"]);
    NSLog(@"cancelService %@",data);

    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/v2/user/%@/cancelservice", SERVICES, [data objectForKey:@"user_id"]]];

    [request setDelegate:delegate];
    [request configureMethodPOST];
    [request setOperation:6];
    [request resume];
    return YES;
}

- (BOOL)checkTicket:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate {
    NSLog(@"checkTicket %@public/service/ticket", SERVICES);
    NSLog(@"checkTicket %@",data);
    HTTPRequest *request = [[HTTPRequest alloc] initWithURL:[NSString stringWithFormat:@"%@public/service/ticket", SERVICES]];
    [request setDelegate:delegate];
    NSLog(@"ENVIANDO %@", data);
    NSString *dataString = [NSString stringWithFormat:@"ticket=%@",[data objectForKey:@"ticket"]];
    NSLog(@"DATA SCTRING %@", dataString);
    [request sendBodyDataString:dataString];
    [request configureMethodPOST];
    [request setOperation:10];
    [request resume];
    return YES;
}
@end
