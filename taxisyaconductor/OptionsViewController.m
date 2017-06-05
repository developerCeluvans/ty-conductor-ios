//
//  OptionsViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "OptionsViewController.h"
#import "LoginViewController.h"
#import "ServicesViewController.h"
#import "HistoryViewController.h"
#import <objc/runtime.h>
#import "FXImageView.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"

@import AVFoundation;

static char const * const SUPER_VIEW_TAG = "superVWButton";

@interface OptionsViewController () {
    UIView *viewItemFirt;
    UIView *viewItemTwo;
    UIView *viewItemThree;
    CGFloat valueReturn;
    CGFloat sizeItem;
    float separator;
    float offsetTitle;
    float offsetMask;
    float offsetShadowY;
    float itemWidth;
    float itemHeight;
    float shadowWidth;
    float shadowHeight;
    float viewY;
    float centerX;
    float centerY;
    BOOL makeAnimatios;
}

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.repeatAnimations = TRUE;
    NSLog(@"OptionsViewController viewDidLoad %i",self.repeatAnimations);

    _locationManager =[[CLLocationManager alloc]init];

    self.isLocationEnabled = NO;

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ( (status == kCLAuthorizationStatusAuthorized)
        && [CLLocationManager locationServicesEnabled]) {
        // Tenemos acceso a localización
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        self.isLocationEnabled = YES;

        // No me interesan datos pasado mucho tiempo, asi que si no
        // recibimos posición en menos de 5 segundos, paramos al
        // locationManager
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.locationManager stopUpdatingLocation];
        });
    }
    else {
        [self requestAlwaysAuth];
    }
}

-(void)requestAlwaysAuth{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString*title;
        title=(status == kCLAuthorizationStatusDenied) ? @"Location Services Are Off" : @"Background use is not enabled";
        NSString *message = @"Go to settings";
        self.isLocationEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
        [alert show];
    }
    else if (status==kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
        self.isLocationEnabled = YES;

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }
}
-(void)checkStatus{


    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status==kCLAuthorizationStatusNotDetermined) {
        NSLog(@"status: Not Determined");
    }
    if (status==kCLAuthorizationStatusDenied) {
        NSLog(@"status: Denied");
    }
    if (status==kCLAuthorizationStatusRestricted) {
         NSLog(@"status: Restricted");
    }
    if (status==kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"status: Always Allowed");
    }
    if (status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"status: When In Use Allowed");

        //NSLog(@"Trying to change to ALWAYS authorization");
        //[self requestAlwaysAuth];
    }
}

- (IBAction)goToSettings:(id)sender {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication]openURL:settingsURL];
}

- (IBAction)changAuth:(id)sender{
    NSLog(@"Trying to change to ALWAYS authorization");
    [self requestAlwaysAuth];
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    self.location = [locations lastObject];
    NSLog(@"didUpdateLocations lat=%f lng=%f", self.location.coordinate.latitude, self.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error en la Location %@", error.userInfo);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    makeAnimatios = true;
    if (self.isMovingToParentViewController == NO)
    {
        NSLog(@"=============== ");
        makeAnimatios = false;
        viewItemFirt.alpha = 0;
        viewItemTwo.alpha = 0;
        viewItemThree.alpha = 0;
    }
    else {
        // llamado inicial
        NSLog(@"++++++++++++++++++++++++++++++++");
        NSLog(@"");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [defaults objectForKey:@"uuid"];
        NSString *login = [defaults objectForKey:@"login"];
        NSString *password = [defaults objectForKey:@"password"];
        NSString *driverId = [defaults objectForKey:@"driver_id"];
        NSString *userName = [defaults objectForKey:@"name"];

        NSLog(@"uuid %@",uuid);
        NSLog(@"login %@",login);
        NSLog(@"password %@",password);
        NSLog(@"driverId %@",driverId);
        NSLog(@"name %@",userName);
        NSLog(@"");
        NSLog(@"++++++++++++++++++++++++++++++++");
        NSLog(@"");
        if ((login == nil) && (password == nil)) {
            // disable
//            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
            LoginViewController *loginVC = [[LoginViewController alloc] initWithRegister:YES];
            [self.navigationController pushViewController:loginVC animated:NO];
        }

    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self buildView];
    if (makeAnimatios) {
        [self makeAnimation];
    }
    else {

        //
        [_imageLogo setFrame:CGRectMake(_imageLogo.frame.origin.x, _imageLogo.frame.origin.y - offsetTitle, _imageLogo.frame.size.width, _imageLogo.frame.size.height)];

        [_imageMask setFrame:CGRectMake(_imageMask.frame.origin.x, _imageMask.frame.origin.y - offsetMask, _imageMask.frame.size.width, _imageMask.frame.size.height)];

        _imageMap.alpha = 1;

        [self animateMap];
        //[self performSelector:@selector(animateMap) withObject:nil afterDelay:1.5];

        [self createMenuOptions:YES];

    }

    // para recuperar service
    [self checkStatusService];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"OptionsViewController viewWillDisappear");
    self.repeatAnimations = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    self.options = nil;
    self.imageLogo = nil;
    self.imageMask = nil;
    self.imageMap = nil;

    NSLog(@"OptionsViewController viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - Init
-(BOOL) setUpProperties {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"This is an iPhone");
        sizeItem = 180; //170;
        itemWidth = 111; // 125
        itemHeight = 150; // 170
        valueReturn = 1.45;
        shadowHeight = 24;
        shadowWidth = 48;
        offsetShadowY = 80;
        centerX = (self.view.frame.size.width / 2) - 150;
        centerY = (self.view.frame.size.height / 2) - 50;
        separator = (self.view.frame.size.height - 200 - 100) / 3;
        viewY = self.view.frame.size.height - 200.0f - separator;
        return true;
    }
    else {
        NSLog(@"This is an iPad");
        sizeItem = 180;
        itemWidth = 250;
        itemHeight = 340;
        valueReturn = 4.34f;
        shadowHeight = 48;
        shadowWidth = 96;
        offsetShadowY = 180;
        centerX = (self.view.frame.size.width / 2) - 300;
        centerY = (self.view.frame.size.height / 2) - 100;
        separator = (self.view.frame.size.height - 200 - 200) / 3;
        viewY = self.view.frame.size.height - 200.0f - separator;
    }
    return false;
}

-(void) buildView {

    centerX = 0;
    centerY = 0;

    BOOL isIphone = [self setUpProperties];

    offsetTitle = centerY - separator;
    offsetMask = self.view.frame.size.height - viewY - 50;

    // mapa
    _imageMap = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewY,self.view.frame.size.width + 400, self.view.frame.size.height - viewY)];
    [_imageMap setImage:[UIImage imageNamed:@"map_slide"]];
    [self.view addSubview:_imageMap];

    // mask
    _imageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height + 40)];
    [_imageMask setImage:[UIImage imageNamed:@"mask"]];
    [self.view addSubview:_imageMask];

    // logo
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(centerX, centerY,
                                                               isIphone ? 300 : 600,
                                                               isIphone ? 100 : 200)];

    [_imageLogo setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:_imageLogo];
}

#pragma marks - Utils
- (void)createMenuOptions:(BOOL)animated {
    float viewWidth = self.view.frame.size.width;
    float viewHeight = 200.0f;
    float viewX = 0;

    self.options = [[iCarousel alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    self.options.delegate = self;
    self.options.dataSource = self;
    self.options.type =iCarouselTypeRotary;
    [self.view addSubview:self.options];

    viewItemFirt = nil;
    viewItemTwo = nil;
    viewItemThree = nil;

    NSLog(@"Numero de Items Visibles %ld", (long)self.options.numberOfVisibleItems);
    for (int i = 0; i < self.options.numberOfVisibleItems; i ++){
        if (i == 0){
            viewItemFirt = [self.options.visibleItemViews objectAtIndex:i];
            viewItemFirt.alpha = 0;
            [viewItemFirt setTransform:CGAffineTransformMakeTranslation(0, -300)];
        }else if(i == 1){
            viewItemTwo = [self.options.visibleItemViews objectAtIndex:i];
            viewItemTwo.alpha = 0;
            [viewItemTwo setTransform:CGAffineTransformMakeTranslation(0, -300)];
        }else if (i == 2){
            viewItemThree = [self.options.visibleItemViews objectAtIndex:i];
            viewItemThree.alpha = 0;
            [viewItemThree setTransform:CGAffineTransformMakeTranslation(0, -300)];
        }
    }
    if (animated)
        [self animateItemFirst];

}

#pragma marks - Animatios
-(void) makeAnimation {
    [UIView animateWithDuration:0.2
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         [_imageMask setTransform:CGAffineTransformMakeTranslation(0, 10)];
                         [_imageLogo setTransform:CGAffineTransformMakeTranslation(0, 10)];
                     }
                     completion:^(BOOL f){
                         [self animationForMap];
                     }];
}

-(void) animationForMakeMenu {
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         [_imageMask setTransform:CGAffineTransformMakeTranslation(0, -offsetMask)]; // -255

                         [_imageLogo setTransform:CGAffineTransformMakeTranslation(0, -offsetTitle)]; // -100
                     }
                     completion:^(BOOL f){
                         [self createMenuOptions:YES];
                     }];
}

-(void) animationForMap {
    [UIView animateWithDuration:0.35
                     animations:^(void){
                         [_imageMask setTransform:CGAffineTransformMakeTranslation(0, -255)]; // -255
                         [_imageLogo setTransform:CGAffineTransformMakeTranslation(0, - 105)];
                         _imageMap.alpha = 1;
                         [self performSelector:@selector(animateMap) withObject:nil afterDelay:1.5];
                     }
                     completion:^(BOOL f){
                         [self animationForMakeMenu];
                     }];
}

-(void) animateItemFirst {
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         viewItemFirt.alpha = 1;
                         [viewItemFirt setTransform:CGAffineTransformMakeTranslation(0, 8)];
                     }
                     completion:^(BOOL f){
                         [UIView animateWithDuration:0.4
                                          animations:^(void){
                                              [viewItemFirt setTransform:CGAffineTransformMakeTranslation(0, 0)];
                                          } completion:^(BOOL f){
                                              [self animateItemTwo];
                                          }];
                     }];
}

-(void) animateItemTwo {
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         viewItemTwo.alpha = 1;
                         [viewItemTwo setTransform:CGAffineTransformMakeTranslation(0, 8)];
                     }
                     completion:^(BOOL f){
                         [UIView animateWithDuration:0.4
                                          animations:^(void){}
                                          completion:^(BOOL f){
                                              [UIView animateWithDuration:0.2 animations:^(void){} completion:^(BOOL f){                                                                                                             [self animateItemThree];
                                              }];
                                          }];
                     }];
}

-(void) animateItemThree {
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         viewItemThree.alpha = 1;
                         [viewItemThree setTransform:CGAffineTransformMakeTranslation(0, 8)];
                     }
                     completion:^(BOOL f){
                         [UIView animateWithDuration:0.2
                                          animations:^(void){
                                              [viewItemThree setTransform:CGAffineTransformMakeTranslation(0, 0)];
                                          }
                                          completion:nil];
                     }];

    [UIView animateWithDuration:0.2
                     animations:^(void){
                         [viewItemTwo setTransform:CGAffineTransformMakeTranslation(0, 0)];
                     }
                     completion:^(BOOL f){

                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSString *userName = [defaults objectForKey:@"name"];

                         NSString *message = NSLocalizedString(@"wellcome_message",nil);
                         NSString *messageToSpeech = [message stringByReplacingOccurrencesOfString:@"{user_name}" withString:userName];
                         [self textToSpeech:messageToSpeech];
                     }];
}

- (void)animateMap{

    [UIView animateWithDuration:10
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(-230, 0)];
                     }
                     completion:^(BOOL f){
                         [UIView animateWithDuration:4
                                          animations:^(void){
                                              [_imageMap setTransform:CGAffineTransformMakeTranslation(-230, 40)];
                                          }
                                          completion:^(BOOL f){
                                              [self animateMap0];
                                          }];
                     }];
}

-(void)animateMap0 {
    [UIView animateWithDuration:5
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(-230, -5)];
                     }
                     completion:^(BOOL f){
                         [UIView animateWithDuration:12
                                          animations:^(void){
                                              [_imageMap setTransform:CGAffineTransformMakeTranslation(0, 0)];
                                          }
                                          completion:^(BOOL f){
                                              [self animateMap00];
                                          }];
                     }];
}

-(void)animateMap00 {
    [UIView animateWithDuration:10
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(-100, 20)];
                     }
                     completion:^(BOOL f){
                         [self animateMap1];
                     }];
}

- (void)animateMap1{
    [UIView animateWithDuration:10
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(-110, -5)];
                     }
                     completion:^(BOOL f){
                         [self animateMap2];
                     }];
}

-(void) animateMap2 {
    [UIView animateWithDuration:2
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(-170, 10)];
                     }
                     completion:^(BOOL f){
                         [self animateMap3];
                     }];
}

-(void) animateMap3 {
    [UIView animateWithDuration:10
                     animations:^(void){
                         [_imageMap setTransform:CGAffineTransformMakeTranslation(0, 0)];
                     }
                     completion:^(BOOL f){
                         if (self.repeatAnimations) {
                             [self animateMap];
                         }
                     }];
}

#pragma marks - iCarousel Methods
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIButton *btn = nil;

    //create new view if no view is available for recycling
    if (view == nil) {
        //view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 170, 170)];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeItem, sizeItem)];
        view.contentMode = UIViewContentModeCenter;

        if(index ==0){
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_over",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_over",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(enableAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:500];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, shadowWidth, shadowHeight)];
            [imgvw setImage:[UIImage imageNamed:@"item_shadow"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + offsetShadowY)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }else if (index == 1){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_normal",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_normal",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:501];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, shadowWidth, shadowHeight)];
            [imgvw setImage:[UIImage imageNamed:@"item_shadow"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + offsetShadowY)];
            imgvw.reflectionScale = 0.5f;
            imgvw.reflectionAlpha = 0.25f;
            imgvw.reflectionGap = 10.0f;
            [view addSubview:imgvw];

            objc_setAssociatedObject(btn, SUPER_VIEW_TAG, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        }else if (index == 2){

            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
            [btn setCenter:CGPointMake(85, 85)];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_normal",nil)] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_normal",nil)] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(historyAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:index];
            [view addSubview:btn];
            [btn setTag:502];

            FXImageView *imgvw = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, shadowWidth, shadowHeight)];
            [imgvw setImage:[UIImage imageNamed:@"item_shadow"]];
            [imgvw setCenter:CGPointMake(btn.center.x, btn.center.y + offsetShadowY)];
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
    if (option == iCarouselOptionSpacing) {
        return value * valueReturn;
    }
    return value;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return sizeItem;
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
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_normal",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 501){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_normal",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 502){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_over",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_normal",nil)] forState:UIControlStateHighlighted];
                    }
                }
            }
        }else{
            for(UIView *vw in iner.subviews){
                if([vw isKindOfClass:[UIButton class]]){
                    UIButton *btn = (UIButton *)vw;
                    long tag = btn.tag;
                    if(tag == 500){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_enable_normal",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 501){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_close_normal",nil)] forState:UIControlStateHighlighted];
                    }else if (tag == 502){
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_normal",nil)] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:NSLocalizedString(@"item_history_normal",nil)] forState:UIControlStateHighlighted];
                    }
                }
            }
        }
    }
}

#pragma marks - Navigation Methods
-(void)enableAction:(id)sender {
    NSLog(@"    enableAction");
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
                         if ([self isLogged]) {
                             if (self.isLocationEnabled) {
                                 [self.locationManager stopUpdatingLocation];

                                 ServicesViewController *servicesVC = [[ServicesViewController alloc] initWithNibName:nil bundle:nil];
                                 [self.navigationController pushViewController:servicesVC animated:NO];
                             }
                             else {
                                 // show toast
                                 [self.view makeToast:NSLocalizedString(@"enable_gps",nil)];

                             }
                         }
                         else {
                             [self callLogin];
                         }
                     }];
}

-(void)closeAction:(id)sender {
    NSLog(@"    closeAction");
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
                         if ([self isLogged]) {
                             NSLog(@"closeAction logueado");
                             [self logout];
                         }
                         else {
                             NSLog(@"closeAction no logueado");
                             [self callLogin];
                         }
                     }];
}

- (void)historyAction:(id)sender{
    NSLog(@"    historyAction");
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
                         if ([self isLogged]) {
                             HistoryViewController *historyVC = [[HistoryViewController alloc] initWithNibName:nil bundle:nil];
                             [self.navigationController pushViewController:historyVC animated:NO];
                         }
                         else {
                             [self callLogin];
                         }
                     }];
}

-(BOOL)isLogged {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"login"];
    NSString *pass = [defaults objectForKey:@"password"];

    if ((user != nil) && (pass != nil)) return YES;

    return NO;
}

-(void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *login = [defaults objectForKey:@"login"];
    NSString *uuid = [defaults objectForKey:@"uuid"];

    NSDictionary *params = @{@"login": login, @"uuid" : uuid};

    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api driverLogout:params
              success:^(BOOL success, id response) {
                  if(success) {
                      NSDictionary *dictionary = (NSDictionary *)response;
                      NSLog(@"driverLogout response: %@",dictionary);

                      [self clearUsersDefault];

                      [self callLogin];
                  }
                  else {
                      NSLog(@"driverLogout error: %@",response);
                      [self.view makeToast:NSLocalizedString(@"error_net",nil)];
                  }
              }];

}

-(void)clearUsersDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:@"login"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"name"];
    [defaults removeObjectForKey:@"driver_id"];

    [defaults synchronize];
}

-(void)callLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)textToSpeech:(NSString *) message {
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
    [utterance setRate:0.5f];
    [synthesizer speakUtterance:utterance];
}

#pragma mark - statusService
-(void) checkStatusService {

    NSLog(@"checkStatusService");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *serviceId = [defaults objectForKey:@"service_id"];

    if ((driverId || [driverId isEqual:[NSNull null]] )  &&
        (serviceId || [serviceId isEqual:[NSNull null]] )
        ) {
        NSLog(@"checkStatusService - %@ %@",driverId, serviceId);

    //NSDictionary *params = @{@"driver_id":driverId, @"service_id":serviceId};
    NSDictionary *params = @{@"driver_id":driverId };
   //     NSLog(@"checkStatusService %@",params);


    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api serviceStatus:params success:^(BOOL success, id response) {
        NSLog(@"response %@",response);

        if (success) {
            NSDictionary *d = (NSDictionary *)response;
            NSLog(@"serviceStatus response: %@",d);

            NSLog(@"serviceStatus response: service_id: %@ status_id %@",
                  d[@"id"],d[@"status_id"]);

            long statusId = [d[@"status_id"] integerValue];

            if ((statusId == 2) || (statusId == 4)) {
                NSLog(@"service recover");

                // call map view
                Service *service = [[Service alloc] initWithObject:[d[@"id"] integerValue]
                                                           address:d[@"address"]
                                                      neighborhood:d[@"barrio"]
                                                       destination:(d[@"destination"] != [NSNull null]) ? d[@"destination"] : nil
                                                       observation:(d[@"obs"] != [NSNull null]) ? d[@"obs"] : nil
                                                          latitude:[d[@"from_lat"] floatValue]
                                                         longitude:[d[@"from_lng"] floatValue]
                                                            kindId:(int)[d[@"kind_id"] integerValue]
                                                      scheduleType:(int)[d[@"schedule_type"] integerValue]
                                                   serviceDateTime:(d[@"service_date_time"] != [NSNull null]) ? d[@"service_date_time"] : nil
                                                          userName:[d[@"user"] objectForKey:@"name"]
                                                            status:statusId];

                // save service recover


                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                MapViewController *mapVC = [[MapViewController alloc] initWithNibName:nil bundle:nil];
                mapVC.delegate = self;
                mapVC.service = service;

                [self.navigationController pushViewController:mapVC animated:YES];

            }
        }

    }];
    }
    else {
        NSLog(@"No hay servicio por recuperar");
    }

}


@end
