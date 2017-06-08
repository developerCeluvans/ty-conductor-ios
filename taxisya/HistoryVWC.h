//
//  HistoryVWC.h
//  taxisya
//
//  Created by NTTak3 on 23/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDateItem.h"
#import "HistoryTaxiItem.h"
#import "TYSUsser.h"
#import "Register.h"
#import "HistoryReclamo.h"

@protocol HistoryVWCDelegate;

@interface HistoryVWC : UIViewController <HistoryReclamoDelegate, HistoryTaxItemDelegate, HistoryDateItemDelegate, TYSUsserDelegate, RegisterDelegate>

@property (nonatomic, assign) id <HistoryVWCDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIScrollView *scrvwDates;
@property (nonatomic, strong) IBOutlet UIScrollView *scrvwTaxistas;
@property (nonatomic, strong) TYSUsser *tysUsser;
@property (nonatomic, strong) Register *registerVWC;
@property (nonatomic, strong) HistoryReclamo *reclamo;
@property (nonatomic, strong) UILabel *labelNotServices;

- (void)show:(BOOL)show;
- (IBAction)goBack:(id)sender;

@end


@protocol HistoryVWCDelegate <NSObject>

- (void)HistoryVWCNeedRemove;

@end
