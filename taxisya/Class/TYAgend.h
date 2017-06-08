//
//  TYAgend.h
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYAddress.h"
#import "TYTaxiProfile.h"

typedef enum {

    TYAgendStatusCanceled,
    TYAgendStatusFinished,
    TYAgendStatusProgress,
    TYAgendStatusAssigned,
    TYAgendStatusWaiting

} TYAgendStatus;

@interface TYAgend : NSObject

@property (nonatomic, strong) TYAddress             *tyAddress;
@property (nonatomic, strong) TYTaxiProfile         *tyTaxiProfile;
@property (nonatomic, assign) TYAgendStatus         tyAgendStatus;
@property (nonatomic, strong) NSString              *typeAgend;
@property (nonatomic, strong) NSString              *dateAgend;
@property (nonatomic, strong) NSString              *idAgend;

@end
