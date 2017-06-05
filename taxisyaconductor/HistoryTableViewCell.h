//
//  HistoryTableViewCell.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *serviceIdLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *neighborhoodLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *rateLabel;

@end
