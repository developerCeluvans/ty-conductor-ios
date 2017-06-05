//
//  ApiTaxisya.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "ApiTaxisya.h"
#import <MBProgressHUD/MBProgressHUD.h>

// desarrollo
//NSString *const urlBase = @"http://104.237.131.48/dev/public/";
// producción
NSString *const urlBase = @"http://www.taxisya.co/public/";

@implementation ApiTaxisya

+(instancetype)sharedInstance {
    static dispatch_once_t onceQueue;
    static ApiTaxisya *__sharedInstance = nil;
    dispatch_once(&onceQueue, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

-(void)driverRegister:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"driver/register_driver"];

    [self postRequest2:endpoint parameters:parameters success:success];

}

-(void)driverLogin:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"driver/login"];
    [self postRequest:endpoint parameters:parameters success:success];
}

-(void)driverLogout:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"driver/logout"];

    [self postRequest:endpoint
           parameters:@{@"login": parameters[@"login"],@"uuid": parameters[@"uuid"]}
              success:success];
}

-(void)driverEnable:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"] ,@"/enable"];

    [self postRequest:endpoint
           parameters:@{@"lat": parameters[@"lat"],@"lng": parameters[@"lng"],@"uuid": parameters[@"uuid"]}
              success:success];
}

-(void)driverDisable:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"] ,@"/disable"];

    [self postRequest:endpoint parameters:@{@"uuid": parameters[@"uuid"]} success:success];
}

-(void)driverUpdateCar:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"driver/updatecar"];

    [self postRequest:endpoint parameters:parameters success:success];
}

-(void)driverArrived:(NSDictionary *)parameters success:(ResponseBlock)success {
//    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"] ,@"/arrive"];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"service/arrived"];


    //[self postRequest:endpoint parameters:nil success:success];
    [self postRequest:endpoint parameters:parameters success:success];
}

-(void)driverCancelService:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"] ,@"/cancelservice"];

    [self postRequest:endpoint parameters:nil success:success];
}

-(void)driverSendPosition:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"], @"/updateposition"];

   [self postRequest:endpoint parameters:parameters success:success];
}

-(void)driverIsLogged:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"driver/islogued"];

    [self postRequest:endpoint
           parameters:@{@"driver_id": parameters[@"driver_id"],@"car_id": parameters[@"car_id"]}
              success:success];
}

-(void)serviceConfirm:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",urlBase,@"v2/driver/", parameters[@"driver_id"] ,@"/confirmservice"];

    [self postRequest:endpoint
           parameters:@{@"service_id": parameters[@"service_id"]}
              success:success];
}

-(void)serviceFinish:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"service/finish2"];

    [self postRequest:endpoint
           parameters:@{@"driver_id": parameters[@"driver_id"],@"service_id": parameters[@"service_id"],@"to_lat": parameters[@"to_lat"],@"to_lng": parameters[@"to_lng"]}
              success:success];
}

-(void)serviceStatus:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"service/status"];

//    [self postRequest:endpoint
//            parameters:@{@"driver_id": parameters[@"driver_id"],
//                         @"service_id": parameters[@"service_id"]}
//               success:success];
    [self postRequest:endpoint
           parameters:parameters
              success:success];
    NSLog(@"serviceStatus: %@ ",@{@"driver_id": parameters[@"driver_id"]});

}

-(void)servicesHistory:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"service/driver"];

    [self postRequest:endpoint
           parameters:@{@"driver_id": parameters[@"driver_id"],@"uuid": parameters[@"uuid"]}
              success:success];
}

-(void)countries:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"country"];
    [self postRequest:endpoint parameters:nil success:success];
}

-(void)departments:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"department"];
    [self postRequest:endpoint parameters:nil success:success];
}

-(void)cities:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"city"];
    [self postRequest:endpoint parameters:nil success:success];
}

-(void)recoverPassword:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"forgotten"];

    [self postRequest:endpoint parameters:parameters success:success];
}

-(void)codeConfirm:(NSDictionary *)parameters success:(ResponseBlock)success {
    NSString *endpoint = [NSString stringWithFormat:@"%@%@",urlBase,@"user/pwd/confirm"];
    [self postRequest:endpoint parameters:parameters success:success];
}

-(void)postRequest:(NSString *)endpoint parameters:(NSDictionary *)parameters success:(ResponseBlock)success {
    [self POST:endpoint parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"RESPONSE %@",responseObject);
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  success(YES,responseObject);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //NSLog(@"Error: %@", error);
              success(NO,error);
          }];
}

-(void)postRequest2:(NSString *)endpoint parameters:(NSDictionary *)parameters success:(ResponseBlock)success {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *requestOperation = [manager POST:endpoint
                                                  parameters:parameters
                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(YES,responseObject);
            }
        //Your Business Operation.
        NSLog(@"operation success: %@\n %@", operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        success(NO,error);
    }];

    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            //Upload Progress bar here
            NSLog(@"progress updated(percentDone) : %f", percentDone);
        }];
}


@end
