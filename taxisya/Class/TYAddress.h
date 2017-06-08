//
//  TYAddress.h
//  taxisya
//
//  Created by NTTak3 on 24/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "Base.h"

@interface TYAddress : Base


@property (nonatomic, strong) NSString              *addressId;
@property (nonatomic, strong) NSString              *address1;
@property (nonatomic, strong) NSString              *address2;
@property (nonatomic, strong) NSString              *address3;
@property (nonatomic, strong) NSString              *address4;
@property (nonatomic, strong) NSString              *address5;
@property (nonatomic, strong) NSString              *address6;
@property (nonatomic, strong) NSString              *addressFull;
@property (nonatomic, strong) NSString              *addressName;
@property (nonatomic, strong) NSString              *latitude;
@property (nonatomic, strong) NSString              *longitude;
@property (nonatomic, strong) NSString              *destination;

@end
