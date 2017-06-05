//
//  City.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic) long countryId;
@property (nonatomic) long regionId;
@property (nonatomic) long cityId;
@property (strong, nonatomic) NSString *name;

-(id)initWithObject:(long)countryId region:(long)regionId city:(long)cityId name:(NSString *)name;

@end
