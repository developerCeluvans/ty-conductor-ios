//
//  AppDelegate.m
//  taxisyaconductor
//
//  Created by Leonardo Rodriguez on 9/20/15.
//  Copyright © 2015 Imaginamos. All rights reserved.
//

#import "AppDelegate.h"
#import "OptionsViewController.h"
#import "LoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AFNetworkReachabilityManager.h>
#import <AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // API Google Maps
    [GMSServices provideAPIKey:@"AIzaSyD5qaC70x9w7Ap4aiUIlu7nAoNRK-jbfHw"];
    
    // Register for Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
 
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    OptionsViewController *optionsVC = [[OptionsViewController alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:optionsVC];
    
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // storage uuid
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dt forKey:@"uuid"];
    [defaults synchronize];
    
    NSLog(@"My token is: %@", dt);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
#if TARGET_IPHONE_SIMULATOR
    // show the cover for testing
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"4e7b54db144ef812428c4111c5f6c7bcedbbea75875f690dc900c1d49cb36a57" forKey:@"uuid"];
    [defaults synchronize];
    
#endif

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {    
    
    NSLog(@"Receive ush %@", userInfo);
    
    id num = [[[userInfo objectForKey:@"aps"] objectForKey:@"extra"] objectForKey:@"push_type"];
    
    NSInteger push_type = [num integerValue];
    
    NSLog(@"push_type %ld",(long)push_type);
    
    if (push_type == 1) {
        NSLog(@"push_type = %li",push_type);
        
        
        
        NSLog(@"-------------");
    }
    
    if (push_type == 59) { // desconectar
        NSLog(@"close session");
        
        [self clearUsersDefault];
        
        //OptionsViewController *optionsVC = [[OptionsViewController alloc] initWithNibName:nil bundle:nil];
        
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        self.window.rootViewController = navigationController;
        
    }
    
    if(application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Inactive - the user has tapped in the notification when app was closed or in background");
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"application Background - notification has arrived when app was in background");
    }
    else {
        NSLog(@"application Active - notication has arrived while app was opened");
    }
}

- (void)initTimer {
    
    // Create the location manager if this object does not
    // already have one.
//    if (nil == self.locationManager)
//        self.locationManager = [[CLLocationManager alloc] init];
//    
//    self.locationManager.delegate = self;
//    [self.locationManager startMonitoringSignificantLocationChanges];
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(checkUpdates:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)checkUpdates:(NSTimer *)timer{
    UIApplication*    app = [UIApplication sharedApplication];
    double remaining = app.backgroundTimeRemaining;
    if(remaining < 580.0) {
//        [self.locationManager startUpdatingLocation];
//        [self.locationManager stopUpdatingLocation];
//        [self.locationManager startMonitoringSignificantLocationChanges];
        NSLog(@"    Remaining < 580.0");
    }
    NSLog(@"Reminaing %f", app.backgroundTimeRemaining);
}


-(void)clearUsersDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"login"];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"name"];
    [defaults removeObjectForKey:@"driver_id"];
    
    [defaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"    applicationDidEnterBackground +");
    UIApplication*    app = [UIApplication sharedApplication];
        
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task.
        self.timer = nil;
        [self initTimer];
        
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
