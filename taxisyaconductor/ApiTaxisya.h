//
//  ApiTaxisya.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void(^ResponseBlock)(BOOL success,id response);

@interface ApiTaxisya : AFHTTPRequestOperationManager

+(instancetype)sharedInstance;

-(void)driverRegister:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverLogin:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverLogout:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverEnable:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverDisable:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverUpdateCar:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverArrived:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverCancelService:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)serviceConfirm:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)serviceFinish:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)serviceStatus:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)servicesHistory:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverIsLogged:(NSDictionary *)parameters success:(ResponseBlock)success;

-(void)countries:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)departments:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)cities:(NSDictionary *)parameters success:(ResponseBlock)success;

-(void)recoverPassword:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)codeConfirm:(NSDictionary *)parameters success:(ResponseBlock)success;
-(void)driverSendPosition:(NSDictionary *)parameters success:(ResponseBlock)success;



@end
