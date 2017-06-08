//
//  NewAddressVWC.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 8/28/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import "NewAddressVWC.h"

@interface NewAddressVWC ()

@end

@implementation NewAddressVWC

//@synthesize delegate                        = _delegate;

@synthesize vwSuperVW                       = _vwSuperVW;
@synthesize vwFooter                        = _vwFooter;
@synthesize lbFooter                        = _lbFooter;
@synthesize isVWFooterForEditing            = _isVWFooterForEditing;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil superView:(UIView *)superVW
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.vwSuperVW = superVW;

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // nombre
    self.addressName.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"name_n.png"]];
    [self.addressName setLeftViewMode: UITextFieldViewModeAlways];
    
    // dirección
    self.addressAddress.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gps_n.png"]];
    [self.addressAddress setLeftViewMode: UITextFieldViewModeAlways];
    
    
    // comentario
    self.addressComment.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_n.png"]];
    [self.addressComment setLeftViewMode: UITextFieldViewModeAlways];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAddress:(id)sender {
}
@end
