//
//  AddressesVC.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 10/16/15.
//  Copyright © 2015 imaginamos. All rights reserved.
//

#import "AddressesVC.h"
#import "UIView+Xib.h"
#import "JSON.h"

@interface AddressesVC ()

@end

@implementation AddressesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 47, screenWidth, screenHeight - 47)];
    [self.view addSubview:self.tableView];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.buttonAdd setTitle:NSLocalizedString(@"addresses_add_new",nil) forState:UIControlStateNormal];
    self.titleMyAddresses.text = NSLocalizedString(@"addresses_title",nil);

    NSLog(@"AddressesVC viewDidLoad");
    [self show];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"AddressesVC viewWillAppeard");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) show {
    NSLog(@"AddressesVC show");
    [self show:YES];

    [self loadAddresses];

}

-(void) loadAddresses {
    self.addressArray = [[NSMutableArray alloc] init];
    if (!_tysUsser){
        self.tysUsser = [[TYSUsser alloc] initwithDelegate:self];
    }
    [_tysUsser requestUsserType:TYSUsserTypeOldAddress object:nil];
}

- (IBAction)goBack:(id)sender {
    NSLog(@"AddressesVC goBack");
    //[self show:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goAdd:(id)sender {

    
    NewAddressVC *newaddressVC = [[NewAddressVC alloc] initWithNibName:@"NewAddressVC" bundle:nil];
    newaddressVC.delegate = self;
    [self.navigationController pushViewController:newaddressVC animated:YES];
//    if (!self.newaddressVC) {
//
//        self.newaddressVC = [[NewAddressVC alloc] initWithNibName:@"NewAddressVC" bundle:nil];
//        self.newaddressVC.delegate = self;
//
//        [self.view addSubview:_newaddressVC.view];
//    }
//    [_newaddressVC show];
    
}

-(void) show:(BOOL)show {
    if (show)
        self.view.alpha = 1;
    else
        self.view.alpha = 0;
}

-(void) hide {
    NSLog(@"AddressesVC hide");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"myCell"];
    }

    TYAddress *addr = self.addressArray[indexPath.row];


    if ([addr.addressFull isEqual:[NSNull null]]) {
        NSString *full = [NSString stringWithFormat:@"%@ %@ #%@-%@",addr.address1,addr.address2,addr.address3,addr.address4];
        cell.textLabel.text = full;
    }
    else {
        cell.textLabel.text = addr.addressFull;
    }
    //cell.textLabel.text = addr.addressFull;
    cell.detailTextLabel.text = addr.addressName;
    cell.imageView.image = [UIImage imageNamed:@"cell_image_normal"];


    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath %li",(long)indexPath.row);
    NSLog(@"didSelectRowAtIndexPath %@", self.addressArray[indexPath.row]);
    
    //[self show:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate addressSelected:self.addressArray[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSLog(@"delete cell");

        TYAddress *addr = self.addressArray[indexPath.row];

        [self.addressArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        // delete address
        [self deleteAddress:addr.addressId];



    }
}

-(void)deleteAddress:(NSString *) id {

    if (!_tysTaxi) {
        self.tysTaxi = [[TYSTaxi alloc] initwithDelegate:self];
    }
    [_tysTaxi deleteAddress:id];

}


- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status{

    if(type == TYSUsserTypeOldAddress){

        if(status == ServiceStatusOk){

            //            NSLog(@"XXXXX :::::: %@", response);

            NSMutableDictionary *dic = [response JSONValue];

            if(dic && dic.count){

                //                NSLog([dic description]);

                NSString *error = [dic objectForKey:@"error"];

                if(error && [error isEqualToString:@"1"]){



                }else{

                    NSMutableDictionary *values = [dic objectForKey:@"address"];

                    if(values){
                        for (NSDictionary *dirs in values){

                            NSString *dirId =       [dirs objectForKey:@"id"];
                            NSString *dir1 =        [dirs objectForKey:@"index_id"];
                            NSString *dir2 =        [dirs objectForKey:@"comp1"];
                            NSString *dir3 =        [dirs objectForKey:@"comp2"];
                            NSString *dir4 =        [dirs objectForKey:@"no"];
                            NSString *dir5 =        [dirs objectForKey:@"obs"];
                            NSString *dir6 =        [dirs objectForKey:@"barrio"];

                            NSString *address = [dirs objectForKey:@"address"];
                            NSString *addressName = [dirs objectForKey:@"name"];
                            NSString *lat = [dirs objectForKey:@"lat"];
                            NSString *lng = [dirs objectForKey:@"lng"];

                            TYAddress *address1 = [[TYAddress alloc] init];
                            address1.addressId = dirId;
                            address1.address1 = dir1;
                            address1.address2 = dir2;
                            address1.address3 = dir3;
                            address1.address4 = dir4;
                            address1.address5 = dir5;
                            address1.address6 = dir6;
                            address1.addressFull = address;
                            address1.addressName = addressName;
                            address1.latitude = lat;
                            address1.longitude = lng;
                            //[array addObject:address1];
                            [self.addressArray addObject:address1];
                        }
                    }
                }
            }
            else{

                //No tiene direcciones

            }

        }else{
            //[self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:0];
        }
    }
    [self.tableView reloadData];

}

- (void)TYSTaxiType:(TYSTaxiType)type response:(NSString *)response status:(ServiceStatus)status{
    NSLog(@" RESPUESTA :: %@", response);
    if (type == TYSDeleteAddress) {
        if (status == DeleteAddressStatusOk) {
            NSMutableDictionary *values = [response JSONValue];
            if (values) {
                NSLog(@"    address deleted...");
            }
        }
    }
}


-(void)newAddressSaved {
    NSLog(@"newAddressSaved delegate");
    [self loadAddresses];
}

@end
