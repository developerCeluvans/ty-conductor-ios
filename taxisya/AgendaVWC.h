//
//  AgendaVWC.h
//  taxisya
//
//  Created by NTTak3 on 23/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSUsser.h"
#import "MyAgendVWC.h"
#import "QualityService.h"
#import "Register.h"
#import <CoreLocation/CoreLocation.h>
#import "ServiceVWC.h"

typedef enum{

    AgendTypeAirport,
    AgendTypeOutside,
    AgendTypePorHour,
    AgendTypeMessaging,
    AgendTypeNone

} AgendType;

typedef enum{

    CurrentViewTypeAgenda,
    CurrentViewTypeMisAgendamientos

}CurrentViewType;

@protocol AgendaVWCDelegate;

//CLLocationManagerDelegate
@interface AgendaVWC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, TYSUsserDelegate, MyAgendVWCDelegate, QualityServiceDelegate, RegisterDelegate,ServiceVWCDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleOne1;
@property (weak, nonatomic) IBOutlet UILabel *titleOne2;
@property (weak, nonatomic) IBOutlet UILabel *titleTwo1;
@property (weak, nonatomic) IBOutlet UILabel *titleTwo2;
@property (weak, nonatomic) IBOutlet UILabel *titleThree1;
@property (weak, nonatomic) IBOutlet UILabel *titleThree2;

@property (weak, nonatomic) IBOutlet UILabel *middleTitleOne1;
@property (weak, nonatomic) IBOutlet UILabel *middleTitleOne2;

@property (weak, nonatomic) IBOutlet UILabel *confirmarSolcitud;

@property (weak, nonatomic) IBOutlet UIButton *buttonAgendamientos;
@property (weak, nonatomic) IBOutlet UIButton *buttonNewAgendamiento;





@property (nonatomic, assign) id <AgendaVWCDelegate>            delegate;

@property (nonatomic, strong) IBOutlet UIScrollView             *scrvwAgendar;
@property (nonatomic, strong) IBOutlet UIView                   *vwDatePicker;
@property (nonatomic, strong) IBOutlet UIDatePicker             *datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView             *pickerVW;
@property (nonatomic, strong) NSMutableArray                    *maPickerVW;

@property (nonatomic, strong) IBOutlet UIButton                 *btnAirport;
@property (nonatomic, strong) IBOutlet UIButton                 *btnOutside;
@property (nonatomic, strong) IBOutlet UIButton                 *btnPerHour;
@property (nonatomic, strong) IBOutlet UIButton                 *btnMessaging;

@property (nonatomic, assign) AgendType                         currentAgendType;

@property (nonatomic, strong) IBOutlet UILabel                  *lbDate;

@property (nonatomic, strong) IBOutlet UILabel                  *lbAddress1;
@property (nonatomic, strong) IBOutlet UITextField              *txtfAddress2;
@property (nonatomic, strong) IBOutlet UITextField              *txtfAddress3;
@property (nonatomic, strong) IBOutlet UITextField              *txtfAddress4;
@property (nonatomic, strong) IBOutlet UITextField              *txtfAddress5;
@property (nonatomic, strong) IBOutlet UITextField              *txtfAddress6;

@property (nonatomic, strong) IBOutlet UITextField              *txtfDestination;

@property (nonatomic, strong) IBOutlet UIView                   *vwMiddle;
@property (nonatomic, strong) IBOutlet UIView                   *vwBottom;

@property (nonatomic, strong) IBOutlet UIView                   *vwLoading;

@property (nonatomic, strong) TYSUsser                          *tysUsser;

@property (nonatomic, strong) MyAgendVWC                        *myAgendVWC;

@property (nonatomic, assign) CurrentViewType                   currentViewType;

@property (nonatomic, strong) QualityService                    *qualityService;
@property (nonatomic, strong) NSString                          *currentAgendIdFinished;

@property (nonatomic, strong) NSString                          *dateForServer;

@property (nonatomic, strong) Register                          *registerVWC;

@property (nonatomic, strong) CLLocationManager                 *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;

@property (nonatomic, strong) NSString                  *latitudeAddress;
@property (nonatomic, strong) NSString                  *longitudeAddress;
@property (nonatomic, strong) NSString                  *fullAddress;


- (void)show:(BOOL)show;
- (IBAction)goBack:(id)sender;
- (IBAction)onDate:(id)sender;
- (IBAction)onMyAgend:(id)sender;
- (IBAction)onMakeAgend:(id)sender;
- (IBAction)onDatePickerBack:(id)sender;
- (IBAction)onDateChanged:(id)sender;
//- (IBAction)onPickerAddress1:(id)sender;
- (IBAction)selectAddress:(id)sender;

- (IBAction)onAirport:(id)sender;
- (IBAction)onOutside:(id)sender;
- (IBAction)onPerHour:(id)sender;
- (IBAction)onMessaging:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSetAddress;
- (IBAction)setAddress:(id)sender;

- (IBAction)onCloseKeyBoard:(id)sender;


@end

@protocol AgendaVWCDelegate <NSObject>

- (void)AgendaVWCNeedRemove;

@end
