//
//  NTUDeviceInfo.h
//  Menus
//
//  Created by NTTak3 on 22/11/12.
//  Copyright (c) 2012 NogardTools. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    DeviceIphone = 1,
    DeviceIphoneHD = 2,
    DeviceIphone5 = 3,
    DeviceIpad = 4,
    DeviceIpadHD = 5
    
}Device;

typedef enum{

    QMachineHight,
    QMachineLow,
    QMachineNotSet

}QMachine;


@interface NTUDeviceInfo : NSObject

@property (nonatomic, assign) Device                    currentDevice;
@property (nonatomic, assign) CGRect                    currentRootFrame;
@property (nonatomic, assign) QMachine                  qmachine;
@property (nonatomic, assign) QMachine                  qmachineLowIphone4;


+ (NTUDeviceInfo *)sharedInstance;

+ (Device)NTUDIGetDevice;

+ (BOOL)NTUDIIsRetinaDisplay;

+ (double)NTUDIGetiOSVersion;

- (CGRect)getRootFrameForDeviceWithOrientation:(UIInterfaceOrientation)orientation;

- (QMachine)getQualityMachine;

- (QMachine)getQualityMachineWithLowIphone4;

- (Device)currentDevice;

@end
