//
//  Car.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "Car.h"

@implementation Car

-(id)initWithObject:(long) carId plate:(NSString *)carPlate {
    self = [super init];
    if (self) {
        _carId = carId;
        _carPlate = carPlate;
    }
    return self;
}

@end
