//
//  TYTaxiProfile.h
//  taxisya
//
//  Created by NTTak3 on 5/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "Base.h"

@interface TYTaxiProfile : Base

@property (nonatomic, strong) NSString                  *name;
@property (nonatomic, strong) NSString                  *lastName;
@property (nonatomic, strong) NSString                  *placa;
@property (nonatomic, strong) NSString                  *idService;
@property (nonatomic, strong) NSString                  *urlImage;
@property (nonatomic, strong) NSString                  *phone;
@property (nonatomic, strong) NSString                  *brand;
@property (nonatomic, strong) NSString                  *model;
@property (nonatomic, assign) float                     latitude;
@property (nonatomic, assign) float                     longitude;

@end
