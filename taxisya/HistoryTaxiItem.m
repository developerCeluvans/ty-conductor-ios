//
//  HistoryTaxiItem.m
//  taxisya
//
//  Created by NTTak3 on 8/05/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "HistoryTaxiItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation HistoryTaxiItem

@synthesize imgvwTaxista                = _imgvwTaxista;
@synthesize lbName                      = _lbName;
@synthesize lbMarca                     = _lbMarca;
@synthesize lbPlaca                     = _lbPlaca;
@synthesize loading                     = _loading;
@synthesize btnPhone                    = _btnPhone;
@synthesize lbNumber                    = _lbNumber;

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)setName:(NSString *)name placa:(NSString *)placa urlImage:(NSString *)urlImage phone:(NSString *)phone marca:(NSString *)marca service:(int64_t)serviceID{

    [_lbName setText:name];
    [_lbPlaca setText:placa];
    
    [_lbName setTextColor:UI_COLOR_ORAGNE];
    
    [_lbName setFont:UI_FONT_1(15)];
    [_lbPlaca setFont:UI_FONT_1(15)];
    
    [_btnPhone setTitle:phone forState:UIControlStateNormal];
    [_btnPhone setTitle:phone forState:UIControlStateHighlighted];
    [_btnPhone.titleLabel setFont:UI_FONT_1(15)];
    [_btnPhone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnPhone setTitleColor:UI_COLOR_ORAGNE forState:UIControlStateHighlighted];
    
    [_btnPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [_lbMarca setFont:UI_FONT_1(15)];
    [_lbMarca setText:marca];
    [_lbMarca setTextColor:UI_COLOR_ORAGNE];
    
    [_lbNumber setFont:UI_FONT_1(15)];
    [_lbNumber setText:phone];

    [self.btnReclamo setTag:serviceID];
    self.serviceID = serviceID;
    
    if(urlImage && urlImage  != (NSString *)[NSNull null]){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
            
            if(data){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_loading stopAnimating];
                    
                    [_imgvwTaxista setImage:[UIImage imageWithData:data]];
                    
                    [self setRoundedView:_imgvwTaxista toDiameter:80];
                    
                });
                
            }else{
             
													
            
            }
            
        });
        
    }


}

- (void)call:(id)sender{

    UIButton *btn = (UIButton *)sender;
    
    NSString *title = btn.titleLabel.text;
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:title];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

- (IBAction)reclamo:(UIButton *)sender {
    [self.delegate showReclamo:sender.tag];
}

@end
