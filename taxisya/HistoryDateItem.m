//
//  HistoryDateItem.m
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "HistoryDateItem.h"

@implementation HistoryDateItem

@synthesize delegate                    = _delegate;
@synthesize lbAddress1                  = _lbAddress1;
@synthesize lbAddress2                  = _lbAddress2;
@synthesize dateId                      = _dateId;

- (void)setAddress1:(NSString *)addres1 address2:(NSString *)addres2 idDate:(NSString *)idDate delegate:(id<HistoryDateItemDelegate>)delegate{

    [_lbAddress1 setText:addres1];
    [_lbAddress2 setText:addres2];
    self.delegate = delegate;
    self.dateId = idDate;
    
    [_lbAddress1 setFont:UI_FONT_1(16)];
    [_lbAddress2 setFont:UI_FONT_1(19)];
    
    [self setTextNormal:YES];

}

- (void)goTaped:(id)sender{
    
    [_delegate HistoryDateNeedDetailId:_dateId];

}

- (void)setTextNormal:(BOOL)normal{

    if(normal){
    
        [_lbAddress1 setTextColor:[UIColor darkGrayColor]];
        [_lbAddress2 setTextColor:[UIColor darkGrayColor]];
        [self setBackgroundColor:[UIColor clearColor]];
    
    }else{
    
        [_lbAddress1 setTextColor:UI_COLOR_ORAGNE];
        [_lbAddress2 setTextColor:UI_COLOR_ORAGNE];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"historial-pattern-fondo.png"]]];
        
    }

}


@end
