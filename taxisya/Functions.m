//
//  Functions.m
//  taxisya
//
//  Created by Guillermo Blanco on 26/02/15.
//  Copyright (c) 2015 imaginamos. All rights reserved.
//

#import "Functions.h"

@implementation Functions

+ (NSString *)getCorrectlyAddress:(NSString *)address {
    NSMutableString *arr = [[NSMutableString alloc] init];
    
    BOOL is_number = NO;
    BOOL last_is_letter = NO;
    int last_letter_code = 0;
    
    for (int i = 0; i < [address length]; ++i) {
        int code = [address characterAtIndex:i];
        is_number = (code >= 48 && code <= 57);
        if(last_is_letter && is_number && last_letter_code != 32){
            [arr appendFormat:@" "];
        }
        if(!last_is_letter && !is_number && last_letter_code != 32){
            [arr appendFormat:@" "];
        }
        [arr appendFormat:@"%@", [address substringWithRange:NSMakeRange(i, 1)]];
        
        last_is_letter = !is_number;
        if(last_is_letter){
            last_letter_code = code;
        }else{
            last_letter_code = 0;
        }
        
    }
    NSLog(@"Direccion %@", arr);
    return arr;
}

@end
