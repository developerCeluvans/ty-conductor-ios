//
//  TYUsserProfile.h
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "Base.h"

struct Usser {
    __unsafe_unretained NSString *usserId;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *surname;
    __unsafe_unretained NSString *email;
    __unsafe_unretained NSString *password;
    __unsafe_unretained NSString *cellPhone;
};
typedef struct Usser Usser;

CG_INLINE Usser
UsserMake(NSString *usserID, NSString *name, NSString *surname, NSString *email, NSString *cellPhone, NSString *password)
{
    Usser u;
    u.usserId = usserID;
    u.name = name;
    u.surname = surname;
    u.password = password;
    return u;
}


#define USSER_ID                        @"UsserId"
#define USSER_NAME                      @"UsserName"
#define USSER_SURNAME                   @"UsserSurname"
#define USSER_EMAIL                     @"UsserEmail"
#define USSER_CELLPHONE                 @"UsserCellPhone"
#define USSER_PASSWORD                  @"UsserPassword"

#define USSER_DEVICE_PUSH_TOKEN         @"UsserDevicePushToken"

#define USSER_HAVE_SERVICE_PENDING      @"usser_have_service_pending"
#define USSER_LAST_SERVICE           @"usser_current_service"
#define USSER_SERVICE_ID_FOR_QUALITY    @"ID_SERVICE"
#define USSER_CARD_REFERENCE            @"CARD_REFERENCE"


@interface TYUsserProfile : Base

+ (void)CreateUsserWithUsserId:(NSString *)usserID
                          name:(NSString *)name
                       surname:(NSString *)surname
                         email:(NSString *)email
                     cellPhone:(NSString *)cellPhone
                      password:(NSString *)password;

+ (Usser)GetCurrentUsser;

+ (BOOL)CheckIfUsserIsRegistred:(Usser)usser;

+ (NSString *)UsserInfoForKey:(NSString *)key;

+ (void)SetUsserInfo:(NSString *)info ForKey:(NSString *)key;

+ (BOOL)IsUsserRegistred;

+ (void)RemoveUsserWithUsser;

@end
