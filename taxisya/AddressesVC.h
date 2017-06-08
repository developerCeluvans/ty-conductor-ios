//
//  AddressesVC.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/16/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSUsser.h"
#import "TYSTaxi.h"
#import "TYAddress.h"
#import "NewAddressVC.h"

@protocol AddressesVCDelegate;


@interface AddressesVC : UIViewController <UITableViewDataSource,UITableViewDelegate,TYSUsserDelegate,NewAddressVCDelegate>


@property (nonatomic, assign) id <AddressesVCDelegate>    delegate;

@property (nonatomic,strong) UITableView              *tableView;
@property (nonatomic,strong) NSMutableArray           *addressArray;
@property (nonatomic, strong)TYSUsser                 *tysUsser;
@property (nonatomic, strong) TYSTaxi                 *tysTaxi;

@property (weak, nonatomic) IBOutlet UILabel          *titleMyAddresses;
@property (weak, nonatomic) IBOutlet UIButton         *buttonAdd;
@property (nonatomic,strong) NewAddressVC             *newaddressVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)show;
- (IBAction)goBack:(id)sender;
- (IBAction)goAdd:(id)sender;

@end

@protocol AddressesVCDelegate <NSObject>

-(void)addressSelected:(TYAddress *) address;

@end


