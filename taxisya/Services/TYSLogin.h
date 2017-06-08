//
//  TYSLogin.h
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYServices.h"

typedef enum{
    
    TYSLoginTypeRegister,
    TYSLoginTypeLogin,
    TYSLoginTypeRecoveryEmail,
    TYSloginTypeRecoveryEmailCheck,

} TYSLoginType;

@protocol TYSLoginDelegate;

@interface TYSLogin : NSObject

@property (nonatomic, assign) id <TYSLoginDelegate>                     delegate;
@property (nonatomic, strong) ASIFormDataRequest                        *requestLogin;
@property (nonatomic, strong) ASIFormDataRequest                        *requestRegister;
@property (nonatomic, strong) ASIFormDataRequest                        *requestRecoveryEmail;
@property (nonatomic, strong) ASIFormDataRequest                        *requestRecoveryEmailCheck;

- (id)initwithDelegate:(id <TYSLoginDelegate>)delegate;

- (void)requestLoginType:(TYSLoginType)type object:(id)object;

- (void)clearDelegateAndCancel;

@end


@protocol TYSLoginDelegate <NSObject>

- (void)TYSLoginType:(TYSLoginType)type response:(NSString *)response status:(ServiceStatus)status;

@end