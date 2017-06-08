//
//  AgendaVWC.m
//  taxisya
//
//  Created by NTTak3 on 23/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "AgendaVWC.h"
#import "JSON.h"
#import "TYUsserProfile.h"
#import "ServiceVWC.h"


@interface AgendaVWC ()
@end

@implementation AgendaVWC

@synthesize delegate                        = _delegate;

@synthesize scrvwAgendar                    = _scrvwAgendar;
@synthesize vwDatePicker                    = _vwDatePicker;
@synthesize datePicker                      = _datePicker;
@synthesize pickerVW                        = _pickerVW;
@synthesize maPickerVW                      = _maPickerVW;

@synthesize btnAirport                      = _btnAirport;
@synthesize btnMessaging                    = _btnMessaging;
@synthesize btnOutside                      = _btnOutside;
@synthesize btnPerHour                      = _btnPerHour;

@synthesize currentAgendType                = _currentAgendType;

@synthesize lbDate                          = _lbDate;

@synthesize lbAddress1                      = _lbAddress1;
@synthesize txtfAddress2                    = _txtfAddress2;
@synthesize txtfAddress3                    = _txtfAddress3;
@synthesize txtfAddress4                    = _txtfAddress4;
@synthesize txtfAddress5                    = _txtfAddress5;
@synthesize txtfAddress6                    = _txtfAddress6;

@synthesize txtfDestination                 = _txtfDestination;

@synthesize vwMiddle                        = _vwMiddle;
@synthesize vwBottom                        = _vwBottom;

@synthesize vwLoading                       = _vwLoading;

@synthesize tysUsser                        = _tysUsser;

@synthesize myAgendVWC                      = _myAgendVWC;

@synthesize currentViewType                 = _currentViewType;

@synthesize qualityService                  = _qualityService;
@synthesize currentAgendIdFinished          = _currentAgendIdFinished;

@synthesize dateForServer                   = _dateForServer;

@synthesize registerVWC                     = _registerVWC;

@synthesize latitudeAddress                 = _latitudeAddress;
@synthesize longitudeAddress                = _longitudeAddress;

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

    [self setupViewAgendar];

    [self.vwDatePicker setFrame:CGRectMake(0, 47, 320, self.view.frame.size.height - 47)];
    [self.vwLoading setFrame:CGRectMake(0, 47, 320, self.view.frame.size.height - 47)];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePicker)];
    [_datePicker addGestureRecognizer:tapGesture];

    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePicker)];
    [_pickerVW addGestureRecognizer:tapGesture2];

    self.currentAgendType = AgendTypeNone;

    [_lbDate setFont:UI_FONT_1(17)];
    [_lbAddress1 setFont:UI_FONT_1(13)];
    [_txtfAddress2 setFont:UI_FONT_1(13)];
    [_txtfAddress3 setFont:UI_FONT_1(13)];
    [_txtfAddress4 setFont:UI_FONT_1(13)];
    [_txtfAddress5 setFont:UI_FONT_1(13)];
    [_txtfAddress6 setFont:UI_FONT_1(13)];
    
    _txtfAddress2.enabled = NO;

    [_txtfDestination setFont:UI_FONT_1(13)];

    self.maPickerVW = [[NSMutableArray alloc] init];
    NSString  *d1 = @"Calle", *d2 = @"Carrera", *d3 = @"Transversal", *d4 = @"Avenida", *d5 = @"Diagonal";
    [_maPickerVW addObject:d1];
    [_maPickerVW addObject:d2];
    [_maPickerVW addObject:d3];
    [_maPickerVW addObject:d4];
    [_maPickerVW addObject:d5];
    

    _pickerVW.backgroundColor = [UIColor whiteColor];
    _datePicker.backgroundColor = [UIColor whiteColor];

    _pickerVW.hidden = YES;

    _titleOne1.text = NSLocalizedString(@"schedule_title_one_1", nil);
    _titleOne2.text = NSLocalizedString(@"schedule_title_one_2", nil);
    _titleTwo1.text = NSLocalizedString(@"schedule_title_two_1", nil);
    _titleTwo2.text = NSLocalizedString(@"schedule_title_two_2", nil);
    _titleThree1.text = NSLocalizedString(@"schedule_title_three_1", nil);
    _titleThree2.text = NSLocalizedString(@"schedule_title_three_2", nil);
    _middleTitleOne1.text = NSLocalizedString(@"schedule_middle_one_1", nil);
    _middleTitleOne2.text = NSLocalizedString(@"schedule_middle_one_2", nil);
    _confirmarSolcitud.text = NSLocalizedString(@"schedule_confirmation", nil);

    [_buttonAgendamientos setTitle:NSLocalizedString(@"schedule_button_schedules", nil) forState:UIControlStateNormal];

    [_buttonNewAgendamiento setTitle:NSLocalizedString(@"schedule_button_new", nil) forState:UIControlStateNormal];

    [_lbDate setText:NSLocalizedString(@"schedule_set_date", nil)];


    // startUpdateLocation
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

- (void)setupViewAgendar{

    [self.scrvwAgendar  setContentSize:CGSizeMake(0, 842)];

}

- (void)show:(BOOL)show{

    if(show){



        self.currentViewType = CurrentViewTypeAgenda;

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

        [self closeKeyBoard];

        [UIView animateWithDuration:0.45
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void){

                             self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                             self.view.alpha = 0;

                         }
                         completion:^(BOOL f){

                             [_delegate AgendaVWCNeedRemove];

                         }];

    }

}

- (void)hideDatePicker{

    [self showDatePicker:NO];

}

- (void)showDatePicker:(BOOL)show{

    if(show){

        [self.view bringSubviewToFront:_vwDatePicker];
        [_datePicker setTransform:CGAffineTransformMakeTranslation(0, _datePicker.frame.size.height)];
        _pickerVW.hidden = YES;
        _datePicker.hidden = NO;

        int hour = (60 * 60) * 24;

        [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow] + (60 * 60)]];
        [self.datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow] + hour + (60 * 60)]];

        [self onDateChanged:nil];

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_datePicker setTransform:CGAffineTransformIdentity];

                         }
                         completion:^(BOOL f){

                         }];

    }else{

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_datePicker setTransform:CGAffineTransformMakeTranslation(0, _datePicker.frame.size.height)];

                             //[_pickerVW setTransform:CGAffineTransformMakeTranslation(0, _pickerVW.frame.size.height)];

                         }
                         completion:^(BOOL f){

                             [self.view sendSubviewToBack:_vwDatePicker];

                         }];

    }

}

- (IBAction)setAddress:(id)sender {
    NSLog(@"setAddress: ");
    
    ServiceVWC *serviceVWC = [[ServiceVWC alloc] initWithNibName:@"ServiceVWC" bundle:nil];
    serviceVWC.isSchedule = YES;
    serviceVWC.delegate = self;
    [self.navigationController pushViewController:serviceVWC animated:YES];

}

- (IBAction)onCloseKeyBoard:(id)sender{

    [self closeKeyBoard];

}

- (void)closeKeyBoard{

    [_txtfAddress2 resignFirstResponder];
    [_txtfAddress3 resignFirstResponder];
    [_txtfAddress4 resignFirstResponder];
    [_txtfAddress5 resignFirstResponder];
    [_txtfAddress6 resignFirstResponder];
    [_txtfDestination resignFirstResponder];

    [self showMiddleIfNeeded];

}

- (void)showPicker:(BOOL)show{

    if(show){

        _pickerVW.hidden = YES; // NO;
        _datePicker.hidden = YES;

        [self.view bringSubviewToFront:_vwDatePicker];
        [_pickerVW setTransform:CGAffineTransformMakeTranslation(0, _pickerVW.frame.size.height)];

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_pickerVW setTransform:CGAffineTransformIdentity];

                         }
                         completion:^(BOOL f){

                         }];

    }
}

- (void)showLoading:(BOOL)show{

    if(show){

        [self.view bringSubviewToFront:_vwLoading];

    }else{

        [self.view sendSubviewToBack:_vwLoading];

    }

}

- (IBAction)goBack:(id)sender{

    if(_currentViewType == CurrentViewTypeMisAgendamientos){

        _currentViewType = CurrentViewTypeAgenda;

        [_myAgendVWC show:NO];

    }else if (_currentViewType == CurrentViewTypeAgenda){

        //[self show:NO];
        [self.navigationController popViewControllerAnimated:YES];

    }

}

- (IBAction)onDate:(id)sender{

    [self showDatePicker:YES];

}

- (IBAction)onDatePickerBack:(id)sender{

    [self showDatePicker:NO];

    [self showPicker:NO];

}

- (IBAction)onDateChanged:(id)sender{

    NSDate *date = _datePicker.date;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm"];
    _lbDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];

    NSDateFormatter *dfServer = [[NSDateFormatter alloc] init];
    [dfServer setDateFormat:@"yyyy-MM-dd HH:mm"];
    _dateForServer = [NSString stringWithFormat:@"%@", [dfServer stringFromDate:date]];

}

- (IBAction)onPickerAddress1:(id)sender{

    [self showPicker:YES];

}

- (IBAction)selectAddress:(id)sender {
    NSLog(@"selectAddress: ");
}

- (IBAction)onMyAgend:(id)sender{

    self.currentViewType = CurrentViewTypeMisAgendamientos;

    [self initServicesIfNeeded];

    [_tysUsser requestUsserType:TYSUsserTypeAgendHistory object:nil];


    if(!_myAgendVWC){

        self.myAgendVWC = [[MyAgendVWC alloc] initWithNibName:@"MyAgendVWC" bundle:nil delegate:self];
        [self.myAgendVWC.view setFrame:CGRectMake(0, 47, 320, self.view.frame.size.height - 47)];
        [self.view addSubview:_myAgendVWC.view];

    }

    [self.view bringSubviewToFront:_myAgendVWC.view];

    [_myAgendVWC show:YES];

    
//    MyAgendVWC *myAgendVWC = [[MyAgendVWC alloc] initWithNibName:@"MyAgendVWC" bundle:nil delegate:self];
//    [self.navigationController pushViewController:myAgendVWC animated:YES];
    
}

- (IBAction)onMakeAgend:(id)sender{

    if([TYFormatter formatterValidateInternetConnection]){

        if(![TYUsserProfile IsUsserRegistred]){

            if(!_registerVWC){

                self.registerVWC = [[Register alloc] initWithNibName:@"Register" bundle:nil];
                self.registerVWC.delegate = self;
                [self.view addSubview:_registerVWC.view];

            }

            [self.view bringSubviewToFront:_registerVWC.view];
            [_registerVWC show:YES];

        }else{

            if([self validateEnter]){

                [self showLoading:YES];
                [self closeKeyBoard];
                [self showDatePicker:NO];

                NSString *destination = _txtfDestination.text;

                    NSString *type = @"";

                    if(_currentAgendType == AgendTypeAirport){
                        type = @"1";
                    }else if (_currentAgendType == AgendTypeMessaging){
                        type = @"3";
                    }else if (_currentAgendType == AgendTypeOutside){
                        type = @"2";
                    }else if (_currentAgendType == AgendTypePorHour){
                        type = @"4";
                    }else{
                        type = @"1";
                    }


                    if(!destination) destination = @"";

                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:_dateForServer forKey:@"service_date_time"];
                    [dic setObject:type forKey:@"schedule_type"];
                    [dic setObject:_lbAddress1.text forKey:@"address1"];
                    [dic setObject:_txtfAddress2.text forKey:@"address2"];
                    [dic setObject:_txtfAddress3.text forKey:@"address3"];
                    [dic setObject:_txtfAddress4.text forKey:@"address4"];
                    [dic setObject:_txtfAddress5.text forKey:@"address5"];
                    [dic setObject:_txtfAddress6.text forKey:@"address6"];

                    [dic setObject:_fullAddress forKey:@"address"];

                    [dic setObject:_latitudeAddress forKey:@"city_lat"];
                    [dic setObject:_longitudeAddress forKey:@"city_lng"];

                    [dic setObject:destination forKey:@"destination"];


                    [self initServicesIfNeeded];
                    [_tysUsser requestUsserType:TYSUsserTypeAgend object:dic];


            }

        }
    }else{

        [self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:-1];

    }

}

- (BOOL)validateEnter{

    if(!_txtfAddress5.text.length){

        [_txtfAddress5 setText:@"."];

    }

    if(_lbDate.text.length > 4 && ![_lbDate.text isEqualToString:@"Seleccionar fecha y hora"]){

        if(_currentAgendType != AgendTypeNone){

            if(_txtfAddress2.text.length){

                //if(_txtfAddress3.text.length){

                    //if(_txtfAddress4.text.length){

                        if(_txtfAddress2.text.length){

                            if(_currentAgendType == AgendTypeMessaging || _currentAgendType == AgendTypeOutside){

                                if(!_txtfDestination.text && !_txtfDestination.text.length){

                                    [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:205];

                                    return NO;

                                }
                            }

                            if((_currentAgendType == AgendTypeOutside && _txtfDestination.text.length <= 0) || (_currentAgendType == AgendTypeMessaging && _txtfDestination.text.length <= 0)){
                                [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:205];
                                return NO;
                            }
                            return YES;

                        }else{

                            [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:204];

                        }

                    //}else{

                    //    [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:202];

                    //}

                //}else{

                 //   [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:201];

                //}

            }else{

                [self showAlertWithMessage:@"Direccion Incompleta, llena los campos" tag:200];

            }

        }else{

            [self showAlertWithMessage:@"Escoge el tipo de agendamiento" tag:101];

        }

    }else{

        [self showAlertWithMessage:@"Ingrese la Fecha de agendamiento" tag:100];

    }

    return NO;

}

- (void)showAlertWithMessage:(NSString *)message tag:(int)tag{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Aceptar"
                                          otherButtonTitles:nil, nil];

    alert.tag = tag;

    [alert show];

}


- (IBAction)onAirport:(id)sender{

    _currentAgendType = AgendTypeAirport;

    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto-over.png"] forState:UIControlStateNormal];
    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto-over.png"] forState:UIControlStateHighlighted];

    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateNormal];
    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateHighlighted];

    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateNormal];
    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateHighlighted];

    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateNormal];
    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateHighlighted];


    [self showMiddleIfNeeded];

}

- (IBAction)onOutside:(id)sender{

    _currentAgendType = AgendTypeOutside;

    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateNormal];
    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateHighlighted];

    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateNormal];
    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateHighlighted];

    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera-over.png"] forState:UIControlStateNormal];
    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera-over.png"] forState:UIControlStateHighlighted];

    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateNormal];
    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateHighlighted];

    [self showMiddleIfNeeded];

}

- (IBAction)onPerHour:(id)sender{

    _currentAgendType = AgendTypePorHour;

    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateNormal];
    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateHighlighted];

    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateNormal];
    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria.png"] forState:UIControlStateHighlighted];

    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateNormal];
    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateHighlighted];

    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas-over.png"] forState:UIControlStateNormal];
    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas-over.png"] forState:UIControlStateHighlighted];

    [self showMiddleIfNeeded];

}

- (IBAction)onMessaging:(id)sender{

    _currentAgendType = AgendTypeMessaging;

    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateNormal];
    [_btnAirport setImage:[UIImage imageNamed:@"agendar-btn-aeropuerto.png"] forState:UIControlStateHighlighted];

    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria-over.png"] forState:UIControlStateNormal];
    [_btnMessaging setImage:[UIImage imageNamed:@"agendar-btn-mensajeria-over.png"] forState:UIControlStateHighlighted];

    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateNormal];
    [_btnOutside setImage:[UIImage imageNamed:@"agendar-btn-fuera.png"] forState:UIControlStateHighlighted];

    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateNormal];
    [_btnPerHour setImage:[UIImage imageNamed:@"agendar-btn-horas.png"] forState:UIControlStateHighlighted];

    [self showMiddleIfNeeded];

}

- (void)showMiddleIfNeeded{

    if(_currentAgendType == AgendTypeMessaging || _currentAgendType == AgendTypeOutside){


        if(_currentAgendType == AgendTypeMessaging){

            [_txtfDestination setPlaceholder:@"   Ej: Calle 142 # 55-23 apto 402"];

        }else if (_currentAgendType == AgendTypeOutside){

            [_txtfDestination setPlaceholder:@"   Ej: Girardot, Cundinamarca"];

        }

        _vwMiddle.hidden = NO;

        float height = 842 + 127;

        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_scrvwAgendar setContentSize:CGSizeMake(0, height)];

                             [_vwMiddle setAlpha:1];

                             [_vwBottom setTransform:CGAffineTransformMakeTranslation(0, 127)];

                         }
                         completion:^(BOOL f){


                         }];



    }else{

        float height = 842;


        [UIView animateWithDuration:0.3
                         animations:^(void){

                             [_scrvwAgendar setContentSize:CGSizeMake(0, height)];

                             [_vwBottom setTransform:CGAffineTransformIdentity];

                             [_vwMiddle setAlpha:0];

                         }
                         completion:^(BOOL f){

                             _vwMiddle.hidden = YES;

                         }];

    }

}

- (void)makeLogicToAgend:(NSMutableDictionary *)dic{

    NSString *error = [dic objectForKey:@"error"];

    if(error && error != (NSString *)[NSNull null]){

        if([error isEqualToString:@"0"]){

            [self showAlertWithMessage:@"15 minutos antes de cumplirse la hora registrada te enviaremos un servicio para realizar tu agendamiento" tag:300];

        }else{

            [self showAlertWithMessage:@"No se ha podido registrar tu agendamiento intentalo mas tarde." tag:-1];

        }

    }else{

        [self showAlertWithMessage:@"No se ha podido registrar tu agendamiento intentalo mas tarde." tag:-1];

    }


}

- (void)makeLogicToAgendHistory:(NSMutableDictionary *)dic{

    NSMutableArray *array = nil;

    if(dic.count){

        NSString *error = [dic objectForKey:@"error"];

        if(error){

            if([error isEqualToString:@"401"]){

                [_myAgendVWC setAgendInfo:nil];

                return;

            }

        }

        NSMutableDictionary *schedules = [dic objectForKey:@"schedules"];

        array = [[NSMutableArray alloc] init];

        for(NSMutableDictionary *agend in schedules){


            NSString *schedule_type =   [agend objectForKey:@"schedule_type"];
            NSString *agenda_id =       [agend objectForKey:@"id"];
            NSString *status =          [agend objectForKey:@"status"];
            NSString *destination =     [agend objectForKey:@"destination"];


            TYAgend *tyAgend = [[TYAgend alloc] init];

            //Agend ID

            tyAgend.idAgend = agenda_id;

            //Status

            if([status isEqualToString:@"1"]){ //En espera

                tyAgend.tyAgendStatus = TYAgendStatusWaiting;

            }else if ([status isEqualToString:@"2"]){ //Asignado

                tyAgend.tyAgendStatus = TYAgendStatusAssigned;

            }else if ([status isEqualToString:@"3"]){//Progreso

                tyAgend.tyAgendStatus = TYAgendStatusProgress;

            }else if ([status isEqualToString:@"4"]){//Cancelado

                tyAgend.tyAgendStatus = TYAgendStatusCanceled;

            }else if ([status isEqualToString:@"5"]){//Finalizado

                tyAgend.tyAgendStatus = TYAgendStatusFinished;

            }

            //Type

            if([schedule_type isEqualToString:@"1"]){//Aeropuerto

                tyAgend.typeAgend = @"Aeropuerto";

            }else if([schedule_type isEqualToString:@"2"]){//Fuera de bogota

                tyAgend.typeAgend = @"Fuera de Bogota";

            }else if ([schedule_type isEqualToString:@"3"]){//Mensajeria

                tyAgend.typeAgend = @"Mensajeria";

            }else if ([schedule_type isEqualToString:@"4"]){//Por horas

                tyAgend.typeAgend = @"Por Horas";

            }

            NSString *address1 =        [agend objectForKey:@"address_index"];
            NSString *address2 =        [agend objectForKey:@"comp1"];
            NSString *address3 =        [agend objectForKey:@"comp2"];
            NSString *address4 =        [agend objectForKey:@"no"];
            NSString *address5 =        [agend objectForKey:@"obs"];
            NSString *address6 =        [agend objectForKey:@"barrio"];
            NSString *addressFull =     [agend objectForKey:@"address"];

            TYAddress *tyAddress = [[TYAddress alloc] init];
            tyAddress.address1 = address1;
            tyAddress.address2 = address2;
            tyAddress.address3 = address3;
            tyAddress.address4 = address4;
            tyAddress.address5 = address5;
            tyAddress.address6 = address6;
            tyAddress.addressFull = addressFull;
            tyAddress.destination = destination;

            // Address
            tyAgend.tyAddress = tyAddress;

            NSString *driver_ID =       [agend objectForKey:@"driver_id"];

//            NSLog(@" 1 :::: XXXXXXXX %@", driver_ID);

            if(driver_ID && driver_ID != (NSString *)[NSNull null]){

                NSMutableDictionary *driver = [agend objectForKey:@"driver"];

                NSString *taxi_name =       @"";
                NSString *taxi_lastName =   @"";
                NSString *taxi_urlImage =   @"";
                NSString *taxi_placa =      @"";

                NSString *taxi_brand =      @"";
                NSString *taxi_model =      @"";

//                NSLog(@" 2 :::: XXXXXXXX %@", [driver_ID description]);

                if(driver){

                    taxi_name =       [driver objectForKey:@"name"];
                    taxi_lastName =   [driver objectForKey:@"lastname"];
                    taxi_urlImage =   [driver objectForKey:@"picture"];

//                    NSLog(@" 3 :::: XXXXXXXX %@", taxi_urlImage);

                    NSMutableDictionary *car = [driver objectForKey:@"car"];

                    if(car){

                        taxi_placa = [car objectForKey:@"placa"];
                        taxi_brand = [car objectForKey:@"car_brand"];
                        taxi_model = [car objectForKey:@"model"];

                    }

                }

                TYTaxiProfile *tyTaxi = [[TYTaxiProfile alloc] init];
                tyTaxi.name = taxi_name;
                tyTaxi.lastName = taxi_lastName;
                tyTaxi.urlImage = taxi_urlImage;
                tyTaxi.placa = taxi_placa;
                tyTaxi.brand = taxi_brand;
                tyTaxi.model = taxi_model;

                //Taxi Profile
                tyAgend.tyTaxiProfile = tyTaxi;

            }

            NSString *date = [agend objectForKey:@"service_date_time"];

            //Date
            tyAgend.dateAgend = date;

            [array addObject:tyAgend];

        }

    }

    [_myAgendVWC setAgendInfo:array];

}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if([NTUDeviceInfo NTUDIGetDevice] == DeviceIphone5){

        if(textField == _txtfDestination){

            [_scrvwAgendar setContentOffset:CGPointMake(0, _vwMiddle.frame.origin.y - 130) animated:YES];

        }else{

            [_scrvwAgendar setContentOffset:CGPointMake(0, textField.frame.origin.y - 160) animated:YES];

        }

        if(_currentAgendType == AgendTypeMessaging || _currentAgendType == AgendTypeOutside){
            float height = 1200 + 127;
            [_scrvwAgendar setContentSize:CGSizeMake(0, height)];
        }else{
            float height = 1200;
            [_scrvwAgendar setContentSize:CGSizeMake(0, height)];
        }


    }else{

        if(textField == _txtfDestination){

            [_scrvwAgendar setContentOffset:CGPointMake(0, _vwMiddle.frame.origin.y - 90) animated:YES];

        }else{

            [_scrvwAgendar setContentOffset:CGPointMake(0, textField.frame.origin.y - 120) animated:YES];

        }

        if(_currentAgendType == AgendTypeMessaging || _currentAgendType == AgendTypeOutside){
            float height = 1500 + 127;
            [_scrvwAgendar setContentSize:CGSizeMake(0, height)];
        }else{
            float height = 1500;
            [_scrvwAgendar setContentSize:CGSizeMake(0, height)];
        }

    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self closeKeyBoard];

    return YES;

}

- (void)initServicesIfNeeded{

    if(!_tysUsser){

        self.tysUsser = [[TYSUsser alloc] initwithDelegate:self];

    }

}

#pragma mark -
#pragma mark - UIPickerViewDelegate-source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _maPickerVW.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return  [_maPickerVW objectAtIndex:row];

}

// Set the width of the component inside the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

// Item picked
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

//    [self showPickerView:NO];
//
    [_lbAddress1 setText:[_maPickerVW objectAtIndex:row]];

}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    long tag = alertView.tag;

    if(tag == -1){


    }else if(tag == 100){

        [_scrvwAgendar setContentOffset:CGPointMake(0, _lbDate.frame.origin.y - 80) animated:YES];

        [self showDatePicker:YES];

        [self closeKeyBoard];

    }else if (tag == 101){

        [_scrvwAgendar setContentOffset:CGPointMake(0, _btnAirport.frame.origin.y - 100) animated:YES];

        [self closeKeyBoard];

    }else if (tag == 200){

        [_txtfAddress2 becomeFirstResponder];

    }else if (tag == 201){

        [_txtfAddress3 becomeFirstResponder];

    }else if (tag == 202){

        [_txtfAddress4 becomeFirstResponder];

    }else if (tag == 203){

        [_txtfAddress5 becomeFirstResponder];

    }else if (tag == 204){

        [_txtfAddress6 becomeFirstResponder];

    }else if (tag == 205 ){

        [_txtfDestination becomeFirstResponder];

    }else if (tag == 300){

        [self onMyAgend:nil];

    }

}

#pragma mark -
#pragma mark - TYSUserDelegate

- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status{

    [self showLoading:NO];

    if(type == TYSUsserTypeAgend){

        if(status == ServiceStatusOk){

            NSMutableDictionary *dic = [response JSONValue];

            if(dic){

                [self makeLogicToAgend:dic];

            }

        }else{

            [self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:-1];

        }

    }else if (type == TYSUsserTypeAgendHistory){

        if(status == ServiceStatusOk){

            NSMutableDictionary *dic = [response JSONValue];

            if(dic){

                [self makeLogicToAgendHistory:dic];

            }else{

                [self  makeLogicToAgendHistory:nil];

            }

        }else{

            [self  makeLogicToAgendHistory:nil];

            [self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:-1];

        }

    }

}

#pragma mark -
#pragma mark - MyAgendVWCDelegate

- (void)MyAgendVWCCancelAgendWithId:(NSString *)agendId{

    [self initServicesIfNeeded];

    [_tysUsser requestUsserType:TYSUsserTypeAgendCancel object:agendId];

}

- (void)MyAgendVWCFinishedAgendWithId:(NSString *)agendId{

    if(!_qualityService){

        self.qualityService = [[QualityService alloc] initWithNibName:@"QualityService" bundle:nil delegate:self];

        [self.view addSubview:_qualityService.view];

    }

    self.currentAgendIdFinished = agendId;

    [self.view bringSubviewToFront:_qualityService.view];

    [_qualityService show:YES];

    [self goBack:nil];

}

- (void)MyAgendVWCNeedRefresh{

    [self initServicesIfNeeded];

    [_tysUsser requestUsserType:TYSUsserTypeAgendHistory object:nil];

}

#pragma mark -
#pragma mark - QualityServiceDelegate

- (void)QualityServiceTypePressed:(NSString *)type{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:type                      forKey:@"score"];
    [dictionary setObject:_currentAgendIdFinished   forKey:@"schedule_id"];

    [self initServicesIfNeeded];
    [_tysUsser requestUsserType:TYSUsserTypeAgendFinish object:dictionary];

}

- (void)QualityServiceNeedRemove{

    [_qualityService.view removeFromSuperview];

    self.qualityService = nil;

}

#pragma mark -
#pragma mark - RegisterDelegateVWC

- (void)RegisterVWCLoginsuccesfull:(BOOL)op{

    if(op){

        [self onMakeAgend:nil];

        [self.registerVWC.view removeFromSuperview];
        self.registerVWC = nil;

    }else{



    }

}

- (void)RegisterVWCGoBack{

    if(![TYUsserProfile IsUsserRegistred]){

        //[self show:NO];
        [self.navigationController popViewControllerAnimated:NO];

    }else{

        [_registerVWC show:NO];

    }

}

-(void)ServiceAddressSchedule:(NSString *) address lat:(NSString *)lat lng:(NSString *) lng {
    NSLog(@"ServiceAddressSchedule %@ %@ %@",address, lat, lng);
    _txtfAddress2.text = address;
    _fullAddress = address;
    _latitudeAddress = lat;
    _longitudeAddress = lng;
    
}


@end
