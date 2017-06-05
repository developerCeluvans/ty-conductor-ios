//
//  AppDelegate.h
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 9/20/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

