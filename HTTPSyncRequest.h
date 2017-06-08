//
//  HTTPSyncRequest.h
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"

@interface HTTPSyncRequest : NSObject <HTTPRequestDelegate>

- (void)synchronizeWithData:(NSArray *)data synchronize:(BOOL)send;
//- (void)didCompleteWithError:(NSError *)error;
- (void)didCompleteReceiveData:(NSDictionary *)data;
- (BOOL)validateVersion:(id <HTTPRequestDelegate>)delegate;
- (BOOL)validateCurrentServiceData:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)createReclamo:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)validateSession:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)validateLogout:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)qualificationService:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)cancelService:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;
- (BOOL)checkTicket:(NSDictionary *)data delegate:(id <HTTPRequestDelegate>)delegate;

@end

