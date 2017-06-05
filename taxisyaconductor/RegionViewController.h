//
//  RegionViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegionViewController : BaseViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *countryArray;
@property (nonatomic, strong) NSMutableArray *regionsArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;

@property (nonatomic, strong) UIPickerView *countryPickedView;;
@property (nonatomic, strong) UIPickerView *regionPickedView;;
@property (nonatomic, strong) UIPickerView *cityPickedView;


@end
