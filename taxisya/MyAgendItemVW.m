//
//  MyAgendItemVW.m
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "MyAgendItemVW.h"
#import <QuartzCore/QuartzCore.h>
#import "ServiceVWC.h"

@implementation MyAgendItemVW

@synthesize delegate            = _delegate;

@synthesize taxi_imgvwPhoto     = _taxi_imgvwPhoto;
@synthesize taxi_lbName         = _taxi_lbName;
@synthesize taxi_lbPlaca        = _taxi_lbPlaca;
@synthesize taxi_loading        = _taxi_loading;
@synthesize taxi_lbMarca        = _taxi_lbMarca;

@synthesize addressLb1          = _addressLb1;
@synthesize addressLb2          = _addressLb2;
@synthesize addressLb3          = _addressLb3;
@synthesize addressLbCity       = _addressLbCity;
@synthesize addressLbTitle      = _addressLbTitle;

@synthesize stateImgvwCaceled   = _stateImgvwCaceled;
@synthesize stateImgvwConfirmed = _stateImgvwConfirmed;
@synthesize stateImgvwfinished  = _stateImgvwfinished;
@synthesize stateLbCancel       = _stateLbCancel;
@synthesize stateLbConfirmed    = _stateLbConfirmed;
@synthesize stateLbFinished     = _stateLbFinished;
@synthesize stateBtnCancel      = _stateBtnCancel;
@synthesize stateBtnFinished    = _stateBtnFinished;

@synthesize footerLbDate        = _footerLbDate;
@synthesize footerLbTypeAgend   = _footerLbTypeAgend;
@synthesize footerImgvwLittle   = _footerImgvwLittle;

@synthesize tyAgend             = _tyAgend;

@synthesize lbDestino           = _lbDestino;
@synthesize lbDestinoBarrio     = _lbDestinoBarrio;

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)setupSkin{

    [self setRoundedView:_taxi_imgvwPhoto toDiameter:90];

    [_taxi_lbName setFont:UI_FONT_1(15)];
    [_taxi_lbPlaca setFont:UI_FONT_1(15)];
    [_taxi_lbMarca setFont:UI_FONT_1(15)];

    [_addressLb1 setFont:UI_FONT_1(15)];
    [_addressLb2 setFont:UI_FONT_1(15)];
    [_addressLb3 setFont:UI_FONT_1(15)];
    [_addressLbCity setFont:UI_FONT_1(15)];
    [_addressLbTitle setFont:UI_FONT_1(15)];

    [_stateLbCancel setFont:UI_FONT_1(15)];
    [_stateLbConfirmed setFont:UI_FONT_1(15)];
    [_stateLbFinished setFont:UI_FONT_1(15)];

    [_footerLbDate setFont:UI_FONT_1(15)];
    [_footerLbTypeAgend setFont:UI_FONT_1(15)];

    [self setBackgroundColor:UI_COLOR_247];

}

- (void)setAgend:(TYAgend *)agend{

    self.tyAgend = agend;

    [self setupSkin];

    _titleMyLocation.text = NSLocalizedString(@"schedule_item_site", nil);
    _titleDestino.text = NSLocalizedString(@"schedule_item_destination", nil);
    //[_buttonTitleCancel setTitle:NSLocalizedString(@"schedule_item_cancel", nil) forState:UIControlStateNormal];
    //[_buttonTitleFinished setTitle:NSLocalizedString(@"schedule_item_finished", nil) forState:UIControlStateNormal];
    
    if(agend.tyAgendStatus == TYAgendStatusWaiting){

        [_stateLbFinished setHidden:YES];
        [_stateImgvwfinished setHidden:YES];
        [_stateBtnFinished setHidden:YES];

        [_stateImgvwConfirmed setImage:[UIImage imageNamed:@"agend-imgvw-esperando.png"]];
        [_stateImgvwConfirmed setTransform:CGAffineTransformMakeTranslation(30, 0)];
        [_stateLbConfirmed setTransform:CGAffineTransformMakeTranslation(30, 0)];
        [_stateLbConfirmed setText:NSLocalizedString(@"schedule_item_wait",nil)];

        [_stateLbCancel setTransform:CGAffineTransformMakeTranslation(60, 0)];
        [_stateLbCancel setText:NSLocalizedString(@"schedule_item_cancel", nil)];


        [_stateImgvwCaceled setTransform:CGAffineTransformMakeTranslation(60, 0)];
        [_stateBtnCancel setTransform:CGAffineTransformMakeTranslation(60, 0)];

    }else if (agend.tyAgendStatus == TYAgendStatusAssigned){

        _stateLbConfirmed.hidden = YES;
        [_stateImgvwfinished setHidden:YES];
        _stateImgvwConfirmed.hidden = YES;

        [_stateLbCancel setTransform:CGAffineTransformMakeTranslation(-80, 0)];
        [_stateImgvwCaceled setTransform:CGAffineTransformMakeTranslation(-80, 0)];
        [_stateBtnCancel setTransform:CGAffineTransformMakeTranslation(-80, 0)];

        [_stateLbFinished setTransform:CGAffineTransformMakeTranslation(-35, 0)];
        [_stateImgvwfinished setTransform:CGAffineTransformMakeTranslation(-35, 0)];
        [_stateBtnFinished setTransform:CGAffineTransformMakeTranslation(-35, 0)];
        [_stateLbFinished setText:NSLocalizedString(@"schedule_item_finished",nil)];


    }else if (agend.tyAgendStatus == TYAgendStatusFinished){

        _stateBtnCancel.hidden = YES;
        [_stateImgvwfinished setHidden:YES];
        _stateBtnFinished.hidden = YES;

        _stateLbCancel.hidden = YES;
        _stateImgvwCaceled.hidden = YES;

        _stateLbConfirmed.hidden = YES;
        _stateImgvwConfirmed.hidden = YES;

        [_stateLbFinished setTransform:CGAffineTransformMakeTranslation(-90, 0)];
        [_stateImgvwfinished setTransform:CGAffineTransformMakeTranslation(-90, 0)];



    }else if (agend.tyAgendStatus == TYAgendStatusCanceled){

        _stateBtnCancel.hidden = YES;
        _stateBtnFinished.hidden = YES;
        _stateLbConfirmed.hidden = YES;
        _stateLbFinished.hidden = YES;
        _stateImgvwConfirmed.hidden = YES;
        _stateImgvwfinished.hidden = YES;
        _stateLbCancel.text = NSLocalizedString(@"schedule_item_cancelled",nil);
        [_stateLbCancel setFrame:CGRectMake(_stateLbCancel.frame.origin.x, _stateLbCancel.frame.origin.y, _stateLbCancel.frame.size.width + 20, _stateLbCancel.frame.size.height)];

    }

    if(agend.tyTaxiProfile && (agend.tyAgendStatus == TYAgendStatusAssigned || agend.tyAgendStatus == TYAgendStatusFinished) ){

        [_taxi_lbName setText:[NSString stringWithFormat:@"%@ %@", agend.tyTaxiProfile.name, agend.tyTaxiProfile.lastName]];
        [_taxi_lbPlaca setText:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"schedule_item_plate",nil),agend.tyTaxiProfile.placa]];
        [_taxi_lbMarca setText:[NSString stringWithFormat:@"%@:%@ %@", NSLocalizedString(@"schedule_item_brand",nil), agend.tyTaxiProfile.brand, agend.tyTaxiProfile.model ]];

        if(agend.tyTaxiProfile.urlImage && agend.tyTaxiProfile.urlImage  != (NSString *)[NSNull null]){

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{

                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICES, agend.tyTaxiProfile.urlImage]]];

                if(data){

                    dispatch_async(dispatch_get_main_queue(), ^{

                        [_taxi_loading stopAnimating];

                        [_taxi_imgvwPhoto setImage:[UIImage imageWithData:data]];

                    });

                }else{



                }

            });

        }


    }

    if([agend.tyAddress.addressFull length] > 0){
        [_addressLbCity setText:[NSString stringWithFormat:@"%@", agend.tyAddress.addressFull]];
        [_addressLb3 setText:[NSString stringWithFormat:@"%@",agend.tyAddress.address5]];
    }
    else {
        [_addressLbCity setText:[NSString stringWithFormat:@"%@ %@ # %@ - %@ %@", agend.tyAddress.address1, agend.tyAddress.address2, agend.tyAddress.address3, agend.tyAddress.address4, agend.tyAddress.address5]];
        [_addressLb3 setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"schedule_item_barrio",nil), agend.tyAddress.address6]];
    }
    NSLog(@"agend item = %@", agend.tyAddress.address1);
    NSLog(@"agend item = %@", agend.tyAddress.addressFull);

    if(agend.dateAgend){

        [_footerLbDate setText:agend.dateAgend];

    }

    if(agend.typeAgend){

        UIImageView *imgvw = nil;

        [_footerLbTypeAgend setText:agend.typeAgend];

        [_addressLbTitle setTransform:CGAffineTransformMakeTranslation(0, 20)];
        [_addressLbCity setTransform:CGAffineTransformMakeTranslation(0, 25)];
        [_addressLb3 setTransform:CGAffineTransformMakeTranslation(0, 25)];

        [_lbDestino setHidden:YES];
        [_lbDestinoBarrio setHidden:YES];

        if([agend.typeAgend hasPrefix:@"Aero"]){

            imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little_airport.png"]];

            [imgvw setFrame:CGRectMake(15, self.frame.size.height - ((imgvw.frame.size.height * 0.5) + 10), imgvw.frame.size.width*0.5, imgvw.frame.size.height * 0.5)];

            [self addSubview:imgvw];

        }else if([agend.typeAgend hasPrefix:@"Fue"]){

            imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little_outside.png"]];

            [imgvw setFrame:CGRectMake(15, self.frame.size.height - ((imgvw.frame.size.height * 0.5) + 15), imgvw.frame.size.width*0.5, imgvw.frame.size.height * 0.5)];

            [self addSubview:imgvw];

            [_addressLbTitle setTransform:CGAffineTransformIdentity];
            [_addressLbCity setTransform:CGAffineTransformIdentity];
            [_addressLb3 setTransform:CGAffineTransformIdentity];

            [_lbDestino setHidden:NO];
            [_lbDestinoBarrio setHidden:NO];

            [_lbDestinoBarrio setText:agend.tyAddress.destination];


        }else if([agend.typeAgend hasPrefix:@"Men"]){

            imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little_message.png"]];

            [imgvw setFrame:CGRectMake(15, self.frame.size.height - ((imgvw.frame.size.height * 0.5) + 15), imgvw.frame.size.width*0.5, imgvw.frame.size.height * 0.5)];

            [self addSubview:imgvw];

        }else{

            imgvw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"little_perhour.png"]];

            [imgvw setFrame:CGRectMake(15, self.frame.size.height - ((imgvw.frame.size.height * 0.5) + 15), imgvw.frame.size.width*0.5, imgvw.frame.size.height * 0.5)];

            [self addSubview:imgvw];

        }


    }

}

- (void)onCancelAgend:(id)sender{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancelar el Agendamiento"
                                                    message:@"Estas seguro de cancelar el Agendamiento?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelear"
                                          otherButtonTitles:@"Aceptar", nil];

    alert.tag = 100;

    [alert show];



}

- (void)onFinishedAgend:(id)sender{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Agendamiento Finalizado"
                                                    message:@"El agendamiento a finalizado? "
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Si", nil];

    alert.tag = 101;

    [alert show];


}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    int tag = alertView.tag;

    if(tag == 100){

        if(buttonIndex == 1){

            _stateBtnCancel.hidden = YES;
            _stateBtnFinished.hidden = YES;
            _stateLbConfirmed.hidden = YES;
            _stateLbFinished.hidden = YES;
            _stateImgvwConfirmed.hidden = YES;
            _stateImgvwfinished.hidden = YES;
            _stateLbCancel.text = NSLocalizedString(@"schedule_item_cancelled",nil);
            [_stateLbCancel setFrame:CGRectMake(_stateLbCancel.frame.origin.x, _stateLbCancel.frame.origin.y, _stateLbCancel.frame.size.width + 20, _stateLbCancel.frame.size.height)];
            [_stateLbCancel setTransform:CGAffineTransformIdentity];
            [_stateImgvwCaceled setTransform:CGAffineTransformIdentity];


            [_delegate MyAgendItemVWCancelAgend:self];

        }

    }else if (tag == 101){

        if(buttonIndex == 1){

            [_delegate MyAgendItemVWFinishedAgend:self];

        }

    }

}


@end
