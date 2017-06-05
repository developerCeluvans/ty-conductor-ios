//
//  RegisterViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/21/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "IQDropDownTextField.h"

@protocol RegisterViewControllerDelegate <NSObject>
@optional
-(void)showToastWhenRegisterFinish:(BOOL)end;

@end

@interface RegisterViewController : BaseViewController <UIImagePickerControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) id <RegisterViewControllerDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *identityTextField;
@property (strong, nonatomic) UITextField *licenseTextField;

@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *cellphoneTextField;
@property (strong, nonatomic) UITextField *loginTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *addressTextField;

@property (strong, nonatomic) UITextField *countryTextField;
@property (strong, nonatomic) UITextField *regionTextField;
@property (strong, nonatomic) UITextField *cityTextField;

@property (strong, nonatomic) UITextField *carPlateTextField;
@property (strong, nonatomic) UITextField *carBrandTextField;
@property (strong, nonatomic) UITextField *carLineTextField;
@property (strong, nonatomic) UITextField *carMobileTextField;
@property (strong, nonatomic) UITextField *carYearTextField;
@property (strong, nonatomic) UITextField *carCompanyTextField;

@property (strong, nonatomic) UILabel *titlePhoto;
@property (strong, nonatomic) UILabel *titleDocument;
@property (strong, nonatomic) UILabel *titleLicense;
@property (strong, nonatomic) UILabel *titlePlate;
@property (strong, nonatomic) UILabel *titleOperation;

@property (strong, nonatomic) UIButton *photoImageView;
@property (strong, nonatomic) UIButton *documentImageView;
@property (strong, nonatomic) UIButton *licenseImageView;
@property (strong, nonatomic) UIButton *plateImageView;
@property (strong, nonatomic) UIButton *operationImageView;

@property (strong, nonatomic) UIImageView *cameraImageView;
@property (strong, nonatomic) UIImagePickerController *pickerPhoto;
@property (strong, nonatomic) UIImagePickerController *pickerDocument;
@property (strong, nonatomic) UIImagePickerController *pickerLicense;
@property (strong, nonatomic) UIImagePickerController *pickerPlate;
@property (strong, nonatomic) UIImagePickerController *pickerOperation;


@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic, strong) UIPickerView *countryPickedView;;
@property (nonatomic, strong) UIPickerView *regionPickedView;;
@property (nonatomic, strong) UIPickerView *cityPickedView;

@property (nonatomic, strong) NSMutableArray *pickerCountries;
@property (nonatomic, strong) NSMutableArray *pickerRegions;
@property (nonatomic, strong) NSMutableArray *pickerCities;


@property (nonatomic, strong) NSMutableArray *arrayCountries;
@property (nonatomic, strong) NSMutableArray *arrayDepartments;
@property (nonatomic, strong) NSMutableArray *arrayCities;

@property (nonatomic) long countryId;
@property (nonatomic) long regionId;
@property (nonatomic) long cityId;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic) BOOL isCitySelected;

@end
