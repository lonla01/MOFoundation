//
//  NSDateFormatter+LSExtensions.m
//  Librisse
//
//  Created by Patrice on 12/08/13.
//  Copyright (c) 2013 Librisse. All rights reserved.
//

#import "NSDateFormatter+LSExtensions.h"

@implementation NSDateFormatter (LSExtensions)

+ (NSDateFormatter *)shortDateFormatter {
    
    static NSDateFormatter *shortDateFormatter = nil;
    
    if(shortDateFormatter == nil) {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [shortDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    return shortDateFormatter;
    
}

+ (NSDateFormatter *)mediumDateFormatter {
    
    static NSDateFormatter *shortDateFormatter = nil;
    
    if(shortDateFormatter == nil) {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [shortDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return shortDateFormatter;
    
}


@end
