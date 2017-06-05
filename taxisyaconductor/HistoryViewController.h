//
//  HistoryViewController.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/4/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HistoryViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subtitleLabel;
@property (strong,nonatomic) UITableView *tableView;

@end
