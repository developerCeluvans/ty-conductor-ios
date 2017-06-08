//
//  PaymentVC.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 11/5/16.
//  Copyright © 2016 imaginamos. All rights reserved.
//

#import "PaymentVC.h"
//#import <PaymentezSDK/PaymentezSDK-Swift.h>
#import "TYUsserProfile.h"
#import "NSString+MD5Addition.h"

@interface PaymentVC ()
@property (nonatomic, strong) NSMutableArray *cardList;
@end

@implementation PaymentVC

- (NSMutableArray*) getCardList
{
    if (_cardList == nil)
    {
        _cardList = [[NSMutableArray alloc] init];
    }
    return _cardList;
}
- (IBAction)addAction:(id)sender {
    NSLog(@"A");
    //Show an activity indicator
    
    // TOTO: leer las preferenceia
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_EMAIL];
    
    //NSString *user = [email MD5String];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_ID];
    


    NSString *trimmedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedUserId = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    //NSLog(@"addAction email: %@ user: %@",email,user);
    NSLog(@"addAction email: %@ user: %@",trimmedEmail, trimmedUserId);

    
    /*[PaymentezSDKClient showAddViewControllerForUser:trimmedUserId
                                               email:trimmedEmail
                                           presenter:self callback:^(PaymentezSDKError *error, BOOL closed, BOOL added) {
        if (error != nil)
            NSLog(@"%@", error.description);
        else if (closed)
            NSLog(@"User closed the modal");
        else if (added) {
            NSLog(@"Card Added ");
            [self refreshTable];
        }
        
    }];*/
    
    
    
}

- (IBAction)goBack:(id)sender {
    NSLog(@"PaymentVC goBack");
    //[self show:NO];
    self.cardReference = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.cardReference forKey:USSER_CARD_REFERENCE];
    
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate cardSelected:self.cardReference];
}

- (IBAction)goAdd:(id)sender {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 47, screenWidth, screenHeight - 47)];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.buttonAdd setTitle:NSLocalizedString(@"payment_list_add",nil) forState:UIControlStateNormal];
    self.titleMyAddresses.text = NSLocalizedString(@"payment_list_title",nil);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self refreshTable];
}

- (void) refreshTable
{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_EMAIL];
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_ID];
    
    NSString *trimmedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedUserId = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    //NSLog(@"refreshTable email: %@ user: %@",email,user);
    NSLog(@"refreshTable email: %@ user: %@",trimmedEmail, trimmedUserId);

    
    /*[PaymentezSDKClient listCards:trimmedUserId
                         callback:^(PaymentezSDKError * error, NSArray<PaymentezCard *> * list) {
        if(error == nil)
        {
            self.cardList = [list mutableCopy];
            
            [self.tableView reloadData];
        }
    } ];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.cardList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell" forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"myCell"];
    }

    
    //PaymentezCard *card = self.cardList[indexPath.row];
//    cell.textLabel.text = card.termination;
//    cell.detailTextLabel.text = card.cardReference;

    /*NSString *cardReference = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_CARD_REFERENCE];
    BOOL isDefault = NO;
    if (cardReference != nil) {
        if ([card.cardReference isEqualToString:cardReference]) {
            isDefault = YES;
        }
    
    }*/


    //cell.textLabel.text = card.cardHolder;
   // cell.detailTextLabel.text = [NSString stringWithFormat:@"**** **** **** %@ %@/%@   %@",card.termination,card.expiryMonth,card.expiryYear , (isDefault) ? @"PREDETERMINADA" : @""];
    
    //card.cardReference;

    
    // Configure the cell...
    
    return cell;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentezCard *card = self.cardList[indexPath.row];
    self.cardReference = card.cardReference;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.cardReference forKey:USSER_CARD_REFERENCE];
    
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate cardSelected:self.cardReference];
    
//    [self performSegueWithIdentifier:@"debitSegue" sender:self];
    
}*/
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /*if (editingStyle == UITableViewCellEditingStyleDelete) {
        PaymentezCard *card = self.cardList[indexPath.row];

        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_EMAIL];
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:USSER_ID];

        NSString *trimmedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *trimmedUserId = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [PaymentezSDKClient deleteCard:trimmedUserId cardReference:card.cardReference callback:^(PaymentezSDKError *error, BOOL deleted) {
            
            [self refreshTable];
            
        }];
        
    }*/
}


@end
