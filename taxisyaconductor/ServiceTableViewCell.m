//
//  ServiceTableViewCell.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 10/8/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        //CGFloat screenHeight = screenRect.size.height;


        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

            // address
            self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, screenWidth - 4, 30)];
            self.addressLabel.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1]; // #727272
            self.addressLabel.font = [self.addressLabel.font fontWithSize:24.0f];
            [self addSubview:self.addressLabel];
            
            // neighborhood
            self.neighborhoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 30, screenWidth, 20)];
            self.neighborhoodLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
            self.neighborhoodLabel.font = [self.neighborhoodLabel.font fontWithSize:20.0f];
            [self addSubview:self.neighborhoodLabel];
            
            // observation
            self.observationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 50, screenWidth, 20)];
            self.observationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.observationLabel.font = [self.observationLabel.font fontWithSize:16.0f];
            [self addSubview:self.observationLabel];
           
            
            
            // destination
            self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 70, screenWidth, 20)];
            self.destinationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.destinationLabel.font = [self.destinationLabel.font fontWithSize:16.0f];
            [self addSubview:self.destinationLabel];
            
            // user
            self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 90, screenWidth, 20)];
            self.userNameLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.userNameLabel.font = [self.userNameLabel.font fontWithSize:16.0f];
            [self addSubview:self.userNameLabel];
            
            // image
            self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 60, 30, 50, 50)];
            [self addSubview:self.iconImageView];

        }
        else {
            // address
            self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, screenWidth - 4, 39)];
            self.addressLabel.textColor = [UIColor blackColor]; // #727272
            //        self.addressLabel.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1]; // #727272
            
            self.addressLabel.font = [self.addressLabel.font fontWithSize:36.0f];
            [self addSubview:self.addressLabel];
            
            // neighborhood
            self.neighborhoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 39, screenWidth, 26)];
            self.neighborhoodLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
            self.neighborhoodLabel.font = [self.neighborhoodLabel.font fontWithSize:26.0f];
            [self addSubview:self.neighborhoodLabel];
            
            // observation
            self.observationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 65, screenWidth, 26)];
            self.observationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.observationLabel.font = [self.observationLabel.font fontWithSize:21.0f];
            [self addSubview:self.observationLabel];
            
            
            
            // destination
            self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 91, screenWidth, 26)];
            self.destinationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.destinationLabel.font = [self.destinationLabel.font fontWithSize:21.0f];
            [self addSubview:self.destinationLabel];
            
            // user
            self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 117, screenWidth, 26)];
            self.userNameLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
            self.userNameLabel.font = [self.userNameLabel.font fontWithSize:21.0f];
            [self addSubview:self.userNameLabel];
            
            // image
            self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 60, 39, 50, 50)];
            [self addSubview:self.iconImageView];
  
        }
/*
        // address
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, screenWidth - 4, 30)];
        self.addressLabel.textColor = [UIColor colorWithRed:0.447 green:0.447 blue:0.447 alpha:1]; // #727272
        self.addressLabel.font = [self.addressLabel.font fontWithSize:24.0f];
        [self addSubview:self.addressLabel];

        // neighborhood
        self.neighborhoodLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 30, screenWidth, 20)];
        self.neighborhoodLabel.textColor = [UIColor colorWithRed:0.992f green:0.243f blue:0.008f alpha:1.0f]; // #fd3e02
        self.neighborhoodLabel.font = [self.neighborhoodLabel.font fontWithSize:20.0f];
        [self addSubview:self.neighborhoodLabel];

        // destination
        self.destinationLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 50, screenWidth, 20)];
        self.destinationLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
        self.destinationLabel.font = [self.destinationLabel.font fontWithSize:16.0f];
        [self addSubview:self.destinationLabel];

        // user
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 70, screenWidth, 20)];
        self.userNameLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.408 alpha:1]; // #686868
        self.userNameLabel.font = [self.userNameLabel.font fontWithSize:16.0f];
        [self addSubview:self.userNameLabel];

        // image
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 60, 30, 50, 50)];
        [self addSubview:self.iconImageView];
*/




    }
    return self;
}


@end
