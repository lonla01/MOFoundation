//
//  PSStringToNumberTransformer.m
//  Parolisse
//
//  Created by Patrice on 24/11/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

#import "PSStringToNumberTransformer.h"
#import "NSNumber_Conveniences.h"
#import "PSLogger.h"

@import Foundation;

@implementation PSStringToNumberTransformer

+ (Class)transformedValueClass { return [NSNumber class]; }

+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value {
//        [self debug:[NSString stringWithFormat:@"Transforming [%@ %@] >> [%@ %@]", 
//                     [value className], value, @"NSNumber", [NSNumber withString:(NSString *)value]]];
        return (value == nil) ? nil : [NSNumber withString:(NSString *)value];
}

- (id)reverseTransformedValue:(id)value {
//        [self debug:[NSString stringWithFormat:@"Reversing [%@ %@] >> [%@ %@]",
//                     [value className], value, @"NSString", [value description]]];
        return (value == nil) ? nil : [value description];
}

@end

@implementation LSFloatToPercentTransformer

+ (Class)transformedValueClass { return [NSString class]; }

+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value {
    value = @([(NSNumber *)value floatValue] * 100.0f);
    NSString *percentString = [NSString stringWithFormat:@"%@%@", value, @"%"];
//    [self debug:[NSString stringWithFormat:@"Transforming [%@ %@] >> [%@ %@]", 
//                 [value className], value, [[self class] transformedValueClass], percentString]];
    return (value == nil) ? @"" : percentString;
}

- (id)reverseTransformedValue:(id)value {
    NSString *percentNumStr = [(NSString *)value substringToIndex:[(NSString *)value length]];
    NSNumber *percentValue = @([percentNumStr floatValue]);
    percentValue = @([(NSNumber *)percentValue floatValue] / 100.0f);
    [self debug:[NSString stringWithFormat:@"Reversing [%@ %@] >> [%@ %@]",
                 [value className], value, @"NSString", percentValue]];
    return (value == nil) ? nil : percentValue;
}


@end


//@implementation LSFloatToPercentTransformer
//
//+ (Class)transformedValueClass { return [NSNumber class]; }
//
//+ (BOOL)allowsReverseTransformation { return YES; }
//
//- (id)transformedValue:(id)value {
//            [self debug:[NSString stringWithFormat:@"Transforming [%@ %@] >> [%@ %@]", 
//                         [value className], value, @"NSNumber", [(NSNumber *)value times:[NSNumber hundred]]]];
//    return (value == nil) ? nil : [(NSNumber *)value times:[NSNumber hundred]];
//}
//
//- (id)reverseTransformedValue:(id)value {
//    [self debug:[NSString stringWithFormat:@"Reversing [%@ %@] >> [%@ %@]",
//                 [value className], value, @"NSString", [NSNumber numberWithFloat:([(NSNumber *)value floatValue] / 100.0f)]]];
//    return (value == nil) ? nil : [NSNumber numberWithFloat:([(NSNumber *)value floatValue] / 100.0f)];
//}
//
//
//@end
