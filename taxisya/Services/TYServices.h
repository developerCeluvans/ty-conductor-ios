//
//  TYServices.h
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "NSString+MD5Addition.h"

// desarrollo
//#define SERVICES                            @"http://www.taxisya.co/dev/"
// producción
#define SERVICES                            @"http://www.taxisya.co/"

#define METHOD_LOGIN_REGISTER               @"public/user/register"
#define METHOD_LOGIN_UPDATE                 @"public/user/update"
#define METHOD_LOGIN_LOGIN                  @"public/user/login"
#define METHOD_USER_OLD_ADDRESS             @"public/address/byuser"
#define METHOD_USER_CREATE_ADDRESS          @"public/address/create"
#define METHOD_USER_DELETE_ADDRESS          @"public/address/delete"

#define METHOD_REQUEST_SERVICE              @"public/service/request"
#define METHOD_REQUEST_SERVICE_STATUS       @"public/service/status"
#define METHOD_TAXI_INFO                    @"public/driver/view"
#define METHOD_CANCEL_SERVICE               @"public/service/cancel"
#define METHOD_CANCEL_AUTOMATIC             @"public/service/systemcancel"
#define METHOD_QUALITY_SERVICE              @"public/service/score"
// desarrollo 
//#define METHOD_MAKE_SCHEDULE                @"http://www.taxisya.co/dev/public/schedule/create"
// producción
#define METHOD_MAKE_SCHEDULE                @"http://www.taxisya.co/public/schedule/create"

#define METHOD_CANCEL_SCHEDULE              @"public/schedule/cancel"
#define MEHOTD_FINISH_SCHEDULE              @"public/schedule/finish"
#define MEHOTD_USER_SCHEDULE                @"public/schedule/user"
#define METHOD_USER_HISTORY                 @"public/service/user2"
#define METHOD_USER_HISTORY_DETAIL          @"public/service/user2"

#define METHOD_USER_RECOVERY_EMAIL         @"public/forgotten"
#define METHOD_USER_RECOVERY_EMAIL_CHECK   @"public/user/pwd/confirm"

/* NEW API */

// desarrollo
//#define METHOD_REQUEST_SERVICE_NEW          @"http://www.taxisya.co:3701/service/request"
// producción
#define METHOD_REQUEST_SERVICE_NEW          @"http://www.taxisya.co:3700/service/request"


#define METHOD_REQUEST_SERVICE_NEW_ADDRESS  @"public/v2/user/{id_user}/requestservice_address"

#define METHOD_CANCEL_SERVICE_NEW           @"public/v2/user/{id_user}/cancelservice"
#define METHOD_DRIVER_POSTION               @"public/v2/driver/{id_user}/details"



//#define URL_SERVICE_REQUEST_SERVICE_NEW     [NSString stringWithFormat:@"%@%@", SERVICES, METHOD_REQUEST_SERVICE_NEW]
#define URL_SERVICE_REQUEST_SERVICE_NEW     [NSString stringWithFormat:@"%@", METHOD_REQUEST_SERVICE_NEW]
#define URL_SERVICE_REQUEST_SERVICE_NEW_ADDRESS      [NSString stringWithFormat:@"%@%@", SERVICES, METHOD_REQUEST_SERVICE_NEW_ADDRESS]

#define URL_SERVICE_CANCEL_SERVICE_NEW      [NSString stringWithFormat:@"%@%@", SERVICES, METHOD_CANCEL_SERVICE_NEW]
#define URL_SERVICE_DRIVER_POSTION          [NSString stringWithFormat:@"%@%@", SERVICES, METHOD_DRIVER_POSTION]

/* -- -- -- */

#define URL_SERVICE_LOGIN_RECOVERY_EMAIL    [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_RECOVERY_EMAIL]]
#define URL_SERVICE_LOGIN_RECOVERY_EMAIL_CHECK [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_RECOVERY_EMAIL_CHECK]]

#define URL_SERVICE_LOGIN_REGISTER          [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_LOGIN_REGISTER]]
#define URL_SERVICE_LOGIN_UPDATE            [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_LOGIN_UPDATE]]
#define URL_SERVICE_LOGIN_LOGIN             [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_LOGIN_LOGIN]]

#define URL_SERVICE_USER_OLD_ADDRESS        [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_OLD_ADDRESS]]

#define URL_SERVICE_USER_CREATE_ADDRESS     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_CREATE_ADDRESS]]
#define URL_SERVICE_USER_DELETE_ADDRESS     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_DELETE_ADDRESS]]

#define URL_SERVICE_REQUEST_SERVICE         [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_REQUEST_SERVICE]]
#define URL_SERVICE_REQUEST_SERVICE_STATUS  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_REQUEST_SERVICE_STATUS]]
#define URL_SERVICE_TAXI_INFO               [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_TAXI_INFO]]
#define URL_SERVICE_CANCEL_SERVICE          [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_CANCEL_SERVICE]]
#define URL_SERVICE_CANCEL_SERVICE_AUTO     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_CANCEL_AUTOMATIC]]
#define URL_SERVICE_QUALITY_SERVICE         [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_QUALITY_SERVICE]]
#define URL_SERVICE_MAKE_SCHEDULE           [NSURL URLWithString:[NSString stringWithFormat:@"%@",  METHOD_MAKE_SCHEDULE]]
#define URL_SERVICE_CANCEL_SCHEDULE         [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_CANCEL_SCHEDULE]]
#define URL_SERVICE_FINISH_SCHEDULE         [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, MEHOTD_FINISH_SCHEDULE]]
#define URL_SERVICE_USER_SCHEDULE           [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, MEHOTD_USER_SCHEDULE]]
#define URL_SERVICE_USER_HISTORY            [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_HISTORY]]
#define URL_SERVICE_USER_HISTORY_DETAIL     [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, METHOD_USER_HISTORY_DETAIL]]



typedef enum{

    ServiceStatusOk,
    ServiceStatusFailConnection,
    ServiceStatusFailServer,
    CreateAddressStatusOk,
    CreateAddressStatusFail,
    DeleteAddressStatusOk,
    DeleteAddressStatusFail

}ServiceStatus;

@interface TYServices : NSObject

@end
