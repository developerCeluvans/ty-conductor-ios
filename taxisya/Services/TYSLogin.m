//
//  TYSLogin.m
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYSLogin.h"
#import "TYFormatter.h"
#import "TYUsserProfile.h"

@implementation TYSLogin

@synthesize delegate                = _delegate;
@synthesize requestLogin            = _requestLogin;
@synthesize requestRegister         = _requestRegister;

- (void)dealloc
{
 
    [self clearDelegateAndCancel];

}

- (void)sendType:(TYSLoginType)type withResponse:(NSString *)response status:(ServiceStatus)status
{
    
    [_delegate TYSLoginType:type response:response status:status];
    
}

- (id)initwithDelegate:(id <TYSLoginDelegate>)delegate
{

    if(self == [super init]){
    
        self.delegate = delegate;
    
    }
    
    return self;

}

- (void)clearDelegateAndCancel{
    
    [_requestRegister clearDelegatesAndCancel];
    self.requestRegister = nil;
    [_requestLogin clearDelegatesAndCancel];
    self.requestRegister = nil;
    [_requestRecoveryEmail clearDelegatesAndCancel];
    self.requestRecoveryEmail = nil;
    [_requestRecoveryEmailCheck clearDelegatesAndCancel];
    self.requestRecoveryEmailCheck = nil;
    
}

- (void)requestLoginType:(TYSLoginType)type object:(id)object
{
    
    if(type == TYSLoginTypeLogin){
    
        if(_requestLogin){
        
            [_requestLogin clearDelegatesAndCancel];
            self.requestLogin = nil;
        
        }
        
        NSMutableDictionary *dic = (NSMutableDictionary *)object;
        NSString *email = [dic objectForKey:@"login"];
        NSString *pass = [[dic objectForKey:@"pwd"] MD5String];
        NSString *udid = [TYFormatter FormatterGetDeviceIdentifier];
        NSString *token = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN]; //TOKEN
        NSString *type = @"1";

        if(!udid)udid = @"";
        
        self.requestLogin = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_LOGIN_LOGIN];
        self.requestLogin.delegate = self;
        [_requestLogin setPostValue:email forKey:@"login"];
        [_requestLogin setPostValue:pass forKey:@"pwd"];
        [_requestLogin setPostValue:token forKey:@"uuid"];
        [_requestLogin setPostValue:type forKey:@"type"];
        [_requestLogin setPostValue:token forKey:@"token"];
        [_requestLogin setDidFinishSelector:@selector(requestLoginFinished:)];
        [_requestLogin setDidFailSelector:@selector(requestLoginFail:)];
        
        NSLog(@"LOGIN-------------------------%@", [_requestLogin valueForKey:@"postData"]);
        
        [_requestLogin startAsynchronous];
    
    }else if (type == TYSLoginTypeRegister){
    
        if(_requestRegister){
        
            [_requestRegister clearDelegatesAndCancel];
            self.requestRegister = nil;
        
        }
        
        NSMutableDictionary *dic = (NSMutableDictionary *)object;
        NSString *fname = [dic objectForKey:@"name"];
        NSString *lname = [dic objectForKey:@"lastname"];
        NSString *email = [dic objectForKey:@"email"];
        NSString *phone = [dic objectForKey:@"cellphone"];
        NSString *pswd = [dic objectForKey:@"pwd"];
        NSString *token = [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN];
        NSString *udid = [TYFormatter FormatterGetDeviceIdentifier];
        NSString *type = @"1";
        
        if(!udid)udid = @"";
        if(!token)token = @"";
        
        if([TYUsserProfile IsUsserRegistred]){
                self.requestRegister = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_LOGIN_UPDATE];
            [_requestRegister setPostValue:[pswd MD5String] forKey:@"pwd"];
        }else{
                self.requestRegister = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_LOGIN_REGISTER];
            [_requestRegister setPostValue:pswd forKey:@"pwd"];
        }

        self.requestRegister.delegate = self;
        [_requestRegister setPostValue:fname forKey:@"name"];
        [_requestRegister setPostValue:lname forKey:@"lastname"];
        [_requestRegister setPostValue:email forKey:@"email"];
        [_requestRegister setPostValue:email forKey:@"login"];
        [_requestRegister setPostValue:phone forKey:@"cellphone"];
        
        [_requestRegister setPostValue:token forKey:@"token"];
        [_requestRegister setPostValue:token forKey:@"uuid"];
        [_requestRegister setPostValue:type forKey:@"type"];
        [_requestRegister setDidFinishSelector:@selector(requestRegisterFinished:)];
        [_requestRegister setDidFailSelector:@selector(requestRegisterFail:)];
        [_requestRegister startAsynchronous];
    
    }else if (type == TYSLoginTypeRecoveryEmail){
    
        if(_requestRecoveryEmail){
            [_requestRecoveryEmail clearDelegatesAndCancel];
            self.requestRecoveryEmail = nil;
        }
        
        NSString *email = (NSString *)object;
        
        self.requestRecoveryEmail = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_LOGIN_RECOVERY_EMAIL];
        self.requestRecoveryEmail.delegate = self;
        [_requestRecoveryEmail setPostValue:email forKey:@"email"];
        [_requestRecoveryEmail setDidFinishSelector:@selector(requestRecoveryEmailFinished:)];
        [_requestRecoveryEmail setDidFailSelector:@selector(requestRecoveryEmailFail:)];
        [_requestRecoveryEmail startAsynchronous];
    
    }else if (type == TYSloginTypeRecoveryEmailCheck){
    
        if(_requestRecoveryEmailCheck){
            [_requestRecoveryEmailCheck clearDelegatesAndCancel];
            self.requestRecoveryEmailCheck = nil;
        }
        
        NSMutableDictionary *dic = (NSMutableDictionary *)object;
        
        NSString *email =   [dic objectForKey:@"email"];
        NSString *code =    [dic objectForKey:@"token"];
        NSString *pass =    [[dic objectForKey:@"password"] MD5String];
        
        self.requestRecoveryEmailCheck = [[ASIFormDataRequest alloc] initWithURL:URL_SERVICE_LOGIN_RECOVERY_EMAIL_CHECK];
        self.requestRecoveryEmailCheck.delegate = self;
        [_requestRecoveryEmailCheck setPostValue:email forKey:@"email"];
        [_requestRecoveryEmailCheck setPostValue:code forKey:@"token"];
        [_requestRecoveryEmailCheck setPostValue:pass forKey:@"password"];
        [_requestRecoveryEmailCheck setDidFinishSelector:@selector(requestRecoveryEmailCheckFinished:)];
        [_requestRecoveryEmailCheck setDidFailSelector:@selector(requestRecoveryEmailCheckFail:)];
        [_requestRecoveryEmailCheck startAsynchronous];
    
    }

}


- (void)requestLoginFinished:(ASIHTTPRequest *)request{

    NSString *response = [request responseString];
    
    if(response && response.length){
        
        [self sendType:TYSLoginTypeLogin withResponse:response status:ServiceStatusOk];
        
    }else{
        
        [self sendType:TYSLoginTypeLogin withResponse:response status:ServiceStatusFailConnection];
        
    }
}

- (void)requestLoginFail:(ASIHTTPRequest *)request{
    
    [self sendType:TYSLoginTypeLogin withResponse:nil status:ServiceStatusFailConnection];
    
}

- (void)requestRegisterFinished:(ASIHTTPRequest *)request{
    
    NSString *response = [request responseString];
    
    if(response && response.length){
        
        [self sendType:TYSLoginTypeRegister withResponse:response status:ServiceStatusOk];
        
    }else{
        
        [self sendType:TYSLoginTypeRegister withResponse:response status:ServiceStatusFailConnection];
        
    }
    
    
}

- (void)requestRegisterFail:(ASIHTTPRequest *)request{
    
    [self sendType:TYSLoginTypeRegister withResponse:nil status:ServiceStatusFailConnection];
    
}

- (void)requestRecoveryEmailFinished:(ASIHTTPRequest *)request{
    
    NSString *response = [request responseString];
    
    if(response && response.length){
        
        [self sendType:TYSLoginTypeRecoveryEmail withResponse:response status:ServiceStatusOk];
        
    }else{
        
        [self sendType:TYSLoginTypeRecoveryEmail withResponse:response status:ServiceStatusFailConnection];
        
    }
    
}

- (void)requestRecoveryEmailFail:(ASIHTTPRequest *)request{
    
    [self sendType:TYSLoginTypeRecoveryEmail withResponse:nil status:ServiceStatusFailConnection];
    
}

- (void)requestRecoveryEmailCheckFinished:(ASIHTTPRequest *)request{
    
    NSString *response = [request responseString];
    
    if(response && response.length){
        
        [self sendType:TYSloginTypeRecoveryEmailCheck withResponse:response status:ServiceStatusOk];
        
    }else{
        
        [self sendType:TYSloginTypeRecoveryEmailCheck withResponse:response status:ServiceStatusFailConnection];
        
    }
    
}

- (void)requestRecoveryEmailCheckFail:(ASIHTTPRequest *)request{
    
    [self sendType:TYSloginTypeRecoveryEmailCheck withResponse:nil status:ServiceStatusFailConnection];
    
}

@end
