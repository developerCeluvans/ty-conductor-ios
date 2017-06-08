//
//  PaymentVC.h
//  taxisya
//
//  Created by Leonardo Rodriguez on 11/5/16.
//  Copyright © 2016 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentVCDelegate;

@interface PaymentVC : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, assign) id <PaymentVCDelegate>    delegate;

@property (weak, nonatomic) IBOutlet UILabel          *titleMyAddresses;
@property (weak, nonatomic) IBOutlet UIButton         *buttonAdd;

@property (strong, nonatomic) NSString *cardReference;
@property (strong, nonatomic) UITableView *tableView;


@end

@protocol PaymentVCDelegate <NSObject>

-(void)cardSelected:(NSString *) cardReference;

@end
