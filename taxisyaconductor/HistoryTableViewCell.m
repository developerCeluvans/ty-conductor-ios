//
//  HistoryTableViewCell.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/7/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        // service id
        self.serviceIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        self.serviceIdLabel.textColor = [UIColor whiteColor];
        self.serviceIdLabel.backgroundColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.serviceIdLabel.font = [self.serviceIdLabel.font fontWithSize:14.0f];
        [self addSubview:self.serviceIdLabel];
        
        // address
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 20)];
        self.addressLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.addressLabel.font = [self.addressLabel.font fontWithSize:14.0f];
        [self addSubview:self.addressLabel];
        
        // neighborhood
        self.neighborhoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 20)];
        self.neighborhoodLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.neighborhoodLabel.font = [self.neighborhoodLabel.font fontWithSize:14.0f];
        [self addSubview:self.neighborhoodLabel];
        
        // date
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, screenWidth, 20)];
        self.dateLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.dateLabel.font = [self.dateLabel.font fontWithSize:14.0f];
        [self addSubview:self.dateLabel];

        // rate
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenWidth, 20)];
        self.rateLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.rateLabel.font = [self.dateLabel.font fontWithSize:14.0f];
        [self addSubview:self.rateLabel];
        
    }
    return self;
}

@end
