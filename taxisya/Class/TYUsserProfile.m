//
//  TYUsserProfile.m
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYUsserProfile.h"

@implementation TYUsserProfile

+ (void)CreateUsserWithUsserId:(NSString *)usserID name:(NSString *)name surname:(NSString *)surname email:(NSString *)email cellPhone:(NSString *)cellPhone password:(NSString *)password{
    
    [self SetUsserInfo:usserID ForKey:USSER_ID];
    [self SetUsserInfo:name ForKey:USSER_NAME];
    [self SetUsserInfo:surname ForKey:USSER_SURNAME];
    [self SetUsserInfo:email ForKey:USSER_EMAIL];
    [self SetUsserInfo:cellPhone ForKey:USSER_CELLPHONE];
    [self SetUsserInfo:password ForKey:USSER_PASSWORD];

}

+ (void)RemoveUsserWithUsser {
    
    [self SetUsserInfo:@"" ForKey:USSER_ID];
    [self SetUsserInfo:@"" ForKey:USSER_NAME];
    [self SetUsserInfo:@"" ForKey:USSER_SURNAME];
    [self SetUsserInfo:@"" ForKey:USSER_EMAIL];
    [self SetUsserInfo:@"" ForKey:USSER_CELLPHONE];
    [self SetUsserInfo:@"" ForKey:USSER_PASSWORD];
    [self SetUsserInfo:@"" ForKey:USSER_LAST_SERVICE];
    
}



+ (Usser)GetCurrentUsser{

    NSString *usserID = [TYUsserProfile UsserInfoForKey:USSER_ID];
    NSString *name = [TYUsserProfile UsserInfoForKey:USSER_NAME];
    NSString *surname = [TYUsserProfile UsserInfoForKey:USSER_SURNAME];
    NSString *email = [TYUsserProfile UsserInfoForKey:USSER_EMAIL];
    NSString *pass = [TYUsserProfile UsserInfoForKey:USSER_PASSWORD];
    NSString *cellPhone = [TYUsserProfile UsserInfoForKey:USSER_CELLPHONE];
    
    if(!usserID)usserID = @"";
    if(!name)name = @"";
    if(!surname)surname = @"";
    if(!email)email = @"";
    if(!cellPhone)cellPhone = @"";
    if(!pass)pass = @"";
    
    
    return  UsserMake(usserID ,name, surname, email, cellPhone, pass);
}

+ (BOOL)CheckIfUsserIsRegistred:(Usser)usser
{
    
    if(usser.name.length > 0 && usser.surname.length > 0 && usser.email.length > 0 && usser.cellPhone.length > 0 && usser.password.length > 0 && usser.usserId.length > 0){
    
        return YES;
    
    }

    return NO;

}

+ (NSString *)UsserInfoForKey:(NSString *)key
{

    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+ (void)SetUsserInfo:(NSString *)info ForKey:(NSString *)key
{

    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];

}

+ (BOOL)IsUsserRegistred
{
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_NAME];
    NSString *usserid = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_ID];
    
    if(name.length && usserid.length){
    
        return YES;
    
    }
    
    return NO;

}



@end
