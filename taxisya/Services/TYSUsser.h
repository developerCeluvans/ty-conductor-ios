//
//  TYSUsser.h
//  taxisya
//
//  Created by NTTak3 on 3/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYServices.h"

typedef enum{
    
    TYSUsserTypeOldAddress,
    TYSUsserTypeHistory,
    TYSUsserTypeHistoryDetail,
    TYSUsserTypeAgend,
    TYSUsserTypeAgendCancel,
    TYSUsserTypeAgendFinish,
    TYSUsserTypeAgendHistory
    
} TYSUsserType;

@protocol TYSUsserDelegate;

@interface TYSUsser : NSObject

@property (nonatomic, assign) id <TYSUsserDelegate>                     delegate;
@property (nonatomic, strong) ASIFormDataRequest                        *requestUsserOldAddress;
@property (nonatomic, strong) ASIFormDataRequest                        *requestUsserHistory;
@property (nonatomic, strong) ASIFormDataRequest                        *requestUsserHistoryDetail;
@property (nonatomic, strong) ASIFormDataRequest                        *requestUsserAgend;
@property (nonatomic, strong) ASIFormDataRequest                        *requestUsserAgendHistory;

- (id)initwithDelegate:(id <TYSUsserDelegate>)delegate;

- (void)requestUsserType:(TYSUsserType)type object:(id)object;

- (void)clearDelegateAndCancel;

@end

@protocol TYSUsserDelegate <NSObject>

- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status;

@end