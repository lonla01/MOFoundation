//
//  NSNumber_Conveniences.m
//  Parolisse
//
//  Created by Patrice on 26/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
#import "NSNumber_Conveniences.h"

@implementation NSNumber ( Conveniences )

+ (NSNumber *) minusOne      { return [NSNumber withInteger:-1]; }
+ (NSNumber *) zero    { return [NSNumber withInteger:0]; }
+ (NSNumber *) one      { return [NSNumber withInteger:1]; }
+ (NSNumber *) two      { return [NSNumber withInteger:2]; }
+ (NSNumber *) three   { return [NSNumber withInteger:3]; }
+ (NSNumber *) four     { return [NSNumber withInteger:4]; }
+ (NSNumber *) five     { return [NSNumber withInteger:5]; }
+ (NSNumber *) six       { return [NSNumber withInteger:6]; }
+ (NSNumber *) seven { return [NSNumber withInteger:7]; }
+ (NSNumber *) eight   { return [NSNumber withInteger:8]; }
+ (NSNumber *) nine    { return [NSNumber withInteger:9]; }
+ (NSNumber *) ten      { return [NSNumber withInteger:10]; }

+ (NSNumber *) hundred { return [NSNumber withInteger:100]; }
+ (NSNumber *) thousand { return [NSNumber withInteger:1000]; }


+ (NSNumber *) withInt:(int )anInt {
    return [NSNumber withInteger:anInt];
}

+ (NSNumber *)withInteger:(NSUInteger )anInt {
    return @((long)anInt);
}

+ (NSNumber *) withString:(NSString *)aString {
    return [NSNumber withInteger:[aString intValue]];
}

#pragma mark -
#pragma mark    S M A R T   M E T H O D S

- (NSNumber *) squared {
    int intValue = [self intValue];
    
    return [NSNumber withInteger:(  intValue * intValue )];
}

- (NSNumber *) mean:(NSNumber *) other {
    return [NSNumber withInteger:( ( [self intValue] + [other intValue] ) / 2 )];
}

- (NSNumber *) negated {
    return [NSNumber withInteger:( -[self intValue] )];
}

- (NSNumber *) max:(NSNumber *)other {
    return ( [self intValue] >= [other intValue] ) ? self : other;
}

- (NSNumber *) min:(NSNumber *)other {
        return ( [self intValue] <= [other intValue] ) ? self : other;
}

- (NSNumber *) incr {
    return [NSNumber withInteger:( [self intValue] + 1 )];
}

- (NSNumber *) decr {
    return [NSNumber withInteger:( [self intValue] - 1 )];
}

- (NSNumber *) plus:(NSNumber *) other {
    return [NSNumber withInteger:( [self intValue] + [other intValue] )];
}

- (NSNumber *) minus:(NSNumber *) other {
    return [NSNumber withInteger:( [self intValue] - [other intValue] )];
}

- (NSNumber *) times:(NSNumber *) other {
    return [NSNumber withInteger:( [self intValue] * [other intValue] )];
}

- (NSNumber *) div:(NSNumber *) other {
    return [NSNumber withInteger:( [self intValue] / [other intValue] )];
}

- (NSNumber *) mod:(NSNumber *) other {
    return [NSNumber withInteger:( [self intValue] % [other intValue] )];
}

- (BOOL)isEq:(id)anObject {
        if ( anObject == nil || ! [anObject isKindOfClass:[self class]] ) return NO;
        
        return [self intValue] == [anObject intValue];
}

- (BOOL) isPos { return ( [self intValue] >= 0 ); }
- (BOOL) isNeg { return ( [self intValue] < 0 ); }

- (BOOL) leTh:(NSNumber *) other {  return ( [self intValue] < [other intValue] ); }
- (BOOL) leEqTh:(NSNumber *) other {  return ( [self intValue] <= [other intValue] ); }
- (BOOL) grTh:(NSNumber *) other { return ( [self intValue] > [other intValue] ); }
- (BOOL) grEqTh:(NSNumber *) other { return ( [self intValue] >= [other intValue] ); }

@end
