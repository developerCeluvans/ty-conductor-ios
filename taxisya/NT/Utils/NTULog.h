//
//  NTULog.h
//  Menus
//
//  Created by NTTak3 on 22/11/12.
//  Copyright (c) 2012 NogardTools. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NTULOG_CGRECT(__RECT__) NSLog(@" CGRect x:%f, y:%f, w:%f, h:%f", __RECT__.origin.x, __RECT__.origin.y, __RECT__.size.width, __RECT__.size.height);

#define NTULOG_CGPOINT(__POINT__) NSLog(@" CGPint x:%f, y:%f", __POINT__.x, __POINT__.y);


@interface NTULog : NSObject

@end
