//
//  Region.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic) long countryId;
@property (nonatomic) long regionId;
@property (strong, nonatomic) NSString *name;

-(id)initWithObject:(long)regionId country:(int)countryId name:(NSString *)name;

@end
