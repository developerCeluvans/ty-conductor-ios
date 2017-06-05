//
//  Config.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property (nonatomic) BOOL isLogged;
@property (strong,nonatomic) NSString *user;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *uuid;
@property (strong,nonatomic) NSString *driverId;
@property (strong,nonatomic) NSString *serviceId;
@property (strong,nonatomic) NSString *appVersion;

@end
