//
//  NetworkStatusViewController.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 8/30/16.
//  Copyright © 2016 imaginamos. All rights reserved.
//

#import "NetworkStatusViewController.h"

@interface NetworkStatusViewController ()

@end

@implementation NetworkStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.viewNetwork = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    self.viewNetwork.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:67.0/255 blue:63.0/255 alpha:0.9f];
    //self.viewNetwork.alpha = 0.65;
    
    self.imageNetworkStatus = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, screenHeight/2-50,100, 100)];
    self.imageNetworkStatus.image = [UIImage imageNamed:@"without_network"];
    
    
    self.imageRingStatus = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-50, screenHeight/2-50,100, 100)];
    self.imageRingStatus.image = [UIImage imageNamed:@"without_network_status"];
    
    
    //
    self.networkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageNetworkStatus.frame.origin.y + 110, screenWidth, 18)];
    [self.networkLabel setTextColor:[UIColor whiteColor]];
    [self.networkLabel setText:NSLocalizedString(@"connection_bad",nil)];
    [self.networkLabel setFont:[self.networkLabel.font fontWithSize:18]];
    self.networkLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    [self.viewNetwork addSubview:self.imageNetworkStatus];
    [self.viewNetwork addSubview:self.imageRingStatus];
    [self.viewNetwork addSubview:self.networkLabel];
    
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:0
                     animations:^{
                         [UIView setAnimationRepeatCount:HUGE_VALF];
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         self.imageRingStatus.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    [self.view addSubview:self.viewNetwork];
    

    
}

@end
