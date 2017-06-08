//
//  TYFormatter.h
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface TYFormatter : NSObject


+ (BOOL)FormatterValidateEmail:(NSString *)email;

+ (BOOL)FormatterValidateNumbers:(NSString *)numbers;

+ (NSString *)FormatterGetDeviceIdentifier;

+ (BOOL)formatterValidateInternetConnection;


@end
