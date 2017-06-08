//
//  HTTPService.h
//  BDGourmet
//
//  Created by Guillermo Blanco on 27/05/14.
//  Copyright (c) 2014 Guillermo Blanco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"

@class Sale, HTTPSyncRequest;

@interface HTTPService : NSOperation

+ (void)synchronize:(HTTPSyncRequest *)delegate;

@end
