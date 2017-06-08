//
//  HistoryReclamo.m
//  taxisya
//
//  Created by Guillermo Blanco on 29/07/14.
//  Copyright (c) 2014 imaginamos. All rights reserved.
//

#import "HistoryReclamo.h"
#import "HTTPSyncRequest.h"
#import "TYUsserProfile.h"

@interface HistoryReclamo ()

@end

@implementation HistoryReclamo

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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIImageView *imageHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    [imageHeader setFrame:CGRectMake(0, 0, 320, 47)];
    [self.view addSubview:imageHeader];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, -1, 38, 48)];
    [button setImage:[UIImage imageNamed:@"btn_back_n"] forState:UIControlStateNormal];
    [button addTarget:self.delegate action:@selector(finishReclamo) forControlEvents:UIControlEventTouchUpInside];

    self.reclamoText = [[UITextField alloc] initWithFrame:CGRectMake(20, 67, 280, 61)];
    [self.reclamoText setPlaceholder:NSLocalizedString(@"send_claim",nil)];
    [self.reclamoText setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [self.reclamoText setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.reclamoText];

    UIButton *sendReclamo = [[UIButton alloc] initWithFrame:CGRectMake(20, 134, 280, 25)];
    [sendReclamo setBackgroundColor:[UIColor colorWithRed:243/255.f green:84/255.f blue:38/255.f alpha:1]];
    [sendReclamo setTitle:NSLocalizedString(@"send_claim",nil) forState:UIControlStateNormal];
    [sendReclamo.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [sendReclamo addTarget:self action:@selector(sendReclamo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendReclamo];

    [self.view addSubview:button];
}

- (void)sendReclamo {
    [[[HTTPSyncRequest alloc] init] createReclamo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSString stringWithFormat:@"%@", self.reclamoText.text], @"descript",
                                                   [NSString stringWithFormat:@"%lld", self.serviceID], @"service_id",
                                                   [TYUsserProfile UsserInfoForKey:USSER_DEVICE_PUSH_TOKEN], @"uuid",
                                                   nil] delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didCompleteRequest:(int)request withError:(NSError *)error {
    [self.delegate finishReclamo];
}

- (void)didCompleteRequest:(int)request receiveData:(NSDictionary *)data {
    [self.delegate finishReclamo];
}

@end
