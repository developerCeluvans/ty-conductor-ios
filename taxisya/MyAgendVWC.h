//
//  MyAgendVWC.h
//  taxisya
//
//  Created by NTTak3 on 7/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAgendItemVW.h"
#import "ISRefreshControl.h"



@protocol MyAgendVWCDelegate;

@interface MyAgendVWC : UIViewController <MyAgendItemVWDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleSchedules;

@property (nonatomic, assign) id <MyAgendVWCDelegate>           delegate;
@property (nonatomic, strong) NSMutableArray                    *maAgends;

@property (nonatomic, strong) IBOutlet UIScrollView             *scrvwAgends;
@property (nonatomic, strong) ISRefreshControl                  *controlRefresh;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView  *vwLoading;
@property (nonatomic, strong) IBOutlet UIImageView              *imgvwNoServices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id <MyAgendVWCDelegate>)delegate;
- (void)show:(BOOL)show;
- (void)setAgendInfo:(NSMutableArray *)info;

@end

@protocol MyAgendVWCDelegate <NSObject>

- (void)MyAgendVWCCancelAgendWithId:(NSString *)agendId;
- (void)MyAgendVWCFinishedAgendWithId:(NSString *)agendId;
- (void)MyAgendVWCNeedRefresh;

@end
