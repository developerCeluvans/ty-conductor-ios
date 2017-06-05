//
//  Country.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic) long countryId;
@property (strong, nonatomic) NSString *name;

-(id)initWithObject:(long)countryId address:(NSString *)name;

@end
