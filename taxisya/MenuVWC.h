//
//  MenuVWC.h
//  taxisya
//
//  Created by NTTak3 on 21/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "QualityService.h"

typedef enum{
    MenuOptionService,
    MenuOptionHistory,
    MenuOptionAgend,
    MenuOptionPerfil,
} MenuOption;

@protocol MenuVWCDelegate;

@interface MenuVWC : UIViewController <iCarouselDataSource, iCarouselDelegate, QualityServiceDelegate>

@property (nonatomic, assign) id <MenuVWCDelegate>                  delegate;

@property (nonatomic, strong) IBOutlet UIImageView                  *imgTitle;
@property (nonatomic, strong) IBOutlet UIImageView                  *imgMask;
@property (nonatomic, strong) IBOutlet UIImageView                  *imgImaginamos;
@property (nonatomic, strong) IBOutlet UIImageView                  *imgMap;
@property (nonatomic, strong) iCarousel                             *options;
@property (nonatomic, strong) NSMutableArray                        *arrayButtons;

@property (nonatomic) BOOL repeatAnimations;
@property (nonatomic) BOOL callRequestServiceOption;

@end

@protocol MenuVWCDelegate <NSObject>

- (void)MenuVWCOptionPressed:(MenuOption)option;
-(void)callRequestServiceOption;

@end