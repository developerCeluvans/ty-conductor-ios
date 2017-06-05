//
//  RegisterViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/21/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+MD5Addition.h"
#import "LoginViewController.h"
#import "ApiTaxisya.h"
#import "UIView+Toast.h"
#import "Country.h"
#import "Region.h"
#import "City.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface RegisterViewController ()  {
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewDidLoad RegisterViewController");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"viewDidLoad w=%f h=%f", screenWidth, screenHeight);

    self.isCitySelected = NO;

    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.scrollView setDelegate:self];
    self.scrollView.showsVerticalScrollIndicator=YES;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    [self.scrollView setContentSize:CGSizeMake(screenWidth, 1310)];
    [self.view addSubview:self.scrollView];

    self.arrayCountries = [[NSMutableArray alloc] init];
    self.arrayDepartments = [[NSMutableArray alloc] init];
    self.arrayCities = [[NSMutableArray alloc] init];

    // make title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, screenWidth, 34)];
    NSString *stringTitle = [NSString stringWithFormat:@"%@ %@",
                             NSLocalizedString(@"title_login_first",nil),
                             NSLocalizedString(@"title_login_last",nil)];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setText:stringTitle];
    [self.titleLabel setFont:[self.titleLabel.font fontWithSize:22]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: self.titleLabel.attributedText];
    // set color for last title
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]
                 range:NSMakeRange([NSLocalizedString(@"title_login_first",nil) length] + 1, [NSLocalizedString(@"title_login_last",nil) length])];
    [self.titleLabel setAttributedText: text];
    [self.scrollView addSubview:self.titleLabel];

    // country picker
    self.countryPickedView = [[UIPickerView alloc] init];
    self.countryPickedView.delegate = self;
    self.countryPickedView.dataSource = self;

    self.pickerCountries = self.arrayCountries;

    // country
    self.countryTextField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 52, 280, 38)];
    self.countryTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.countryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.countryTextField setPlaceholder:NSLocalizedString(@"hint_country",nil)];
    self.countryTextField.delegate = self;
    self.countryTextField.inputView = self.countryPickedView;
    self.countryTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    self.countryTextField.isOptionalDropDown = NO;
    //    [self.countryTextField setItemList:[NSArray arrayWithObjects:@"Colombia",@"Estados Unidos",@"Tokyo",@"Sydney", nil]];

    [self.scrollView addSubview:self.countryTextField];

    // region picker
    self.regionPickedView = [[UIPickerView alloc] init];
    self.regionPickedView.delegate = self;     //#2
    self.regionPickedView.dataSource = self;   //#2

    self.pickerRegions = @[ @"Other"];
    // region
    self.regionTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 98, 280, 38)];
    self.regionTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.regionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.regionTextField setPlaceholder:NSLocalizedString(@"hint_region",nil)];
    self.regionTextField.delegate = self;
    self.regionTextField.inputView = self.regionPickedView;

    self.regionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.regionTextField];

    // city
    self.cityPickedView = [[UIPickerView alloc] init];
    self.cityPickedView.delegate = self;
    self.cityPickedView.dataSource = self;

    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 144, 280, 38)];
    self.cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.cityTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.cityTextField setPlaceholder:NSLocalizedString(@"hint_city",nil)];
    self.cityTextField.delegate = self;
    self.cityTextField.inputView = self.cityPickedView;
    self.cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.cityTextField];

    // naem
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 190, 280, 38)];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.nameTextField setPlaceholder:NSLocalizedString(@"hint_name",nil)];
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.nameTextField];

    // identity
    self.identityTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 236, 280, 38)];
    self.identityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.identityTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.identityTextField setPlaceholder:NSLocalizedString(@"hint_identity",nil)];
    self.identityTextField.delegate = self;
    self.identityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.identityTextField];

    // license
    self.licenseTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 282, 280, 38)];
    self.licenseTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.licenseTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.licenseTextField setPlaceholder:NSLocalizedString(@"hint_license",nil)];
    self.licenseTextField.delegate = self;
    self.licenseTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.licenseTextField];

    // phone
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 328, 280, 38)];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.phoneTextField setPlaceholder:NSLocalizedString(@"hint_phone",nil)];
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.phoneTextField];

    // cellphone
    self.cellphoneTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 374, 280, 38)];
    self.cellphoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.cellphoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.cellphoneTextField setPlaceholder:NSLocalizedString(@"hint_cellphone",nil)];
    self.cellphoneTextField.delegate = self;
    self.cellphoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.cellphoneTextField];

    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 420, 280, 38)];
    self.loginTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.loginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.loginTextField setPlaceholder:NSLocalizedString(@"hint_email",nil)];
    self.loginTextField.delegate = self;
    self.loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.loginTextField];

    // address
    self.addressTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 466, 280, 38)];
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.addressTextField setPlaceholder:NSLocalizedString(@"hint_address",nil)];
    self.addressTextField.delegate = self;
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.addressTextField];

    // input password
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 512, 280, 38)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"hint_password",nil)];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.passwordTextField];

    // car plate
    self.carPlateTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 558, 280, 38)];
    self.carPlateTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carPlateTextField setPlaceholder:NSLocalizedString(@"hint_car_plate",nil)];
    self.carPlateTextField.delegate = self;
    self.carPlateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carPlateTextField];

    // car brand
    self.carBrandTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 604, 280, 38)];
    self.carBrandTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carBrandTextField setPlaceholder:NSLocalizedString(@"hint_car_brand",nil)];
    self.carBrandTextField.delegate = self;
    self.carBrandTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carBrandTextField];

    // car line
    self.carLineTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 650, 280, 38)];
    self.carLineTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carLineTextField setPlaceholder:NSLocalizedString(@"hint_car_line",nil)];
    self.carLineTextField.delegate = self;
    self.carLineTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carLineTextField];

    // car mobile
    self.carMobileTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 696, 280, 38)];
    self.carMobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carMobileTextField setPlaceholder:NSLocalizedString(@"hint_car_mobile",nil)];
    self.carMobileTextField.delegate = self;
    self.carMobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carMobileTextField];

    // car year
    self.carYearTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 742, 280, 38)];
    self.carYearTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carYearTextField setPlaceholder:NSLocalizedString(@"hint_car_year",nil)];
    self.carYearTextField.delegate = self;
    self.carYearTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carYearTextField];

    // car company
    self.carCompanyTextField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 788, 280, 38)];
    self.carCompanyTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.carCompanyTextField setPlaceholder:NSLocalizedString(@"hint_car_company",nil)];
    self.carCompanyTextField.delegate = self;
    self.carCompanyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:self.carCompanyTextField];

    // title photo  (center)
    self.titlePhoto = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-50, 834, 100, 30)];
    [self.titlePhoto setTextColor:[UIColor grayColor]];
    self.titlePhoto.text = NSLocalizedString(@"title_photo",nil);
    self.titlePhoto.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titlePhoto];

    // photo (center)
    self.photoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoImageView.frame = CGRectMake((screenWidth/2)-50, 864, 100, 100);
    [self.photoImageView setBackgroundColor:[UIColor grayColor]];
    self.photoImageView.adjustsImageWhenHighlighted = NO;
    [self.photoImageView addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.photoImageView];

    // (1) Identity
    self.titleDocument = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-120, 974, 100, 30)];
    [self.titleDocument setTextColor:[UIColor grayColor]];
    self.titleDocument.text = NSLocalizedString(@"title_document",nil);
    self.titleDocument.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titleDocument];

    self.documentImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.documentImageView.frame = CGRectMake((screenWidth/2)-120, 1004, 100, 100);
    [self.documentImageView setBackgroundColor:[UIColor grayColor]];
    self.documentImageView.adjustsImageWhenHighlighted = NO;
    [self.documentImageView addTarget:self action:@selector(takeDocument) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.documentImageView];

    // (2) License
    self.titleLicense = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)+20, 974, 100, 30)];
    [self.titleLicense setTextColor:[UIColor grayColor]];
    self.titleLicense.text = NSLocalizedString(@"title_car_license",nil);
    self.titleLicense.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titleLicense];

    self.licenseImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.licenseImageView.frame = CGRectMake((screenWidth/2)+20, 1004, 100, 100);
    [self.licenseImageView setBackgroundColor:[UIColor grayColor]];
    self.licenseImageView.adjustsImageWhenHighlighted = NO;
    [self.licenseImageView addTarget:self action:@selector(takeLicense) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.licenseImageView];

    // (3) Property
    self.titlePlate = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)-120, 1114, 100, 30)];
    [self.titlePlate setTextColor:[UIColor grayColor]];
    self.titlePlate.text = NSLocalizedString(@"title_car_plate",nil);
    self.titlePlate.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titlePlate];

    self.plateImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plateImageView.frame = CGRectMake((screenWidth/2)-120, 1144, 100, 100);
    [self.plateImageView setBackgroundColor:[UIColor grayColor]];
    self.plateImageView.adjustsImageWhenHighlighted = NO;
    [self.plateImageView addTarget:self action:@selector(takePlate) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.plateImageView];

    // (4) Operation
    self.titleOperation = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/2)+20, 1114, 100, 30)];
    [self.titleOperation setTextColor:[UIColor grayColor]];
    self.titleOperation.text = NSLocalizedString(@"title_operation",nil);
    self.titleOperation.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.titleOperation];

    self.operationImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operationImageView.frame = CGRectMake((screenWidth/2)+20, 1144, 100, 100);
    [self.operationImageView setBackgroundColor:[UIColor grayColor]];
    self.operationImageView.adjustsImageWhenHighlighted = NO;
    [self.operationImageView addTarget:self action:@selector(takeOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.operationImageView];

    // sendButton
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/2)-140, 1254, 280, 50)];
    [self.sendButton setTitle:NSLocalizedString(@"send_button",nil) forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]];
    [self.sendButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.sendButton];

    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];

    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;

    [self.scrollView addGestureRecognizer:tapGesture];


    //  call services
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api countries:nil success:^(BOOL success, id result){
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"countries response: %@",dictionary);
            [self parseCountries:dictionary];
        }
        else {
            NSLog(@"countries error: %@",result);
        }
    }];

    [api departments:nil success:^(BOOL success, id result){
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"departments response: %@",dictionary);
            [self parseDepartments:dictionary];
        }
        else {
            NSLog(@"departments error: %@",result);
        }
    }];

    [api cities:nil success:^(BOOL success, id result){
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            NSLog(@"cities response: %@",dictionary);
            [self parseCities:dictionary];
        }
        else {
            NSLog(@"cities error: %@",result);
        }
    }];


}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Cover the back button (cannot do this in viewWillAppear -- too soon)
    if ( backCover == nil ) {
        backCover = [[UIControl alloc] initWithFrame:CGRectMake( 0, 0, 80, 44)];
#if TARGET_IPHONE_SIMULATOR
        // show the cover for testing
        //backCover.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.15];
#endif
        [backCover addTarget:self action:@selector(optionAction:) forControlEvents:UIControlEventTouchDown];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar addSubview:backCover];
    }

    [self readTemporalRegistry];

}

-(void) readTemporalRegistry {

    NSLog(@"readTemporalRegistry +");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *regName        = [defaults objectForKey:@"register_name"];
    NSString *regIdentity    = [defaults objectForKey:@"register_identity"];
    NSString *regEmail       = [defaults objectForKey:@"register_email"];
    NSString *regLicense     = [defaults objectForKey:@"register_license"];
    NSString *regPhone       = [defaults objectForKey:@"register_phone"];
    NSString *regCellphone   = [defaults objectForKey:@"register_cellphone"];
    NSString *regAddress     = [defaults objectForKey:@"register_address"];
    NSString *regPassword    = [defaults objectForKey:@"register_password"];
    NSString *regCarPlate    = [defaults objectForKey:@"register_car_plate"];
    NSString *regCarBrand    = [defaults objectForKey:@"register_car_brand"];
    NSString *regCarLine     = [defaults objectForKey:@"register_car_line"];
    NSString *regCarMobileId = [defaults objectForKey:@"register_car_mobile_id"];
    NSString *regCarYear     = [defaults objectForKey:@"register_car_year"];
    NSString *regCarCompany  = [defaults objectForKey:@"register_car_company"];

    NSString *regPhoto  = [defaults objectForKey:@"register_photo"];
    NSString *regDoc1   = [defaults objectForKey:@"register_doc1"];
    NSString *regDoc2   = [defaults objectForKey:@"register_doc2"];
    NSString *regDoc3   = [defaults objectForKey:@"register_doc3"];
    NSString *regDoc4   = [defaults objectForKey:@"register_doc4"];

    if (regName != nil)        self.nameTextField.text       = regName;
    if (regIdentity != nil)    self.identityTextField.text   = regIdentity;
    if (regEmail != nil)       self.loginTextField.text      = regEmail;
    if (regPhone != nil)       self.phoneTextField.text      = regPhone;
    if (regLicense != nil)     self.licenseTextField.text    = regLicense;
    if (regCellphone != nil)   self.cellphoneTextField.text  = regCellphone;
    if (regAddress != nil)     self.addressTextField.text    = regAddress;
    if (regPassword != nil)    self.passwordTextField.text   = regPassword;
    if (regCarPlate != nil)    self.carPlateTextField.text   = regCarPlate;
    if (regCarBrand != nil)    self.carBrandTextField.text   = regCarBrand;
    if (regCarLine != nil)     self.carLineTextField.text    = regCarLine;
    if (regCarMobileId != nil) self.carMobileTextField.text  = regCarMobileId;
    if (regCarYear != nil)     self.carYearTextField.text    = regCarYear;
    if (regCarCompany != nil)  self.carCompanyTextField.text = regCarCompany;

    if (regPhoto != nil)
        [self.photoImageView setImage: [self decodeBase64ToImage:regPhoto] forState:UIControlStateNormal];
    if (regDoc1 != nil)
        [self.documentImageView setImage: [self decodeBase64ToImage:regDoc1] forState:UIControlStateNormal];
    if (regDoc2 != nil)
        [self.licenseImageView setImage: [self decodeBase64ToImage:regDoc2] forState:UIControlStateNormal];
    if (regDoc3 != nil)
        [self.plateImageView setImage: [self decodeBase64ToImage:regDoc3] forState:UIControlStateNormal];
    if (regDoc4 != nil)
        [self.operationImageView setImage: [self decodeBase64ToImage:regDoc4] forState:UIControlStateNormal];

    NSLog(@"readTemporalRegistry -");
}

-(void)optionAction:(id)sender {

    NSLog(@"optionAction finish");
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear RegisterViewController");

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear RegisterViewController");

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSLog(@"viewDidLoad w=%f h=%f", screenWidth, screenHeight);

    self.pickerCountries = self.arrayCountries;
    [self filterDepartments];
    [self filterCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parseCountries:(NSDictionary *)dictionary {
    for (NSDictionary *d in dictionary[@"countries"]) {

        Country *country = [[Country alloc] initWithObject:[d[@"id"] integerValue]  address:d[@"name"]];

        [self.arrayCountries addObject:country];

    }
//    NSArray *sortedArray = [self.arrayCountries sortedArrayUsingComparator:^NSComparisonResult(Country *p1, Country *p2){
//        return (p1.countryId < p2.countryId);
//
//    }];
//    self.arrayCountries = sortedArray;

    self.pickerCountries = self.arrayCountries;

    NSLog(@"Paises: %@",self.pickerCountries);

    if ([self.pickerCountries count] >= 1) {
        self.countryId = [self.pickerCountries[0] countryId];
    }

}

-(void)parseDepartments:(NSDictionary *)dictionary {
    for (NSDictionary *d in dictionary[@"departments"]) {
        Region *region = [[Region alloc] initWithObject:[d[@"id"] integerValue] country:[d[@"country_id"] integerValue] name:d[@"name"]];

        [self.arrayDepartments addObject:region];
    }
}

-(void)parseCities:(NSDictionary *)dictionary {
    for (NSDictionary *d in dictionary[@"cities"]) {
        City *city = [[City alloc] initWithObject:[d[@"country_id"] integerValue] region:[d[@"department_id"] integerValue] city:[d[@"id"] integerValue] name:d[@"name"]];

        [self.arrayCities addObject:city];
    }
}

-(void) filterDepartments {
    NSLog(@"filterDepartments");
    self.pickerRegions = [[NSMutableArray alloc] init];
    for (Region *region in self.arrayDepartments) {
        if (region.countryId == self.countryId) {
            NSLog(@"[department] %@",region);
            [self.pickerRegions addObject:region];
        }
    }

}

-(void) filterCities {
    NSLog(@"filterCities");
    self.pickerCities = [[NSMutableArray alloc] init];
    for (City *city in self.arrayCities) {
        if ((city.countryId == self.countryId) && (city.regionId == self.regionId)) {
            NSLog(@"[city] %@",city);
            [self.pickerCities addObject:city];
        }
    }
}


#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.countryPickedView) {
        return 1;
    }
    else if (pickerView == self.regionPickedView) {
        return 1;
    }
    else { // city
        return 1;
    }

    return 0;
}

// #4
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.countryPickedView) {
        return [self.pickerCountries count];
    }
    else if (pickerView == self.regionPickedView) {
        return [self.pickerRegions count];
    }
    else { // city
        return [self.pickerCities count];
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

// #5
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.countryPickedView) {
        return [self.pickerCountries[row] name];
    }
    else if (pickerView == self.regionPickedView) {
        return [self.pickerRegions[row] name];
    }
    else {
        return [self.pickerCities[row] name];
    }
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (pickerView == self.countryPickedView) {
        self.countryTextField.text = [self.pickerCountries[row] name];
        self.countryId = [self.pickerCountries[row] countryId];
        [self filterDepartments];
        [self.countryTextField resignFirstResponder];
    }
    else if (pickerView == self.regionPickedView) {
        self.regionTextField.text = [self.pickerRegions[row] name];
        self.regionId = [self.pickerRegions[row] regionId];
        [self filterCities];
        [self.regionTextField resignFirstResponder];
    }
    else {
        self.cityTextField.text = [self.pickerCities[row] name];
        self.cityId = [self.pickerCities[row] cityId];
        [self.cityTextField resignFirstResponder];
        self.isCitySelected = YES;
    }
}

-(void)takePicture {
    NSLog(@"takePicture");

    // Crear uipicker
    self.pickerPhoto = [UIImagePickerController new];

    // configurar
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerPhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        self.pickerPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.pickerPhoto.delegate = self;

    // mostrar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register_photo"];
    [defaults synchronize];

    [self presentViewController:self.pickerPhoto animated:YES completion:nil];

}

-(void)takeDocument {
    NSLog(@"takeDocument");

    // Crear uipicker
    UIImagePickerController *picker = [UIImagePickerController new];

    // configurar
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.delegate = self;
    // mostrar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register_doc1"];
    [defaults synchronize];

    [self presentViewController:picker animated:YES completion:nil];

}

-(void)takeLicense {
    NSLog(@"takeLicense");

    self.pickerLicense = [UIImagePickerController new];

    // configurar
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerLicense.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        self.pickerLicense.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.pickerLicense.delegate = self;

    // mostrar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register_doc2"];
    [defaults synchronize];
    [self presentViewController:self.pickerLicense animated:YES completion:nil];

}

-(void)takePlate {
    NSLog(@"takePlate");
    self.pickerPlate = [UIImagePickerController new];

    // configurar
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerPlate.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        self.pickerPlate.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.pickerPlate.delegate = self;

    // mostrar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register_doc3"];
    [defaults synchronize];
    [self presentViewController:self.pickerPlate animated:YES completion:nil];


}


-(void)takeOperation {
    NSLog(@"takeOperation");
    self.pickerOperation = [UIImagePickerController new];

    // configurar
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerOperation.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        self.pickerOperation.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.pickerOperation.delegate = self;

    // mostrar
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"register_doc4"];
    [defaults synchronize];

    [self presentViewController:self.pickerOperation animated:YES completion:nil];

}


- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 3000; // Or whatever

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

-(void)registerAction:(id) sender {
    NSLog(@"registerAction ");

    [self initProgressbar];


    NSString *strPhotoJPEG = [UIImageJPEGRepresentation(self.photoImageView.imageView.image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *strDocumentJPEG = [UIImageJPEGRepresentation(self.documentImageView.imageView.image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *strLicenseJPEG = [UIImageJPEGRepresentation(self.licenseImageView.imageView.image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *strPlateJPEG = [UIImageJPEGRepresentation(self.plateImageView.imageView.image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *strOperationJPEG = [UIImageJPEGRepresentation(self.operationImageView.imageView.image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    if ([self validateFields]) {

        if (self.isCitySelected) {
            if ([strPhotoJPEG length] &&
                [strDocumentJPEG length] &&
                [strLicenseJPEG length] &&
                [strPlateJPEG length] &&
                [strOperationJPEG length]) {
                NSLog(@"puede continuar");

                NSString *name = self.nameTextField.text;
                NSString *identity = self.identityTextField.text;
                NSString *phone = self.phoneTextField.text;
                NSString *cellphone = self.cellphoneTextField.text;
                NSString *login = self.loginTextField.text;
                NSString *password = self.passwordTextField.text;
                //NSString *passwordSecure = [password MD5String];

                NSString *address = self.addressTextField.text;
                NSString *carPlate = self.carPlateTextField.text;
                NSString *carBrand = self.carBrandTextField.text;
                NSString *carLine = self.carLineTextField.text;
                NSString *carMobile = self.carMobileTextField.text;
                NSString *carYear = self.carYearTextField.text;
                NSString *carCompany = self.carCompanyTextField.text;
                NSString *license = self.licenseTextField.text;

                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *uuid = [defaults objectForKey:@"uuid"];
                if (uuid == nil) {
                    uuid = @"4e7b54db144ef812428c4111c5f6c7bcedbbea75875f690dc900c1d49cb36a57";
                }
                // prepare parameters
                NSDictionary *params = @{@"name": name,
                             @"login": login,
                             @"pwd": password,
                             @"cedula": identity,
                             @"license": license,
                             @"dir": address,
                             @"cellphone": cellphone,
                             @"telephone": phone,
                             @"car_tag": carPlate,
                             @"car_brand": carBrand,
                             @"car_line": carLine,
                             @"car_movil": carMobile,
                             @"car_year": carYear,
                             @"car_company": carCompany,
                             @"movil": carMobile,
                             @"city_id": [NSString stringWithFormat:@"%ld",self.cityId],
                             @"lastname": @"last name",
                             @"image": strPhotoJPEG,
                             @"document": strDocumentJPEG,
                             @"document2": strLicenseJPEG,
                             @"document3": strPlateJPEG,
                             @"document4": strOperationJPEG
                         };

                NSLog(@"params %@", params);
                // test api call

                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //    hud.mode = MBProgressHUDModeAnnularDeterminate;
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = NSLocalizedString(@"register_message_progress",nil);

                ApiTaxisya *api = [ApiTaxisya sharedInstance];
                [api driverRegister:params success:^(BOOL success, id result) {
                    hud.progress = 1;
                    if (success) {
                        NSLog(@"driverRegister: %@",result);

                        NSDictionary *dictionary = (NSDictionary *)result;
                        long error = [[dictionary objectForKey:@"error"] integerValue];
                     NSLog(@"/////////////////////////////////////////////////////////////// %ld",error);

                        if (!error) {
                            // save data locally
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            //NSString *driverId = [defaults objectForKey:@"driver_id"];
                            [defaults setObject:name forKey:@"register_name"];
                            [defaults setObject:identity forKey:@"register_identity"];
                            [defaults setObject:login forKey:@"register_email"];
                            [defaults setObject:license forKey:@"register_license"];
                            [defaults setObject:phone forKey:@"register_phone"];
                            [defaults setObject:cellphone forKey:@"register_cellphone"];
                            [defaults setObject:address forKey:@"register_address"];
                            [defaults setObject:password forKey:@"register_password"];
                            [defaults setObject:carPlate forKey:@"register_car_plate"];
                            [defaults setObject:carBrand forKey:@"register_car_brand"];
                            [defaults setObject:carLine forKey:@"register_car_line"];
                            [defaults setObject:carMobile forKey:@"register_car_mobile_id"];
                            [defaults setObject:carYear forKey:@"register_car_year"];
                            [defaults setObject:carCompany forKey:@"register_car_company"];
                            [defaults setObject:strPhotoJPEG forKey:@"register_photo"];
                            [defaults setObject:strDocumentJPEG forKey:@"register_doc1"];
                            [defaults setObject:strLicenseJPEG forKey:@"register_doc2"];
                            [defaults setObject:strPlateJPEG forKey:@"register_doc3"];
                            [defaults setObject:strOperationJPEG forKey:@"register_doc4"];

                            [hud hide:YES];
                            [self clearFields];

                            [_delegate showToastWhenRegisterFinish:YES];
                        }
                        else {
                            if (error == 5) {
                                // Show toast
                                NSString *msg = [dictionary objectForKey:@"msg"];

                                NSLog(@"driverRegister: error ==== %ld", error);
                                NSLog(@"driverRegister: msg ==== %@", msg);

                                [self.view makeToast:msg];

                                [hud hide:YES];
                            }
                        }
                    }
                    else {
                        NSLog(@"driverRegister error: %@",result);
                        [hud hide:YES];
                    }
                }];
            }
        }
        else {
            NSLog(@"mostrar toast con error 1");
            [self.view makeToast:NSLocalizedString(@"register_city_field",nil)];
        }
    }
    else {
        NSLog(@"mostrar toast con error 2");
        [self.view makeToast:NSLocalizedString(@"register_all_fields",nil)];

    }
}

-(BOOL)validateFields {

    if (self.nameTextField.text != nil &&
        self.identityTextField.text != nil &&
        self.phoneTextField.text != nil &&
        self.cellphoneTextField.text != nil &&
        self.loginTextField.text != nil &&
        self.passwordTextField.text != nil &&
        self.addressTextField.text != nil &&
        self.carPlateTextField.text != nil &&
        self.carBrandTextField.text != nil &&
        self.carLineTextField.text != nil &&
        self.carMobileTextField.text != nil &&
        self.carYearTextField.text != nil &&
        self.carCompanyTextField.text != nil &&
        self.licenseTextField.text != nil) {
        return YES;
    }
    return NO;
}

-(NSString *)encodeToBase64String:(UIImage *)image {
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [UIImageJPEGRepresentation(image, 0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

// Decoding
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)hideKeyboard
{
    NSLog(@"hideKeyboard");
    [self.scrollView resignFirstResponder];
    [self.view endEditing:YES];
}

- (void) initProgressbar {


    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;


    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setFrame:CGRectMake(0, 0, screenWidth / 2, 10)];
    self.progressView.center = CGPointMake(screenWidth - 110, screenHeight - 25);
    self.progressView.progress = 0.0;
    [self.view addSubview:self.progressView];
   */

/*
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Enviando...";
        [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
            hud.progress = progress;
        } completionCallback:^{
            [hud hide:YES];
        }];
*/



}


-(void)clearFields {
    NSLog(@"optionAction finish");
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSLog(@"imagePickerController");

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (picker == self.pickerPhoto) {
        //image = [self scaleAndRotateImage:image];
        [self.photoImageView setImage:image forState:UIControlStateNormal];
    }
    else if (picker == self.pickerLicense) {
        //image = [self scaleAndRotateImage:image];
        [self.licenseImageView setImage:image forState:UIControlStateNormal];
    }
    else if (picker == self.pickerPlate) {
        //image = [self scaleAndRotateImage:image];
        [self.plateImageView setImage:image forState:UIControlStateNormal];
    }
    else if (picker == self.pickerOperation) {
        //image = [self scaleAndRotateImage:image];
        [self.operationImageView setImage:image forState:UIControlStateNormal];
    }
    else {
        //image = [self scaleAndRotateImage:image];
        [self.documentImageView setImage:image forState:UIControlStateNormal];
    }

    [self dismissViewControllerAnimated:YES completion:^{}];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");

    [self.scrollView endEditing:YES];
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma marks - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}



//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"textFieldShouldReturn");
//    return FALSE;
//}

@end
