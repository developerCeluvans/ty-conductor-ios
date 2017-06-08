//
//  HistoryReclamo.h
//  taxisya
//
//  Created by Guillermo Blanco on 29/07/14.
//  Copyright (c) 2014 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"

@protocol HistoryReclamoDelegate <NSObject>

- (void)finishReclamo;

@end

@interface HistoryReclamo : UIViewController <HTTPRequestDelegate>

@property (nonatomic, assign) id <HistoryReclamoDelegate> delegate;
@property (nonatomic, strong) UITextField *reclamoText;
@property (nonatomic) int64_t serviceID;

@end
