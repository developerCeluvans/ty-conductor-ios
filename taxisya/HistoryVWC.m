//
//  HistoryVWC.m
//  taxisya
//
//  Created by NTTak3 on 23/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "HistoryVWC.h"
#import "UIView+Xib.h"
#import "JSON.h"
#import "TYUsserProfile.h"
#import "HistoryReclamo.h"

@interface HistoryVWC ()

@property(nonatomic, strong) IBOutlet UIImageView   *imgvwScrvwFondo;
@property(nonatomic, strong) IBOutlet UIImageView   *imgvwNoServices;

@property(nonatomic, assign) int                    datesX;
@property(nonatomic, assign) int                    taxiY;



@end

@implementation HistoryVWC

@synthesize delegate                    = _delegate;

@synthesize imgvwScrvwFondo              = _imgvwScrvwFondo;
@synthesize imgvwNoServices              = _imgvwNoServices;

@synthesize scrvwDates                   = _scrvwDates;
@synthesize scrvwTaxistas                = _scrvwTaxistas;
@synthesize tysUsser                     = _tysUsser;

@synthesize datesX                      = _datesX;
@synthesize taxiY                       = _taxiY;

@synthesize registerVWC                 = _registerVWC;

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
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    [self.view setFrame:[[NTUDeviceInfo sharedInstance] getRootFrameForDeviceWithOrientation:UIInterfaceOrientationPortrait]];

    [self.view setBackgroundColor:UI_COLOR_247];


    [self.scrvwTaxistas setFrame:CGRectMake(0, 100, 320,  self.view.frame.size.height - 100)];


    [_imgvwScrvwFondo setHidden:YES];

    // label no services
    self.labelNotServices = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/2 - 17, screenWidth, 34)];
    [self.labelNotServices setTextColor:[UIColor grayColor]];
    [self.labelNotServices setText:NSLocalizedString(@"history_no_services",nil)];
    [self.labelNotServices setFont:[self.labelNotServices.font fontWithSize:18]];
    self.labelNotServices.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labelNotServices];

    [self show:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show:(BOOL)show{

    if(show){

        [self initServicesIfNeeded];
        [_tysUsser requestUsserType:TYSUsserTypeHistory object:nil];


        self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.view.alpha = 0;

        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                             self.view.alpha = 1;

                         }
                         completion:^(BOOL f){

                         }];


        if(![TYUsserProfile IsUsserRegistred]){

            if(!_registerVWC){

                self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
                self.registerVWC.delegate = self;
                [self.view addSubview:_registerVWC.view];

            }

            [self.view bringSubviewToFront:_registerVWC.view];
            [_registerVWC show:YES];

        }


    }else{

        [UIView animateWithDuration:0.45
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                             self.view.alpha = 0;

                         }
                         completion:^(BOOL f){

                             [_delegate HistoryVWCNeedRemove];

                         }];

    }

}

- (IBAction)goBack:(id)sender{

    //[self show:NO];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)initServicesIfNeeded{

    if(!_tysUsser){

        self.tysUsser = [[TYSUsser alloc] initwithDelegate:self];

    }

}

- (void)showAlertWithMessage:(NSString *)message tag:(int)tag{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil, nil];

    alert.tag = tag;

    [alert show];

}

#pragma mark -
#pragma mark - HistoryDateTime

- (void)HistoryDateNeedDetailId:(NSString *)idDate{

    for(UIView *subview in _scrvwDates.subviews){

        if([subview isKindOfClass:[HistoryDateItem class]]){

            HistoryDateItem *item  = (HistoryDateItem *)subview;

            if(![item.dateId isEqualToString:idDate]){

                [item setTextNormal:YES];

            }else{

                [item setTextNormal:NO];

            }

        }
    }

    for(UIView *subview in _scrvwTaxistas.subviews){

//        if([subview isKindOfClass:[HistoryTaxiItem class]]){
//
//
//
//        }

        [subview removeFromSuperview];

    }


    [_tysUsser requestUsserType:TYSUsserTypeHistoryDetail object:idDate];

}

#pragma mark -
#pragma mark - TYSUsserDelegate

- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status{

    if(type == TYSUsserTypeHistory){

        if(status == ServiceStatusOk){

            NSMutableDictionary *dic = [response JSONValue];

            if(dic){

                NSLog(@"dic %@",dic);
                NSArray *dayList = [dic objectForKey:@"dayList"];
                NSLog(@"dayList %@", dayList);


                if(dayList){

                    _datesX = 0;

                    for(NSString *str in dayList){
                        NSArray *strDate = [str componentsSeparatedByString:@"-"];

                        if ([strDate count] > 1) {
                            NSString *strDay = [strDate objectAtIndex:2];
                            NSString *strMonth = [strDate objectAtIndex:1];
                            NSString *strYear = [strDate objectAtIndex:0];

                            NSLog(@"strDate %@ %@ %@", strDay, strMonth, strYear);
                            NSString *strDate1 = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
//                        NSCalendar *cal = [NSCalendar currentCalendar];
//                        NSDateComponents *comps = [cal components:NSMonthCalendarUnit fromDate:[NSDate date]];
//                        NSString *month = [self getMonthName:[comps month]];
                            NSString *month = [self getMonthName:[strMonth integerValue]];

                            NSLog(@"Cuadrando pestaña %@", month);
                            NSString *prefix = @"";

                            if ([month length] > 3){
                                prefix = [month substringToIndex:3];
                            } else {
                                prefix = month;
                            }


                            HistoryDateItem *item = (HistoryDateItem *)[UIView viewFromNib:@"HistoryDateItem" bundle:nil];
                            [item setAddress1:prefix
                                     address2:strDay
                                       idDate:strDate1
                                     delegate:self];
                            [_scrvwDates addSubview:item];
                            [item setFrame:CGRectMake(_datesX * item.frame.size.width, 3, item.frame.size.width, item.frame.size.height)];
                            [_scrvwDates setContentSize:CGSizeMake(_datesX*item.frame.size.width+item.frame.size.width, 0)];

                            if (_datesX == 0){
                                [item setTextNormal:NO];
                            }
                            _datesX++;
                        }
                    }
                }
                NSMutableDictionary *services = [dic objectForKey:@"services"];

                if (services){
                    if (services.count){
                        [_imgvwScrvwFondo setHidden:NO];
                        [_imgvwNoServices setHidden:YES];
                    } else {
                        [_imgvwScrvwFondo setHidden:YES];
                        [_imgvwNoServices setHidden:NO];
                    }
                    _taxiY = 0;
                    // determine first day in dayList
                    NSString *firstDay = [dayList objectAtIndex:0];
                    for (NSDictionary *dic in services) {

                        NSDictionary *dicDriver = [dic objectForKey:@"driver"];
                        NSString *name =        @"";
                        NSString *lastname =    @"";
                        NSString *placa =       @"";
                        NSString *imagen =      @"";
                        NSString *cellphone =   @"";
                        NSString *brand = @"";
                        NSString *model = @"";
                        if (dicDriver) {
                            name =          [dicDriver objectForKey:@"name"];
                            lastname =      [dicDriver objectForKey:@"lastname"];
                            imagen =        [dicDriver objectForKey:@"picture"];
                            cellphone =     [dicDriver objectForKey:@"cellphone"];
                            NSDictionary *dicCar = [dic objectForKey:@"car"];
                            if (dicCar) {
                                placa = [dicCar objectForKey:@"placa"];
                                brand = [dicCar objectForKey:@"car_brand"];
                                model = [dicCar objectForKey:@"model"];
                            }
                        }
                        if (!name)name = @"name";
                        if (!lastname)lastname = @"lastname";
                        if (!placa)placa = @"placa";
                        if (!imagen)imagen = @"http://static.freepik.com/foto-gratis/personas--sonriendo--felicidad--personas_3229418.jpg";
                        if (!cellphone || cellphone.length < 3) cellphone = @"--";

                        NSLog(@"service service_date_time %@", [dic objectForKey:@"updated_at"]);

                        // get date from timestamp for compare
                        NSString *dateItem = [dic objectForKey:@"updated_at"];
                        dateItem = [dateItem substringToIndex:10];
                        if ([firstDay isEqualToString:dateItem]) {
                        HistoryTaxiItem *item = (HistoryTaxiItem *)[UIView viewFromNib:@"HistoryTaxiItem" bundle:nil];
                        [item setDelegate:self];

                        item.titleBtnReclamo.text = NSLocalizedString(@"send_claim",nil);
                        [item setName:[NSString stringWithFormat:@"%@, %@", name, lastname]
                                placa:placa
                             urlImage:[NSString stringWithFormat:@"%@%@", SERVICES, imagen]
                                phone:cellphone
                                marca:[NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"title_brand",nil),brand, model] service:[dic[@"id"] intValue]];

                        [_scrvwTaxistas addSubview:item];
                        [item setFrame:CGRectMake(0, _taxiY * item.frame.size.height, item.frame.size.width, item.frame.size.height)];

                        [_scrvwTaxistas setContentSize:CGSizeMake(0, _taxiY*item.frame.size.height+item.frame.size.height)];
                        _taxiY++;
                        }
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.labelNotServices.hidden = YES;
                    });
                }


            } else{
//                NSLog(@" HISTORY :: %@", response);
            }
        } else {
            [self showAlertWithMessage:NSLocalizedString(@"check_internet_connection",nil) tag:-1];
        }
    } else if (type == TYSUsserTypeHistoryDetail){
        if (status == ServiceStatusOk) {
            NSLog(@"RESPONSE %@", response);
            NSMutableDictionary *dic = [response JSONValue];
            if (dic) {
                NSMutableDictionary *services = [dic objectForKey:@"services"];
                if (services) {
                    if (services.count) {
                        [_imgvwScrvwFondo setHidden:NO];
                        [_imgvwNoServices setHidden:YES];
                    } else {
                        [_imgvwScrvwFondo setHidden:YES];
                        [_imgvwNoServices setHidden:NO];
                    }
                    _taxiY = 0;
                    for (NSDictionary *dic in services) {
                        NSLog(@"%@",[dic description]);
                        NSDictionary *dicDriver = [dic objectForKey:@"driver"];
                        NSString *name = @"";
                        NSString *lastname = @"";
                        NSString *placa = @"";
                        NSString *imagen = @"";
                        NSString *cellPhone = @"";
                        NSString *brand = @"";
                        NSString *model = @"";
                        if (dicDriver && dicDriver != (NSDictionary *)[NSNull null]) {
                            name = [dicDriver objectForKey:@"name"];
                            lastname = [dicDriver objectForKey:@"lastname"];
                            imagen = [dicDriver objectForKey:@"picture"];
                            cellPhone = [dicDriver objectForKey:@"cellphone"];
                            NSDictionary *dicCar = [dic objectForKey:@"car"];
                            if (dicCar) {
                                placa = [dicCar objectForKey:@"placa"];
                                brand = [dicCar objectForKey:@"car_brand"];
                                model = [dicCar objectForKey:@"model"];
                            }
                            if (!name)name = @"name";
                            if (!lastname)lastname = @"lastname";
                            if (!placa)placa = @"placa";
                            if (!imagen)imagen = @"http://static.freepik.com/foto-gratis/personas--sonriendo--felicidad--personas_3229418.jpg";
                            if (!cellPhone || cellPhone.length < 3) cellPhone = @"--";
                            NSLog(@"service detail service_date_time %@", [dic objectForKey:@"updated_at"]);

                            HistoryTaxiItem *item = (HistoryTaxiItem *)[UIView viewFromNib:@"HistoryTaxiItem" bundle:nil];
                            [item setDelegate:self];
                            item.titleBtnReclamo.text = NSLocalizedString(@"send_claim",nil);
                            [item setName:[NSString stringWithFormat:@"%@, %@", name, lastname]
                                    placa:placa
                                 urlImage:[NSString stringWithFormat:@"%@%@", SERVICES, imagen]
                                    phone:cellPhone
                                    marca:[NSString stringWithFormat:@"%@: %@ %@",NSLocalizedString(@"title_brand",nil), brand, model] service:[dic[@"id"] intValue]];
                            [_scrvwTaxistas addSubview:item];
                            [item setFrame:CGRectMake(0, _taxiY * item.frame.size.height, item.frame.size.width, item.frame.size.height)];
                            [_scrvwTaxistas setContentSize:CGSizeMake(0, _taxiY*item.frame.size.height+item.frame.size.height)];
                            _taxiY++;
                        }
                    }
                }
            } else {
//                NSLog(@" HISTORY DETAIL :: %@", response);
            }
        } else {
            [self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:-1];
        }
    }
}

- (NSString*)getMonthName:(long)month
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    return [[formatter monthSymbols] objectAtIndex:(month - 1)];
}

- (void)createFooter{

//    UIImageView *imgvw = [[UIImageView alloc] INITWITH]

}

#pragma mark -
#pragma mark - RegisterDelegateVWC

- (void)RegisterVWCLoginsuccesfull:(BOOL)op{

    if (op) {
        [self.registerVWC.view removeFromSuperview];
        self.registerVWC = nil;
    }

}

- (void)RegisterVWCGoBack{

    if (![TYUsserProfile IsUsserRegistred]) {
        //[self show:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [_registerVWC show:NO];
    }

}

- (void)showReclamo:(int64_t)serviceID {
    self.reclamo = [[HistoryReclamo alloc] init];
    [self.reclamo setServiceID:serviceID];
    [self.reclamo setDelegate:self];
    [self.view addSubview:self.reclamo.view];
}

- (void)finishReclamo {
    NSLog(@"Entra al finishRecla");
    [self.reclamo.view removeFromSuperview];
}

@end
