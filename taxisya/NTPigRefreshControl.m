//
//  NTPigRefreshControl.m
//  Opinions
//
//  Created by NTTak3 on 12/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "NTPigRefreshControl.h"
#import <QuartzCore/QuartzCore.h>

#define PIG_HEIGHT                      85

@interface NTPigRefreshControl()
@property (nonatomic, assign) BOOL isRefresing;
@property (nonatomic, assign) UIScrollView *scrollview;
@property (nonatomic, strong) UIImageView *imgvwPig;
@property (nonatomic, assign) CGFloat currentOffset;
@property (nonatomic, strong) UIView *vwLineSeparator;
@property (nonatomic, strong) UIImageView *imgvwArrow;
@end

@implementation NTPigRefreshControl

@synthesize isRefresing = _isRefresing;
@synthesize scrollview = _scrollview;
@synthesize imgvwPig = _imgvwPig;
@synthesize currentOffset = _currentOffset;
@synthesize vwLineSeparator = _vwLineSeparator;

- (id)initInScrollView:(UIScrollView *)scrollView
{
    [self defaultWithUIScrollView:scrollView];
    return  [self initWithFrame:CGRectMake(0, -PIG_HEIGHT, scrollView.frame.size.width, PIG_HEIGHT)];
}

- (id)initWithFrame:(CGRect)frame
{

    if(self = [super initWithFrame:frame]){
        [self setupView];
    }
    
    return self;

}

- (void)dealloc
{
    [_scrollview removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollview = nil;
}


- (void)defaultWithUIScrollView:(UIScrollView *)scrvw
{
    self.scrollview = scrvw;
    self.isRefresing = NO;
    

}

- (void)setupView{
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    self.clipsToBounds = YES;
    
    [_scrollview addSubview:self];
    [_scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.imgvwPig = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_imgvwPig setCenter:CGPointMake(width * 0.5, height + 10)];
    [_imgvwPig setImage:[UIImage imageNamed:@"Loading.png"]];
    [self addSubview:_imgvwPig];
    
    
//    NSArray *animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"Loading.png"],[UIImage imageNamed:@"loading_01.png"], [UIImage imageNamed:@"loading_02.png"], [UIImage imageNamed:@"loading_03.png"],[UIImage imageNamed:@"loading_04.png"],[UIImage imageNamed:@"loading_05.png"],[UIImage imageNamed:@"loading_06.png"], nil];
//    
//    [_imgvwPig setAnimationImages:animationImages];
//    [_imgvwPig setAnimationDuration:5];
    
    self.vwLineSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, PIG_HEIGHT - 1, width, 1)];
    [_vwLineSeparator setBackgroundColor:[UIColor whiteColor]];
    _vwLineSeparator.layer.shadowColor = [UIColor blackColor].CGColor;
    _vwLineSeparator.layer.shadowOffset = CGSizeMake(0, -1.5);
    _vwLineSeparator.layer.shadowOpacity = 0.8;
    _vwLineSeparator.alpha = 1.0f;
    [self addSubview:_vwLineSeparator];
    
//    int arrowWidth = 19;
//    int arrowHeight = 13;
    
//    self.imgvwArrow = [[UIImageView alloc] initWithFrame:CGRectMake(arrowWidth * 0.5, (height * 0.5) + (arrowHeight - 3), arrowWidth, arrowHeight)];
//    [_imgvwArrow setImage:[UIImage imageNamed:@"big_arrow.png"]];
//    [self addSubview: _imgvwArrow];

    

}

static BOOL isInsetAnimated = NO;
static BOOL isRowRotatedUp = NO;


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if([keyPath isEqualToString:@"contentOffset"]){
    
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y;
        
        if(offset <= - 55){
            
                if (!_scrollview.dragging &&  _scrollview.decelerating && !isInsetAnimated) {
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                   
                    _scrollview.contentInset = UIEdgeInsetsMake(55, _scrollview.contentInset.left, _scrollview.contentInset.bottom, _scrollview.contentInset.right);
                    
                    _imgvwArrow.alpha = 0;
                    
                    [UIView commitAnimations];
                    
                    isInsetAnimated = YES;
                    
                    if(!_isRefresing){
                        
                        _isRefresing = YES;
                        
                        //For default because if scrolling to fast the offset may be wrong
                        
                        _currentOffset = -55;
                        
                        [_imgvwPig setTransform:CGAffineTransformMakeTranslation(0, _currentOffset * 0.68)];
                        
//                        [_imgvwPig startAnimating];
                        
                        [self animateLeft];
                        
                        
//                        [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:3.5];
                        
                        
                        [self sendActionsForControlEvents:UIControlEventValueChanged];
                        
                    }
                                        
                }else if (_scrollview.dragging && !_scrollview.decelerating && !isRowRotatedUp && offset < -56){
                    
                    isRowRotatedUp = YES;
                    
                    [UIView animateWithDuration:0.3
                                     animations:^(void){
                                         
                                         [_imgvwArrow setTransform:CGAffineTransformIdentity];
                                         
                                         [_imgvwArrow setTransform:CGAffineTransformMakeRotation(M_PI)];
                                     
                                     }];
                
                }

            return;
            
        }else{
            
            if(isRowRotatedUp){
            
                [UIView animateWithDuration:0.3
                                 animations:^(void){
                                     
                                     [_imgvwArrow setTransform:CGAffineTransformIdentity];
                                     
                                     [_imgvwArrow setTransform:CGAffineTransformMakeRotation(2*M_PI)];
                                     
                                 }];
                
                isRowRotatedUp = NO;
            
            }
            
            if(!_isRefresing){
                
                self.currentOffset = offset;
                
                [_imgvwPig setTransform:CGAffineTransformMakeTranslation(0, offset * 0.68)];
            
            }
            
        }

    }

}

- (void)animateRight{

    if(_isRefresing){
    
        [UIView animateWithDuration:0.2
                         animations:^(void){
                             
                             CGAffineTransform transform = CGAffineTransformMakeTranslation(0, _currentOffset * 0.68);
                        
                             [_imgvwPig setTransform:CGAffineTransformRotate(transform, 0.2f)];
                             
                         }
                         completion:^(BOOL f){
                             
                             [self animateLeft];
                             
                         }];

    
    }else{
    
    
    }

}

- (void)animateLeft{
    
    if(_isRefresing){
        
        [UIView animateWithDuration:0.2
                         animations:^(void){

                             CGAffineTransform transform = CGAffineTransformMakeTranslation(0, _currentOffset * 0.68);
                             [_imgvwPig setTransform:CGAffineTransformRotate(transform, -0.2f)];
                             
                         }
                         completion:^(BOOL f){
                             
                             [self animateRight];
                             
                         }];
    }else{
    
    
    }

}

- (void)animateOriginalPosition{

    [UIView animateWithDuration:0.3
                     animations:^(void){
                         
                         [_imgvwPig setTransform:CGAffineTransformIdentity];
                         
                     }
                     completion:^(BOOL f){
                         
                         
                     }];
}

- (void)stopAnimating{

    if(_isRefresing){
        
        [_imgvwPig stopAnimating];
    
        _isRefresing = NO;
        isInsetAnimated = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.35];
                
        _scrollview.contentInset = UIEdgeInsetsMake(0, _scrollview.contentInset.left, _scrollview.contentInset.bottom, _scrollview.contentInset.right);
        
        _imgvwArrow.alpha = 0;
        
        [UIView commitAnimations];
    
    }

}


@end
