//
//  TYSTaxi.h
//  taxisya
//
//  Created by NTTak3 on 3/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYServices.h"
#import "TYAddress.h"

typedef enum{

    TYSTaxiTypeRequestService,
    TYSTaxiTypeServiceStatus,
    TYSTaxiTypeTaxiInfo,
    TYSTaxiTypeCancelService,
    TYSTaxiTypeCancelAutomatic,
    TYSTaxiTypeQualityService,
    TYSCreateAddress,
    TYSDeleteAddress

}TYSTaxiType;

@protocol TYSTaxiDelegate;

@interface TYSTaxi : NSObject

@property (nonatomic, assign) id <TYSTaxiDelegate>              delegate;
@property (nonatomic, strong) ASIFormDataRequest                *requestService;
@property (nonatomic, strong) ASIFormDataRequest                *requestServiceStatus;
@property (nonatomic, strong) ASIFormDataRequest                *requestTaxiInfo;
@property (nonatomic, strong) ASIHTTPRequest                    *requestCancelService;
@property (nonatomic, strong) ASIFormDataRequest                *requestCancelAutomatic;
@property (nonatomic, strong) ASIFormDataRequest                *requestQualityService;

- (id)initwithDelegate:(id <TYSTaxiDelegate>)delegate;

- (void)requestTaxiType:(TYSTaxiType)type object:(id)object;
- (void)requestTaxiType2:(TYSTaxiType)type object:(id)object barrio:(NSString *)bario latitud:(NSString *)lat longitud:(NSString *) lng;
- (void)requestTaxiType3:(TYSTaxiType)type object:(id)object barrio:(NSString *)bario latitud:(NSString *)lat longitud:(NSString *) lng payType:(int)payType payReference:(NSString *)payReference email:(NSString *)email cardReference:(NSString *)cardReference ticket:(NSString *) ticket;

- (void)clearDelegateAndCancel;
-(void)createAddress:(NSString *)address
               barrio:(NSString *)barrio
                 obs:(NSString *)obs
                 order:(NSString *)order
               name:(NSString *)name
                lat:(NSString *)lat
                lng:(NSString *)lng;
-(void)deleteAddress:(NSString *) addressId;

@end

@protocol TYSTaxiDelegate <NSObject>

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status;

@end
