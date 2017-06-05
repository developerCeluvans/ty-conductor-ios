//
//  HistoryViewController.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "HistoryViewController.h"
#import "AFNetworking.h"
#import "ApiTaxisya.h"
#import "HistoryTableViewCell.h"
#import "History.h"


typedef void(^SuccessBlock)(id success);

@interface HistoryViewController () {
    UIControl   *backCover;
    BOOL        inhibitBackButtonBOOL;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
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
    
}

-(void)optionAction:(id)sender {

    NSLog(@"optionAction finish");
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    NSLog(@"HistoryViewController viewWillAppear");
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 34)];
    NSString *stringTitle = [NSString stringWithFormat:@"%@ %@",
                             NSLocalizedString(@"title_history_first",nil),
                             NSLocalizedString(@"title_history_last",nil)];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setText:stringTitle];
    [self.titleLabel setFont:[self.titleLabel.font fontWithSize:22]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc]
     initWithAttributedString: self.titleLabel.attributedText];
    
    // set color for last title
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]
            range:NSMakeRange([NSLocalizedString(@"title_history_first",nil) length] + 1, [NSLocalizedString(@"title_history_last",nil) length])];
    [self.titleLabel setAttributedText: text];
    [self.view addSubview:self.titleLabel];
    
    // subtitle
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 98, screenWidth, 18)];
    [self.subtitleLabel setTextColor:[UIColor grayColor]];
    [self.subtitleLabel setText:NSLocalizedString(@"subtitle_history",nil)];
    [self.subtitleLabel setFont:[self.subtitleLabel.font fontWithSize:16]];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subtitleLabel];
    
    // table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, screenWidth, screenHeight - 116)];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"CellHistory"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *driverId = [defaults objectForKey:@"driver_id"];
    NSString *uuid = [defaults objectForKey:@"uuid"];
    NSDictionary *params = @{@"driver_id":driverId, @"uuid":uuid};
    
    // get history
    ApiTaxisya *api = [ApiTaxisya sharedInstance];
    [api servicesHistory:params success:^(BOOL success, id result){
        if (success) {
            NSDictionary *dictionary = (NSDictionary *)result;
            //NSLog(@"servicesHistory response: %@",dictionary);
            [self parseHistory:dictionary];
        }
        else {
            NSLog(@"servicesHistory error: %@",result);
        }
    }];    
}

-(void)parseHistory:(NSDictionary *)dictionary {
    for (NSDictionary *d in dictionary[@"services"]) {
        
        History *history = [[History alloc]
                            initWithObject:[d[@"id"] integerValue] address:d[@"address"]
                            neighborhood:d[@"barrio"]
                            updateAt:d[@"updated_at"]
                            rate:(d[@"qualification"] != [NSNull null]) ? [d[@"qualification"] integerValue] : 0];
        [self.dataSource addObject:history];
        
    }
    NSArray *sortedArray = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(History *p1, History *p2){
//        return [p1.serviceId compare:p2.serviceId];
        
        return (p1.serviceId < p2.serviceId);
        
    }];
    self.dataSource = sortedArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
//    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CellHistory";
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    History *h = self.dataSource[indexPath.row];
    cell.serviceIdLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"cell_service",nil), h.serviceId];
    cell.addressLabel.text = h.address;
    cell.neighborhoodLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"cell_neighborhood",nil), h.neighborhood];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"cell_date",nil), h.updateAt];
    cell.rateLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"cell_rating",nil), [self rateToDescription:h.rate]];
    
    return cell;
}

-(NSString *)rateToDescription:(int) rate {
    NSString *result;
        
    switch (rate) {
        case 1:
            result = NSLocalizedString(@"rate_very_good",nil);
            break;
            
        case 2:
            result = NSLocalizedString(@"rate_good",nil);
            break;
            
        case 3:
            result = NSLocalizedString(@"rate_bad",nil);
            break;

        default:
            result = NSLocalizedString(@"rate_none",nil);
            break;
            
    }
    return result;
}

@end
