//
//  TYServiceProgress.h
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYSTaxi.h"
#import "TYTaxiProfile.h"
#import "HTTPRequest.h"

#define STATUS_PENDING                  @"1"
#define STATUS_ASSIGNED                 @"2"
#define STATUS_DRIVER_WAITING           @"3"
#define STATUS_RUNNING                  @"4"
#define STATUS_ENDED                    @"5"
#define STATUS_CANCELED                 @"6"
#define STATUS_CANCELED_FOR_DRIVER      @"7"
#define STATUS_CANCELED_FOR_DRIVER1     @"8"
#define STATUS_CANCELED_FOR_DRIVER2     @"9"


@protocol TYServiceProgressDelegate;

//@interface TYServiceProgress : NSObject <TYSTaxiDelegate, HTTPRequestDelegate>
@interface TYServiceProgress : NSObject <TYSTaxiDelegate>


@property (nonatomic, assign) id <TYServiceProgressDelegate>    delegate;
@property (nonatomic, strong) TYSTaxi                           *tysTaxi;
@property (nonatomic, strong) NSTimer                           *timerAssignmentTaxi;

@property (nonatomic, strong) NSString                          *idTaxista;
@property (nonatomic, assign) BOOL                              areFoundingTaxiPosition;
@property (nonatomic, strong) NSTimer                           *timerPositionTaxi;

@property (nonatomic, assign) int                               countTIMER;

- (id)initWithDelegate:(id<TYServiceProgressDelegate>)delegate;

- (void)requestServiceWithAddress:(TYAddress *)address;
- (void)requestCancerService;
- (void)requestQualityService:(NSString *)type;
- (void)pushNotificationReceived: (NSNotification*)aNotification;
- (void)taxiarriveds: (NSNotification*)aNotification;
- (void)taxicancelservice: (NSNotification*)aNotification;
- (BOOL)usserHaveServicePending;

- (void)checkServicePendingIfNeeded;

@end

@protocol TYServiceProgressDelegate <NSObject>
@optional
- (void)TYServiceProgressFailConnectionInRequestType:(TYSTaxiType)type;
- (void)TYServiceProgressUpdateTaxiInfo:(TYTaxiProfile *)profile;
- (void)TYServiceProgressOperatorCancelTheService;
- (void)TYServiceProgressOperatorCancelForDriverTheService;
- (void)TYServiceProgressTaxiAreWaitingForUsser;
@end
