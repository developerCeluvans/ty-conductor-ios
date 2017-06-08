//
//  AddressOldVWC.m
//  taxisya
//
//  Created by NTTak3 on 24/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "AddressOldVWC.h"
#import "AddressOldItemVWC.h"
#import "UIView+Xib.h"
#import "JSON.h"


@interface AddressOldVWC ()

@property (nonatomic, assign) int       y;

@end

@implementation AddressOldVWC

@synthesize delegate        = _delegate;

@synthesize lbMis           = _lbMis;
@synthesize lbDirecciones   = _lbDirecciones;
@synthesize scrvwDirs       = _scrvwDirs;
@synthesize loading         = _loading;

@synthesize y               = _y;

@synthesize tysUsser        = _tysUsser;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<AddressOldVWCDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.delegate = delegate;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"AddressOldVWC viewDidLoad");
    [_lbMis setFont:UI_FONT_1(20)];
    [_lbDirecciones setFont:UI_FONT_1(20)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show{

    [self initServicesIfNeeded];

    [_tysUsser requestUsserType:TYSUsserTypeOldAddress object:nil];


}

- (void)initServicesIfNeeded{

    if(!_tysUsser){

        self.tysUsser = [[TYSUsser alloc] initwithDelegate:self];

    }

}


- (void)setAddress:(NSMutableArray *)maDirs{

    for (UIView *subview in _scrvwDirs.subviews){

        if([subview isKindOfClass:[AddressOldItemVWC class]]){

            [subview removeFromSuperview];
        }

    }

    _y = 85;

    for (TYAddress *address in maDirs){

        AddressOldItemVWC *item = (AddressOldItemVWC *)[UIView viewFromNib:@"AddressOldItemVWC" bundle:nil];

        [item setTarget:self selector:@selector(itemPressed:) address:address];

        [item setFrame:CGRectMake(22, _y, item.frame.size.width, item.frame.size.height)];

        [_scrvwDirs addSubview:item];

        _y += item.frame.size.height + 10;

    }

    [_loading stopAnimating];

    [_scrvwDirs setContentSize:CGSizeMake(0, _y)];

}

- (void)itemPressed:(AddressOldItemVWC *)item{

    [_delegate AddressOldVWCAddressSelected:item.tyAddress];

}

- (void)showAlertWithMessage:(NSString *)msg tag:(int)tag{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:msg
                                                    delegate:nil
                                           cancelButtonTitle:@"Aceptar"
                                           otherButtonTitles:nil];

    alert.tag = tag;

    [alert show];

}

#pragma mark -
#pragma mark - ServicesDelegate

- (void)TYSUsserType:(TYSUsserType)type response:(NSString *)response status:(ServiceStatus)status{

    [_loading stopAnimating];

    if(type == TYSUsserTypeOldAddress){

        if(status == ServiceStatusOk){

//            NSLog(@"XXXXX :::::: %@", response);

            NSMutableDictionary *dic = [response JSONValue];

            if(dic && dic.count){

//                NSLog([dic description]);

                NSString *error = [dic objectForKey:@"error"];

                if(error && [error isEqualToString:@"1"]){



                }else{

                    NSMutableDictionary *values = [dic objectForKey:@"address"];

                    if(values){

                        NSMutableArray *array = [[NSMutableArray alloc] init];

                        for (NSDictionary *dirs in values){

                            NSString *dirId =       [dirs objectForKey:@"id"];
                            NSString *dir1 =        [dirs objectForKey:@"index_id"];
                            NSString *dir2 =        [dirs objectForKey:@"comp1"];
                            NSString *dir3 =        [dirs objectForKey:@"comp2"];
                            NSString *dir4 =        [dirs objectForKey:@"no"];
                            NSString *dir5 =        [dirs objectForKey:@"obs"];
                            NSString *dir6 =        [dirs objectForKey:@"barrio"];

                            TYAddress *address1 = [[TYAddress alloc] init];
                            address1.addressId = dirId;
                            address1.address1 = dir1;
                            address1.address2 = dir2;
                            address1.address3 = dir3;
                            address1.address4 = dir4;
                            address1.address5 = dir5;
                            address1.address6 = dir6;

                            [array addObject:address1];

                        }

                        if(array){

                            [self setAddress:array];

                        }

                    }

                }

            }else{

                //No tiene direcciones

            }

        }else{

            [self showAlertWithMessage:@"Verifica tu conexion a Internet" tag:0];

        }

    }

}



@end
