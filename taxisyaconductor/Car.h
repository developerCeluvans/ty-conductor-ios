//
//  Car.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (nonatomic) long carId;
@property (strong, nonatomic) NSString *carPlate;

-(id)initWithObject:(long) carId plate:(NSString *)carPlate;

@end
