//
//  PSAssert.h
//  Parolisse
//
//  Created by Patrice on 19/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
@import Foundation;

extern NSString *PSAssertionException;
extern NSString *PSAssertionGenericReason;

@class PSAssert;

@interface PSAssert : NSObject {
}

+ (PSAssert *)singleton;
- (void)assertTrue:(BOOL)condition;
- (void)assertFalse:(BOOL)condition;
- (void)assertTrue:(BOOL)condition msg:(NSString *)msg;
- (void)assertFalse:(BOOL)condition msg:(NSString *)msg;
- (void)assertObject:(id)object isEqualTo:(id)model msg:(NSString *)msg;
- (void)assertObject:(id)object notEqualTo:(id)model msg:(NSString *)msg;

@end

@interface  NSObject (PSAssertExtensions)

- (PSAssert *)asserter;
- (void) assertTrue:(BOOL)condition msg:(NSString *)msg;
- (void)assertFalse:(BOOL)condition msg:(NSString *)msg;
- (void)assertObject:(id)object isEqualTo:(id)model msg:(NSString *)msg;
- (void)assertObject:(id)object notEqualTo:(id)model msg:(NSString *)msg;
- (void) assertTr:(BOOL)testValue msg:(NSString *)msg;
- (void) assertTr:(BOOL)testValue msgFormat:(NSString *)format, ...;
- (void)assertVal:(NSUInteger)obtainedVal  isEq:(NSUInteger)correctVal msg:(NSString *)msg;
- (void)assertObj:(id)object isEq:(id)model msg:(NSString *)msg;
- (void)assertArray:(NSArray *)obtained isEq:(NSArray *)model msg:(NSString *)msg;
- (void)assertDict:(NSDictionary *)obtained isEq:(NSDictionary *)model msg:(NSString *)msg;

@end
