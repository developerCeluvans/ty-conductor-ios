//
//  HistoryDateItem.h
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryDateItemDelegate;

@interface HistoryDateItem : UIView

@property (nonatomic, assign) id <HistoryDateItemDelegate>          delegate;

@property (nonatomic, retain) IBOutlet UILabel                      *lbAddress1;
@property (nonatomic, retain) IBOutlet UILabel                      *lbAddress2;
@property (nonatomic, retain) IBOutlet UIButton                     *btnPhone;

@property (nonatomic, retain) NSString                              *dateId;


- (void)setAddress1:(NSString *)addres1 address2:(NSString *)addres2 idDate:(NSString *)idDate delegate:(id<HistoryDateItemDelegate>)delegate;

- (IBAction)goTaped:(id)sender;

- (void)setTextNormal:(BOOL)normal;


@end

@protocol HistoryDateItemDelegate <NSObject>

- (void)HistoryDateNeedDetailId:(NSString *)idDate;

@end
