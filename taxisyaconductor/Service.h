//
//  Service.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/9/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject<NSCoding>

@property (nonatomic) long serviceId;
@property (strong,nonatomic) NSString *addressService;
@property (strong,nonatomic) NSString *neighborhood;
@property (strong,nonatomic) NSString *destination;
@property (strong,nonatomic) NSString *observation;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int kindId;
@property (nonatomic) int units;
@property (nonatomic) int scheduleType;
@property (nonatomic) long statusId;
@property (nonatomic) int speak;
@property (nonatomic) NSString *serviceDateTime;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSDate *createdAt;


-(id)initWithObject:(long) serviceId
            address:(NSString *)address
       neighborhood:(NSString *)neighborhood
           destination:(NSString *)destination
           observation:(NSString *)observation
           latitude:(double)latitude
           longitude:(double)longitude
           kindId:(int)kindId
           scheduleType:(int)scheduleType
           serviceDateTime:(NSString *)serviceDateTime
           userName:(NSString *)userName
           status:(long)statusId;

@end
