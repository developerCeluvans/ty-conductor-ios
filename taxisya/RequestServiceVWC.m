//
//  RequestServiceVWC.m
//  taxisya
//
//  Created by Leonardo Rodriguez on 9/4/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import "RequestServiceVWC.h"

#define WS_IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define WS_IS_IPHONE_5 (WS_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)


@interface RequestServiceVWC ()

@end

@implementation RequestServiceVWC


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
    
    
    // Set up the shape of the circle
    int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor orangeColor].CGColor;
    circle.lineWidth = 3;
    
    // Add to parent layer
    [self.view.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    
    
    // add button
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, -1, 38, 48)];

   
    
}

- (void)actionCancelService {
    NSLog(@"----");
}
     
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    int radius = 100;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(
                                                                            self.viewMask.bounds.origin.x,
                                                                            self.viewMask.bounds.origin.y,
                                                                            self.viewMask.bounds.size.width,
                                                                            self.viewMask.bounds.size.height) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.view.bounds.size.width/7, 110, 2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor whiteColor].CGColor;
    fillLayer.opacity = 0.7;
    [self.viewMask.layer addSublayer:fillLayer];
    
    float height = 0.0f;
    
    if (WS_IS_IPHONE_5){
        NSLog(@"======= dimensiones ======");
        height = self.view.bounds.size.height;
    }
    else {
        height = self.view.bounds.size.height - 88.0f;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:
                        CGRectMake(5,
                                   height - 80,
                                   self.view.bounds.size.width - 10, 70)];
    
    NSLog(@"======= dimensiones ======");
    NSLog(@"   height: %f", self.view.bounds.size.height);
    
    [button setImage:[UIImage imageNamed:@"btn_d"] forState:UIControlStateNormal];
    
    
    
    [button addTarget:self action:@selector(actionCancelService) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
    // button text
    UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(4, height - 52, self.view.bounds.size.width - 8, 16)];
    [buttonText setText:@"Cancelar"];
    [buttonText setTextAlignment:NSTextAlignmentCenter];
    [buttonText setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [buttonText setTextColor:[UIColor grayColor]];
    [self.view addSubview:buttonText];
    
    
    
    // message
    UILabel *messageText = [[UILabel alloc] initWithFrame:CGRectMake(4, height - 17, self.view.bounds.size.width - 8, 12)];
    [messageText setText:@"Más de 2700 unidades activas"];
    [messageText setTextAlignment:NSTextAlignmentCenter];
    [messageText setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [messageText setTextColor:[UIColor grayColor]];
    [self.view addSubview:messageText];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onProgressBtnPressed
{
    customProgressView = [[CustomProgressView alloc] init];
    customProgressView.delegate = self;
    [self.view addSubview:customProgressView];
    
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.3] afterDelay:0.0];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.75] afterDelay:2.0];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:4.0];
}

-(void)setProgress:(NSNumber*)value
{
    [customProgressView performSelectorOnMainThread:@selector(setProgress:) withObject:value waitUntilDone:NO];
}

- (void)show:(BOOL)show {
    [self show:show animated:YES];
}

- (void)show:(BOOL)show animated:(BOOL)animated {
    
    NSLog(@"ENTRA AL SHOW PERO DEL LOADING--------------------------");

}

@end
