//
//  TYFormatter.m
//  taxisya
//
//  Created by NTTak3 on 30/04/13.
//  Copyright (c) 2013 imaginamos. All rights reserved.
//

#import "TYFormatter.h"
#import "UIDevice+IdentifierAddition.h"

@implementation TYFormatter

+ (BOOL) FormatterValidateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validRegister= [emailTest evaluateWithObject:email];
    return validRegister;
    
}

+ (BOOL) FormatterValidateNumbers:(NSString *)numbers{
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:numbers];
    
    return  [alphaNums isSupersetOfSet:inStringSet];
    
    
}

+ (NSString *)FormatterGetDeviceIdentifier{

    return  [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];

}

+ (BOOL) formatterValidateInternetConnection{
    
    AReachability *reach = [AReachability reachabilityForInternetConnection];
    return [reach isReachable];
    
}

@end
