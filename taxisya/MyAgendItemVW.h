//
//  MyAgendItemVW.h
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAgend.h"

@protocol MyAgendItemVWDelegate;

@interface MyAgendItemVW : UIView <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleMyLocation;
@property (weak, nonatomic) IBOutlet UILabel *titleDestino;
@property (weak, nonatomic) IBOutlet UIButton *buttonTitleFinished;
@property (weak, nonatomic) IBOutlet UILabel *titleConfirmed;
@property (weak, nonatomic) IBOutlet UIButton *buttonTitleCancel;

@property (nonatomic, assign) id <MyAgendItemVWDelegate>                    delegate;

@property (nonatomic, strong) IBOutlet UIImageView                          *taxi_imgvwPhoto;
@property (nonatomic, strong) IBOutlet UILabel                              *taxi_lbName;
@property (nonatomic, strong) IBOutlet UILabel                              *taxi_lbPlaca;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView              *taxi_loading;
@property (nonatomic, strong) IBOutlet UILabel                              *taxi_lbMarca;

@property (nonatomic, strong) IBOutlet UILabel                              *addressLbTitle;
@property (nonatomic, strong) IBOutlet UILabel                              *addressLbCity;
@property (nonatomic, strong) IBOutlet UILabel                              *addressLb1;
@property (nonatomic, strong) IBOutlet UILabel                              *addressLb2;
@property (nonatomic, strong) IBOutlet UILabel                              *addressLb3;

@property (nonatomic, strong) IBOutlet UIImageView                          *stateImgvwConfirmed;
@property (nonatomic, strong) IBOutlet UILabel                              *stateLbConfirmed;
@property (nonatomic, strong) IBOutlet UIImageView                          *stateImgvwCaceled;
@property (nonatomic, strong) IBOutlet UILabel                              *stateLbCancel;
@property (nonatomic, strong) IBOutlet UIImageView                          *stateImgvwfinished;
@property (nonatomic, strong) IBOutlet UILabel                              *stateLbFinished;
@property (nonatomic, strong) IBOutlet UIButton                             *stateBtnFinished;
@property (nonatomic, strong) IBOutlet UIButton                             *stateBtnCancel;


@property (nonatomic, strong) IBOutlet UILabel                              *footerLbTypeAgend;
@property (nonatomic, strong) IBOutlet UILabel                              *footerLbDate;
@property (nonatomic, strong) IBOutlet UIImageView                          *footerImgvwLittle;

@property (nonatomic, strong) IBOutlet UILabel                              *lbDestino;
@property (nonatomic, strong) IBOutlet UILabel                              *lbDestinoBarrio;

@property (nonatomic, strong) TYAgend                                       *tyAgend;

- (void)setAgend:(TYAgend *)agend;

- (IBAction)onCancelAgend:(id)sender;
- (IBAction)onFinishedAgend:(id)sender;

@end

@protocol MyAgendItemVWDelegate <NSObject>

- (void)MyAgendItemVWCancelAgend:(MyAgendItemVW *)item;
- (void)MyAgendItemVWFinishedAgend:(MyAgendItemVW *)item;

@end
