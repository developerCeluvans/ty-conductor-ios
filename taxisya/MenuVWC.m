//
//  MenuVWC.m
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "MenuVWC.h"
#import <objc/runtime.h>
#import "FXImageView.h"
#import "ServiceVWC.h"
#import "Register.h"
#import "HistoryVWC.h"
#import "AgendaVWC.h"

static char const * const SUPER_VIEW_TAG = "superVWButton";

@interface MenuVWC ()
- (void)animateMap;
@end

@implementation MenuVWC

@synthesize delegate                = _delegate;

@synthesize imgImaginamos           = _imgImaginamos;
@synthesize imgMask                 = _imgMask;
@synthesize imgTitle                = _imgTitle;
@synthesize imgMap                  = _imgMap;
@synthesize options                 = _options;
@synthesize arrayButtons            = _arrayButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    [_imgMap setFrame:CGRectMake(_imgMap.frame.origin.x, self.view.frame.size.height - _imgMap.frame.size.height,  _imgMap.frame.size.width, _imgMap.frame.size.height)];

    if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

    }else{

        [_imgTitle setFrame:CGRectMake(_imgTitle.frame.origin.x+2, _imgTitle.frame.origin.y - 32, _imgTitle.frame.size.width, _imgTitle.frame.size.height)];

    }
    _imgMap.alpha = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceConfirmed:) name:@"push_taxi_confirm_service" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxiArrived:) name:@"push_taxi_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceFinished:) name:@"push_taxi_finish_service" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRequestServiceOption:) name:@"call_request_service" object:nil];

    [UIView animateWithDuration:0.2
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){

                         [_imgMask setTransform:CGAffineTransformMakeTranslation(0, 10)];

                         [_imgTitle setTransform:CGAffineTransformMakeTranslation(0, 10)];

                     }
                     completion:^(BOOL f){

                         [UIView animateWithDuration:0.35
                                          animations:^(void){

                                              [_imgMask setTransform:CGAffineTransformMakeTranslation(0, -255)];

                                              [_imgTitle setTransform:CGAffineTransformMakeTranslation(0, - 105)];

                                              _imgMap.alpha = 1;

                                              [self performSelector:@selector(animateMap) withObject:nil afterDelay:1.5];

                                          }
                                          completion:^(BOOL f){

                                              [UIView animateWithDuration:0.2
                                                               animations:^(void){

                                                                   [_imgMask setTransform:CGAffineTransformMakeTranslation(0, -250)];

                                                                   [_imgTitle setTransform:CGAffineTransformMakeTranslation(0, - 100)];

                                                               }
                                                               completion:^(BOOL f){

                                                                   [self createMenuOptions];

                                                               }];

                                          }];


                     }];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear MenuVWC");
    if (self.callRequestServiceOption) {
        self.callRequestServiceOption = NO;
        ServiceVWC *serviceVWC = [[ServiceVWC alloc] initWithNibName:@"ServiceVWC" bundle:nil];
        [self.navigationController pushViewController:serviceVWC animated:YES];
    }

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.repeatAnimations = NO;
    self.options = nil;
    self.imgImaginamos = nil;
    self.imgMask = nil;
    self.imgMap = nil;

    NSLog(@"viewDidDisappear MenuVWC");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_taxi_confirm_service" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_taxi_arrived" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push_taxi_finish_service" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createMenuOptions{

    if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

        self.options = [[iCarousel alloc] initWithFrame:CGRectMake(0, 130, 320, 480)];
        self.options.delegate = self;
        self.options.dataSource = self;
        self.options.type =iCarouselTypeRotary;
        [self.view addSubview:_options];

    }else{

        self.options = [[iCarousel alloc] initWithFrame:CGRectMake(0, 80, 320, 480)];
        self.options.delegate = self;
        self.options.dataSource = self;
        self.options.type =iCarouselTypeRotary;
        [self.view addSubview:_options];

    }

    UIView *vw1 = nil;
    UIView *vw2 = nil;
    UIView *vw3 = nil;
    UIView *vw4 = nil;

    NSLog(@"Numero de Items Visibles %ld", self.options.numberOfVisibleItems);
    for (int i = 0; i < self.options.numberOfVisibleItems; i ++){

        if (i == 0){

            vw1 = [self.options.visibleItemViews objectAtIndex:i];
            vw1.alpha = 0;
            [vw1 setTransform:CGAffineTransformMakeTranslation(0, -300)];

        }else if(i == 1){

            vw2 = [self.options.visibleItemViews objectAtIndex:i];
            vw2.alpha = 0;
            [vw2 setTransform:CGAffineTransformMakeTranslation(0, -300)];

        }else if (i == 2){

            vw3 = [self.options.visibleItemViews objectAtIndex:i];
            vw3.alpha = 0;
            [vw3 setTransform:CGAffineTransformMakeTranslation(0, -300)];

        }else if (i == 3){

            vw4 = [self.options.visibleItemViews objectAtIndex:i];
            vw4.alpha = 0;
            [vw4 setTransform:CGAffineTransformMakeTranslation(0, -300)];

        }
    }

    [UIView animateWithDuration:0.4
                     animations:^(void){

                         vw1.alpha = 1;
                         [vw1 setTransform:CGAffineTransformMakeTranslation(0, 8)];

                     } completion:^(BOOL f){

                         [UIView animateWithDuration:0.4
                                          animations:^(void){

                                              [vw1 setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                          } completion:^(BOOL f){


                                              [UIView animateWithDuration:0.4
                                                               animations:^(void){

                                                                   vw2.alpha = 1;
                                                                   [vw2 setTransform:CGAffineTransformMakeTranslation(0, 8)];

                                                               } completion:^(BOOL f){


                                                                   [UIView animateWithDuration:0.4
                                                                                    animations:^(void){

                                                                                        vw4.alpha = 1;
                                                                                        [vw4 setTransform:CGAffineTransformMakeTranslation(0, 8)];

                                                                                    } completion:^(BOOL f){

                                                                                        [UIView animateWithDuration:0.2
                                                                                                         animations:^(void){

                                                                                                             [vw4 setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                                                                                         } completion:^(BOOL f){

                                                                                                             [UIView animateWithDuration:0.4
                                                                                                                              animations:^(void){

                                                                                                                                  vw3.alpha = 1;
                                                                                                                                  [vw3 setTransform:CGAffineTransformMakeTranslation(0, 8)];

                                                                                                                              } completion:^(BOOL f){

                                                                                                                                  [UIView animateWithDuration:0.2
                                                                                                                                                   animations:^(void){

                                                                                                                                                       [vw3 setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                                                                                                                                   } completion:^(BOOL f){



                                                                                                                                                   }];


                                                                                                                              }];

                                                                                                             [UIView animateWithDuration:0.2
                                                                                                                              animations:^(void){


                                                                                                                                  [vw2 setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                                                                                                              } completion:^(BOOL f){



                                                                                                                              }];

                                                                                                         }];


                                                                                    }];






                                                               }];

                                          }];



                     }];
}

- (void)firstAnimatedButtons:(UIView *)vw{

    vw.alpha = 0;
    [vw setTransform:CGAffineTransformMakeTranslation(0, -100)];

    [UIView animateWithDuration:0.3
                     animations:^(void){

                         vw.alpha = 1;
                         [vw setTransform:CGAffineTransformMakeTranslation(0, 0)];

                     } completion:^(BOOL f){



                     }];

}

- (void)animateMap{

    [UIView animateWithDuration:10
                     animations:^(void){

                         [_imgMap setTransform:CGAffineTransformMakeTranslation(-230, 0)];

                     }
                     completion:^(BOOL f){

                         [UIView animateWithDuration:4
                                          animations:^(void){

                                              [_imgMap setTransform:CGAffineTransformMakeTranslation(-230, 40)];

                                          }
                                          completion:^(BOOL f){

                                              [UIView animateWithDuration:5
                                                               animations:^(void){

                                                                   [_imgMap setTransform:CGAffineTransformMakeTranslation(-230, -5)];


                                                               }
                                                               completion:^(BOOL f){

                                                                   [UIView animateWithDuration:12
                                                                                    animations:^(void){


                                                                                        [_imgMap setTransform:CGAffineTransformMakeTranslation(0, 0)];

                                                                                    }
                                                                                    completion:^(BOOL f){

                                                                                        [UIView animateWithDuration:10
                                                                                                         animations:^(void){


                                                                                                             [_imgMap setTransform:CGAffineTransformMakeTranslation(-100, 20)];


                                                                                                         }
                                                                                                         completion:^(BOOL f){
                                                                                                             [self animateMap1];

                                                                                                         }];

                                                                                    }];

                                                               }];

                                          }];

                     }];

}

- (void)animateMap1{

    [UIView animateWithDuration:10
                     animations:^(void){

                         [_imgMap setTransform:CGAffineTransformMakeTranslation(-110, -5)];

                     }
                     completion:^(BOOL f){

                         [UIView animateWithDuration:2
                                          animations:^(void){

                                              [_imgMap setTransform:CGAffineTransformMakeTranslation(-170, 10)];

                                          }
                                          completion:^(BOOL f){

                                              [UIView animateWithDuration:10
                                                               animations:^(void){

                                                                   [_imgMap setTransform:CGAffineTransformMakeTranslation(0, 0)];


                                                               }
                                                               completion:^(BOOL f){
                                                                   if (self.repeatAnimations) {
                                                                       [self animateMap];
                                                                   }

                                                               }];

                                          }];

                     }];

}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 4;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    UIButton *btn = nil;

    //create new view if no view is available for recycling
    if (view == nil) {

        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        view.contentMode = UIViewContentModeCenter;

        if(index ==2){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 111, 150)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_over",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_over",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onHistory:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:500];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
            [imgvw setImage:[UIImage imageNamed:@"sombra.png"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + 80)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }else if (index == 0){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 111, 150)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_normal",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_over",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onPedir:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:501];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
            [imgvw setImage:[UIImage imageNamed:@"sombra.png"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + 80)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }else if (index == 1){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 111, 150)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_over",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_over",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onAgendar:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:502];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
            [imgvw setImage:[UIImage imageNamed:@"sombra.png"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + 80)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }else if (index == 3){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, 111, 150)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_over",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_over",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onPerfil:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:503];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
            [imgvw setImage:[UIImage imageNamed:@"sombra.png"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + 80)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return view;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.45f;
    }
    return value;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return 130;
}

- (void)onHistory:(id)sender{

    [self animateHideView:sender];

    //[_delegate MenuVWCOptionPressed:MenuOptionHistory];
    HistoryVWC *historyVWC = [[HistoryVWC alloc] initWithNibName:@"HistoryVWC" bundle:nil];
    [self.navigationController pushViewController:historyVWC animated:YES];
}

- (void)onPedir:(id)sender{

    [self animateHideView:sender];

    //[_delegate MenuVWCOptionPressed:MenuOptionService];
    ServiceVWC *serviceVWC = [[ServiceVWC alloc] initWithNibName:@"ServiceVWC" bundle:nil];
    serviceVWC.isSchedule = NO;
    [self.navigationController pushViewController:serviceVWC animated:YES];

}

- (void)onAgendar:(id)sender{

    [self animateHideView:sender];
    //[_delegate MenuVWCOptionPressed:MenuOptionAgend];

    AgendaVWC *agendVWC = [[AgendaVWC alloc] initWithNibName:@"AgendaVWC" bundle:nil];
    [self.navigationController pushViewController:agendVWC animated:YES];
}

- (void)onPerfil:(id)sender{

    [self animateHideView:sender];
    //[_delegate MenuVWCOptionPressed:MenuOptionPerfil];
    Register *registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
    [self.navigationController pushViewController:registerVWC animated:YES];

}

- (void)animateHideView:(id)sender{

    UIButton *btn = (UIButton *)sender;

    UIView *vw = objc_getAssociatedObject(btn, SUPER_VIEW_TAG);


    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){

                         [vw setTransform:CGAffineTransformMakeScale(3.0, 3.0)];

                         [vw setAlpha:0];

                     }
                     completion:^(BOOL f){

                         [self performSelector:@selector(appearView:) withObject:vw afterDelay:0.5];

                     }];


}

- (void)appearView:(UIView  *)vw{

    [vw setTransform:CGAffineTransformMakeScale(1, 1)];

    [UIView animateWithDuration:0.2
                     animations:^(void){

                         [vw setAlpha:1];

                     }
                     completion:^(BOOL f){



                     }];

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{

    UIView *view = [carousel.visibleItemViews objectAtIndex:carousel.currentItemIndex];


    for(UIView *iner in carousel.visibleItemViews){

        if (view == iner) {

            for(UIView *vw in iner.subviews){

                if([vw isKindOfClass:[UIButton class]]){

                    UIButton *btn = (UIButton *)vw;

                    long tag = btn.tag;

                    if(tag == 500){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_over",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 501){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_over",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 502){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_over",nil)] forState:UIControlStateHighlighted];

                    }else if (tag == 503){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_over",nil)] forState:UIControlStateHighlighted];

                    }

                }

            }


        }else{

            for(UIView *vw in iner.subviews){

                if([vw isKindOfClass:[UIButton class]]){

                    UIButton *btn = (UIButton *)vw;

                    long tag = btn.tag;

                    if(tag == 500){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_reclamo_over",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 501){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_pedirtaxi_over",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 502){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_agendar_over",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 503){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_perfil_over",nil)] forState:UIControlStateHighlighted];
                    }

                }

            }


        }

    }


}


-(void)serviceConfirmed:(NSNotification*)aNorification {
    NSLog(@"serviceConfirmed %@",aNorification);
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    LoadingVWC *loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
    loadingVWC.driver = driver;
    loadingVWC.statusId = 2;
    [self.navigationController pushViewController:loadingVWC animated:YES];
}

-(void)taxiArrived:(NSNotification*)aNorification {
    NSLog(@"taxiArrived %@",aNorification);
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    LoadingVWC *loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
    loadingVWC.driver = driver;
    loadingVWC.statusId = 4;
    [self.navigationController pushViewController:loadingVWC animated:YES];
}

-(void)serviceFinished:(NSNotification*)aNorification {
    NSLog(@"serviceFinished %@",aNorification);
    NSDictionary *driver =[[aNorification userInfo] objectForKey:@"driver"];
    LoadingVWC *loadingVWC = [[LoadingVWC alloc] initWithNibName:@"LoadingVWC" bundle:nil];
    loadingVWC.driver = driver;
    loadingVWC.statusId = 5;
    [self.navigationController pushViewController:loadingVWC animated:YES];
}

-(void)callRequestServiceOption:(NSNotification*)aNorification {
    NSLog(@"callRequestServiceOption %@",aNorification);
    self.callRequestServiceOption = YES;
}

#pragma mark - QualityServiceDelegate
- (void)QualityServiceNeedRemove {
    self.callRequestServiceOption = YES;
}

@end
