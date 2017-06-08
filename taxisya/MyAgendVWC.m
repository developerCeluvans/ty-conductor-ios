//
//  MyAgendVWC.m
//  taxisya
//
//  Created by NTTak3 on 7/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "MyAgendVWC.h"
#import "UIView+Xib.h"
#import "NTPigRefreshControl.h"


@interface MyAgendVWC ()

@property (nonatomic, assign) int           currentYPosition;
@property (nonatomic, strong) NTPigRefreshControl   *refreshPig;

@end

@implementation MyAgendVWC

@synthesize delegate                    = _delegate;

@synthesize maAgends                    = _maAgends;

@synthesize currentYPosition            = _currentYPosition;

@synthesize scrvwAgends                 = _scrvwAgends;

@synthesize controlRefresh              = _controlRefresh;
@synthesize vwLoading                   = _vwLoading;

@synthesize imgvwNoServices             = _imgvwNoServices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id <MyAgendVWCDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.delegate = delegate;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrvwAgends.alwaysBounceVertical = YES;
    

//    self.controlRefresh = [[ISRefreshControl alloc] init];
//    [self.controlRefresh addTarget:self
//                            action:@selector(refresh)
//                  forControlEvents:UIControlEventValueChanged];
//    
//    [_scrvwAgends addSubview:_controlRefresh];
    
    self.refreshPig = [[NTPigRefreshControl alloc] initInScrollView:_scrvwAgends];
    [_refreshPig addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

    [_titleSchedules setText:NSLocalizedString(@"schedule_my_schedules", nil)];
    
    [self show:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)show:(BOOL)show{

    if(show){
        
        [self.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
    
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             
                             [self.view setTransform:CGAffineTransformIdentity];
                         
                         }
                         completion:^(BOOL f){
                         
                         }];
    
    }else{
    
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             
                             [self.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
                             
                         }
                         completion:^(BOOL f){
                             
                         }];
    
    }

}

- (void)setContentSizeAfterDelay{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [_scrvwAgends setContentSize:CGSizeMake(0, _currentYPosition)];
    [UIView commitAnimations];

}

- (void)setAgendInfo:(NSMutableArray *)info{
    
    [self.vwLoading stopAnimating];
    
//    [self.controlRefresh endRefreshing];
    
    [_refreshPig stopAnimating];
    
    [self performSelector:@selector(setContentSizeAfterDelay) withObject:nil afterDelay:0.8];
    
    if(info && info.count){
        
        self.maAgends = info;
        
        [self createFromArray];
        
        _imgvwNoServices.hidden = YES;
        
    }else{
    
        _imgvwNoServices.hidden = NO;
    
    }

}

- (void)createFromArray{
    
    /*
     * Clean the scroll view subviews
     */
    
    for (UIView *subview in _scrvwAgends.subviews){
        
        if([subview isKindOfClass:[MyAgendItemVW class]]){
            
            [subview removeFromSuperview];
            
        }
        
    }

    _currentYPosition = 100;
    
    for (TYAgend *agend in _maAgends){
        
        MyAgendItemVW *myAgendItem = (MyAgendItemVW *)[UIView viewFromNib:@"MyAgendItemVW" bundle:nil];
        myAgendItem.delegate = self;
        [myAgendItem setAgend:agend];
        [myAgendItem setFrame:CGRectMake(0, _currentYPosition, myAgendItem.frame.size.width, myAgendItem.frame.size.height)];
        [_scrvwAgends addSubview:myAgendItem];
        
        _currentYPosition += myAgendItem.frame.size.height;
        
        if(!_controlRefresh.isRefreshing){
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [_scrvwAgends setContentSize:CGSizeMake(0, _currentYPosition)];
            [UIView commitAnimations];
            
        }
        
    }

}


- (void)refresh
{
    [_delegate MyAgendVWCNeedRefresh];
    
}


#pragma mark -
#pragma mark - MyAgendItemVWDelegate

- (void)MyAgendItemVWFinishedAgend:(MyAgendItemVW *)item{
    
    NSString *string = [NSString stringWithFormat:@"%@", item.tyAgend.idAgend];

    [_delegate MyAgendVWCFinishedAgendWithId:string];
    
    
}

- (void)MyAgendItemVWCancelAgend:(MyAgendItemVW *)item{
    
    NSString *string = [NSString stringWithFormat:@"%@", item.tyAgend.idAgend];

    [_delegate MyAgendVWCCancelAgendWithId:string];
    
    [self refresh];
    
    [_controlRefresh beginRefreshing];
//
//    [item removeFromSuperview];
//    
//    [_maAgends removeObject:item.tyAgend];
//    
//    [self createFromArray];

}

@end
