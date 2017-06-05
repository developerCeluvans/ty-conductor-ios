//
//  History.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property (nonatomic) long serviceId;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *neighborhood;
@property (strong,nonatomic) NSString *updateAt;
@property (nonatomic) int rate;

-(id)initWithObject:(long) serviceId address:(NSString *)address neighborhood:(NSString *) neighborhood updateAt:(NSString *)updateAt rate:(int) rate;

@end
