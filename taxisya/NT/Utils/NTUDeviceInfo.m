//
//  NTUDeviceInfo.m
//  Menus
//
//  Created by NTTak3 on 22/11/12.
//  Copyright (c) 2012 NogardTools. All rights reserved.
//

#import "NTUDeviceInfo.h"
#include <sys/sysctl.h>

static NTUDeviceInfo *_instance = nil;

@implementation NTUDeviceInfo

@synthesize currentDevice =                     _currentDevice;
@synthesize currentRootFrame =                  _currentRootFrame;
@synthesize qmachine =                          _qmachine;
@synthesize qmachineLowIphone4 =                _qmachineLowIphone4;

+ (NTUDeviceInfo *)sharedInstance{
    
    @synchronized(self){
        
        if(!_instance){
            
            _instance = [[NTUDeviceInfo alloc] init];
            //Set default values
            _instance.qmachine = QMachineNotSet;
            _instance.qmachineLowIphone4 = QMachineNotSet;
        }
        
    }
    
    return _instance;
    
}


+ (Device)NTUDIGetDevice{
    
    Device currentDevice;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        currentDevice = DeviceIphone;
        
        if([UIScreen mainScreen].bounds.size.height == 568.0 || [UIScreen mainScreen].bounds.size.width == 568.0){
            
            currentDevice = DeviceIphone5;
            
        }else{
            
            if([NTUDeviceInfo NTUDIIsRetinaDisplay]){
                
                currentDevice = DeviceIphoneHD;
                
            }
            
        }
        
    }else{
        
        currentDevice = DeviceIpad;
        
        if([NTUDeviceInfo NTUDIIsRetinaDisplay]) currentDevice = DeviceIpadHD;
        
    }
    
    
    return currentDevice;
    
}

+ (BOOL)NTUDIIsRetinaDisplay{
    
    BOOL retina = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        
        retina = YES;
        
    } else {
        
        retina = NO;
        
    }
    
    return retina;
    
}

+ (double)NTUDIGetiOSVersion{
    
    double version = [[UIDevice currentDevice].systemVersion  doubleValue];
    
    return version;
    
}

- (Device)currentDevice
{
    
    if(_currentDevice == 0){
        
        self.currentDevice = [NTUDeviceInfo NTUDIGetDevice];
        
    }
    
    return _currentDevice;
    
}

- (CGRect)getRootFrameForDeviceWithOrientation:(UIInterfaceOrientation)orientation{
    
    
    if(CGRectIsEmpty(_currentRootFrame)){
        
        Device device = self.currentDevice;
        
        CGRect rect = CGRectNull;
        
        if(device == DeviceIphone5){
            
            _qmachine = QMachineHight;
            
            if([UIApplication sharedApplication].statusBarHidden){
                
                if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
                    
                    rect = CGRectMake(0, 0, 320, 568);
                    
                }else{
                    
                    rect = CGRectMake(0, 0, 568, 320);
                    
                }
                
                
            }else{
                
                if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
                    
                    rect = CGRectMake(0, 0, 320, 548);
                    
                }else{
                    
                    rect = CGRectMake(0, 0, 568, 300);
                    
                }
                
            }
            
            
        }else if (device == DeviceIphone || device == DeviceIphoneHD){
            
            if([UIApplication sharedApplication].statusBarHidden){
                
                if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
                    
                    rect = CGRectMake(0, 0, 320, 480);
                    
                }else{
                    
                    rect = CGRectMake(0, 0, 480, 320);
                    
                }
                
            }else{
                
                if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
                    
                    rect = CGRectMake(0, 0, 320, 460);
                    
                }else{
                    
                    rect = CGRectMake(0, 0, 480, 300);
                    
                }
                
                
            }
            
            
        }
        
        self.currentRootFrame = rect;
        
    }
    
    
    return _currentRootFrame;
    
}

-(QMachine)getQualityMachine{

    if(_qmachine == QMachineNotSet){
        
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *model = malloc(size);
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
        free(model);
        
        NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    
        if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
            if (version >= 3){
                
                self.qmachine = QMachineHight;
                
            }else{
                
                self.qmachine = QMachineLow;
                
            }
            
        }else if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
            if (version >4) {
                
                self.qmachine = QMachineHight;
                
            }else{
                
                self.qmachine = QMachineLow;
                
            }
        }else if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
            if (version >=2) {
                
                self.qmachine = QMachineHight;
                
            }else{
                
                self.qmachine = QMachineLow;
                
            }
        }else{
        
            self.qmachine = QMachineHight;
            
        }
    }
    
    return _qmachine;

}



- (QMachine)getQualityMachineWithLowIphone4
{
    
    if(_qmachineLowIphone4 == QMachineNotSet){
        
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *model = malloc(size);
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
        free(model);
        
        NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
        
        if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
            if (version >= 4){
                
                self.qmachineLowIphone4 = QMachineHight;
                
            }else{
                
                self.qmachineLowIphone4 = QMachineLow;
                
            }
            
        }else if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
            if (version >4) {
                
                self.qmachineLowIphone4 = QMachineHight;
                
            }else{
                
                self.qmachineLowIphone4 = QMachineLow;
                
            }
        }else if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
            int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
            if (version >=2) {
                
                self.qmachineLowIphone4 = QMachineHight;
                
            }else{
                
                self.qmachineLowIphone4 = QMachineLow;
                
            }
        }
    }else{
    
        self.qmachineLowIphone4 = QMachineHight;
    
    }

    return _qmachineLowIphone4;
    
}



@end
