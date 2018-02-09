//
//  NSNumber_Conveniences.h
//  Parolisse
//
//  Created by Patrice on 26/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

@import Foundation;

@interface NSNumber ( Conveniences ) 
+ (NSNumber *) minusOne;
+ (NSNumber *) zero;
+ (NSNumber *) one;
+ (NSNumber *) two;
+ (NSNumber *) three;
+ (NSNumber *) four;
+ (NSNumber *) five;
+ (NSNumber *) six;
+ (NSNumber *) seven;
+ (NSNumber *) eight;
+ (NSNumber *) nine;
+ (NSNumber *) ten;

+ (NSNumber *) hundred;
+ (NSNumber *) thousand;

+ (NSNumber *) withInt:(int)anInt;
+ (NSNumber *)withInteger:(NSUInteger )anInt;
+ (NSNumber *) withString:(NSString *)aString;

- (NSNumber *) squared;
- (NSNumber *) mean:(NSNumber *) other;
- (NSNumber *) negated;
- (NSNumber *) max:(NSNumber *)other;
- (NSNumber *) min:(NSNumber *)other;
- (NSNumber *) incr;
- (NSNumber *) decr;
- (NSNumber *) plus:(NSNumber *) other;
- (NSNumber *) minus:(NSNumber *) other;
- (NSNumber *) times:(NSNumber *) other;
- (NSNumber *) div:(NSNumber *) other;
- (NSNumber *) mod:(NSNumber *) other;

- (BOOL)isEq:(id)anObject;
- (BOOL) isPos;
- (BOOL) isNeg;

- (BOOL) leTh:(NSNumber *) other;
- (BOOL) leEqTh:(NSNumber *) other ;
- (BOOL) grTh:(NSNumber *) other ;
- (BOOL) grEqTh:(NSNumber *) other;

@end
