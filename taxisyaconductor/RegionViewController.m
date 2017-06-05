//
//  RegionViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 11/27/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "RegionViewController.h"
#import "RegisterViewController.h"
#import "Country.h"
#import "Region.h"
#import "City.h"

@interface RegionViewController ()

@end

@implementation RegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"LoginViewController viewWillAppear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    NSLog(@"Region viewDidLoad w: %f h: %f",screenWidth, screenHeight);

    self.countryArray = [[NSMutableArray alloc] init];
    self.regionsArray = [[NSMutableArray alloc] init];
    self.citiesArray = [[NSMutableArray alloc] init];


    //
    Country *country1 = [[Country alloc] initWithObject:1 address:@"Colombia"];
    [self.countryArray addObject:country1];
    Country *country2 = [[Country alloc] initWithObject:2 address:@"Estados Unidos"];
    [self.countryArray addObject:country2];


    Region *region1 = [[Region alloc] initWithObject:1 country:1 name:@"Cundinamarca"];
    [self.regionsArray addObject:region1];
    Region *region2 = [[Region alloc] initWithObject:2 country:2 name:@"Florida"];
    [self.regionsArray addObject:region2];

    // Cities
    City *city1 = [[City alloc] initWithObject:1 region:1 city:1 name:@"Bogotá"];
    [self.citiesArray addObject:city1];
    City *city2 = [[City alloc] initWithObject:2 region:2 city:2 name:@"Bogotá"];
    [self.citiesArray addObject:city2];



    // UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.scrollView setDelegate:self];
    self.scrollView.showsVerticalScrollIndicator=YES;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    [self.scrollView setContentSize:CGSizeMake(screenWidth, 420)];
    [self.view addSubview:self.scrollView];


    // picker 1
//    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, screenWidth - 20, 20)];
    UILabel *countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenWidth - 20, 20)];
    [countryLabel setText:NSLocalizedString(@"title_country",nil)];
    countryLabel.backgroundColor = [UIColor grayColor];
    countryLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:countryLabel];

//    UIPickerView *countryPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 84,screenWidth - 20, 120)];
    _countryPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 20,screenWidth - 20, 120)];

    [_countryPickedView setDataSource: self];
    [_countryPickedView setDelegate: self];
    _countryPickedView.showsSelectionIndicator = YES;
    [self.scrollView addSubview:_countryPickedView];



    NSLog(@"------------------------------------------------");
    NSLog(@"  picker w= %f, h= %f", _countryPickedView.frame.size.width, _countryPickedView.frame.size.height);


    // picker 2
//    UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 204, screenWidth - 20, 20)];
    UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, screenWidth - 20, 20)];
    [regionLabel setText:NSLocalizedString(@"title_region",nil)];
    regionLabel.backgroundColor = [UIColor grayColor];
    regionLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:regionLabel];

//    UIPickerView *regionPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 224,screenWidth - 20, 120)];
    _regionPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 160,screenWidth - 20, 120)];
    [_regionPickedView setDataSource: self];
    [_regionPickedView setDelegate: self];
    _regionPickedView.showsSelectionIndicator = YES;
    [self.scrollView addSubview:_regionPickedView];



    // picker 3
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, screenWidth - 20, 20)];
    [cityLabel setText:NSLocalizedString(@"title_city",nil)];
    cityLabel.backgroundColor = [UIColor grayColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:cityLabel];

    _cityPickedView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 300,screenWidth - 20, 120)];
    [_cityPickedView setDataSource: self];
    [_cityPickedView setDelegate: self];
    _cityPickedView.showsSelectionIndicator = YES;
    [self.scrollView addSubview:_cityPickedView];




}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Region viewWillAppear");

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"Region viewWillDisappear");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveRegion {
    NSLog(@"Region saveRegion");

    // save preferences

    // call register form

    //
    RegisterViewController *regVC = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];

    [self.navigationController pushViewController:regVC animated:YES];

}

#pragma marks - UIPickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //NSLog(@"numberOfRowsInComponent: %d", [self.dateForChoose count]);
    if (pickerView == _countryPickedView)
        return [self.countryArray count];
    else if (pickerView == _regionPickedView)
        return [self.regionsArray count];
    else
        return [self.citiesArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //NSLog(@"titleForRow %@", [self.dateForChoose objectAtIndex: row]);
    //return [[self.countryArray objectAtIndex: row] name];

    if (pickerView == _countryPickedView) {
        return [[self.countryArray objectAtIndex: row] name];
    }
    else if (pickerView == _regionPickedView) {
        return [[self.regionsArray objectAtIndex: row] name];
    }
    else {
        return [[self.citiesArray objectAtIndex: row] name];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this [%2ld, %2ld]: %@", (unsigned long)row, (unsigned long)component, [self.countryArray objectAtIndex: row]);
    //self.plateIndex = row;

    NSLog(@"count - %ld", (unsigned long)[self.countryArray count]);

    if (pickerView == _countryPickedView) {
        NSLog(@"You selected this [%2ld, %2ld]: %@", (unsigned long)row, (unsigned long)component, [self.countryArray objectAtIndex: row]);
    }
    else if (pickerView == _regionPickedView) {
        NSLog(@"You selected this [%2ld, %2ld]: %@", (unsigned long)row,(unsigned long) component, [self.regionsArray objectAtIndex: row]);
    }
    else {
        NSLog(@"You selected this [%2ld, %2ld]: %@", (unsigned long)row, (unsigned long)component, [self.citiesArray objectAtIndex: row]);
    }

}



@end
