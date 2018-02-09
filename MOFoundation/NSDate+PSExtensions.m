//
//  NSDate+PSExtensions.m
//  Parolisse
//
//  Created by Patrice on 28/02/13.
//
//

#import "NSDate+PSExtensions.h"
#include <time.h>

static NSString *PSFixedUnlocalizedFormat = @"%Y-%m-%d %H:%M:%S %z";

@implementation NSDate (PSExtensions)

// This is a fixed unlocalized string description
- (NSString *)unlocalizedDescription {
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:PSFixedUnlocalizedFormat];
    
    return [formatter stringFromDate:self];
    
}

+ (NSDate *)dateFromUnlocalizedDescription:(NSString *)description {
    
    NSDate *aDate;    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:PSFixedUnlocalizedFormat];
    aDate = [formatter dateFromString:description];
    
    return aDate;
    
}

// This is a fixed unlocalized string description
- (NSNumber *)timeInterval {
    
    NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate];
    
    return [NSNumber numberWithDouble:(double)timeInterval];
    
}

+ (NSDate *)dateFromTimeInterval:(NSNumber *)timeInterval {
    
    NSDate *aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[timeInterval doubleValue]];
    
    return aDate;
    
}

- (NSString *)displayString {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    
    return [formatter stringFromDate:self];
    
}

//+ (NSDate *)___dateFromUnlocalizedDescription:(NSString *)description {
//    
//    NSDate *aDate;
//    struct tm sometime;
//    const char *formatString = [PSFixedUnlocalizedFormat UTF8String];
//    
//    (void )strptime_l( [description UTF8String], formatString, &sometime, NULL);
//    aDate = [NSDate dateWithTimeIntervalSince1970: mktime(&sometime)];
//    
//    return aDate;
//    
//}

@end
