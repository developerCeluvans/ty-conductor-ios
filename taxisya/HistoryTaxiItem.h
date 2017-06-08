//
//  HistoryTaxiItem.h
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryTaxItemDelegate <NSObject>

- (void)showReclamo:(int64_t)serviceID;

@end

@interface HistoryTaxiItem : UIView


@property (nonatomic, assign) id <HistoryTaxItemDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView              *imgvwTaxista;
@property (nonatomic, strong) IBOutlet UILabel                  *lbName;
@property (nonatomic, strong) IBOutlet UILabel                  *lbPlaca;
@property (nonatomic, strong) IBOutlet UILabel                  *lbMarca;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView  *loading;
@property (nonatomic, strong) IBOutlet UIButton                 *btnPhone;
@property (nonatomic, strong) IBOutlet UILabel                  *lbNumber;
@property (nonatomic, strong) UIView *reclamoView;
@property (nonatomic) int64_t serviceID;
@property (weak, nonatomic) IBOutlet UIButton *btnReclamo;
@property (weak, nonatomic) IBOutlet UILabel *titleBtnReclamo;

- (void)setName:(NSString *)name placa:(NSString *)placa urlImage:(NSString *)urlImage phone:(NSString *)phone marca:(NSString *)marca service:(int64_t)serviceID;

- (IBAction)call:(id)sender;
- (IBAction)reclamo:(id)sender;

@end

