//
//  Country.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "Country.h"

@implementation Country

-(id)initWithObject:(long)countryId address:(NSString *)name {
    
    self = [super init];
    if (self) {
        _countryId = countryId;
        _name = name;
    }
    return self;
}

@end
