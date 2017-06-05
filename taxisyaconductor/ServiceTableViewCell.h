//
//  ServiceTableViewCell.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *neighborhoodLabel;
@property (strong, nonatomic) UILabel *observationLabel;
@property (strong, nonatomic) UILabel *destinationLabel;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UIImageView *iconImageView;


@end
