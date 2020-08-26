//
//  PSAssert.m
//  Parolisse
//
//  Created by Patrice on 19/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
#import "PSAssert.h"
#import "PSLogger.h"

// Defined in the header file
NSString *PSAssertionException = @"PSAssertionException";
NSString *PSAssertionGenericReason = @"PSAssertionGenericReason";

@implementation PSAssert

static PSAssert *_Asserter = nil;

+ (PSAssert *)singleton {
    if (_Asserter == nil) {
        _Asserter = [[self alloc] init];
    }
    return _Asserter;
}

- (void)assertTrue:(BOOL)condition {
    [self assertTrue:condition msg:nil];
}

- (void)assertFalse:(BOOL)condition {
    [self assertFalse:condition msg:nil];
}

- (void)assertTrue:(BOOL)condition msg:(NSString *)msg {
    if (condition != YES) {
        NSString *reason = (msg == nil) ? PSAssertionGenericReason : msg;
        [self debug:msg];
        @throw [NSException exceptionWithName:PSAssertionException reason:reason userInfo:nil];
    }
}

- (void)assertFalse:(BOOL)condition msg:(NSString *)msg  {
    [self assertTrue:( ! condition ) msg:msg];
}

- (void)assertObject:(id)object isEqualTo:(id)model msg:(NSString *)msg {
    if ( object == nil && model == nil ) {
        return;       // Assertion OK.
    } else if ( object == nil || model == nil )
         [self assertTrue:NO msg:msg]; //Assertion NOK.
    else {
        [self assertTrue:[object isEqual:model] msg:msg];
    }
}

- (void)assertObject:(id)object notEqualTo:(id)model msg:(NSString *)msg {
    if ( object == nil && model == nil ) {
        [self assertTrue:NO msg:msg]; //Assertion NOK.
    } else if ( object == nil || model == nil )
        return;       // Assertion OK.
    else
        [self assertFalse:[object isEqual:model] msg:msg];
}

@end

@implementation  NSObject (PSAssertExtensions)

- (PSAssert *)asserter { 
    return [PSAssert singleton]; 
}

- (void)assertTrue:(BOOL)condition msg:(NSString *)msg {
    [[self asserter] assertTrue:condition msg:msg];
}

- (void)assertTrue:(BOOL)condition args:(va_list )argList msgFormat:(NSString *)format, ... {
    
    NSString *message;
    
    if ( ! format ) return ;

    message = [[NSString alloc] initWithFormat:format arguments:argList];
    [[self asserter] assertTrue:condition msg:message];
    [self trace:[NSString stringWithFormat:@"%@...OK", message]];
    
}

- (void)assertFalse:(BOOL)condition msg:(NSString *)msg {
    [[self asserter] assertFalse:condition msg:msg];
}

- (void)assertObject:(id)object isEqualTo:(id)model msg:(NSString *)msg {
    [[self asserter] assertObject:object isEqualTo:model msg:msg];
}
- (void)assertObject:(id)object notEqualTo:(id)model msg:(NSString *)msg {
     [[self asserter] assertObject:object notEqualTo:model msg:msg];
}

- (void)assertTr:(BOOL)testValue msg:(NSString *)msg {
    [[self asserter] assertTrue:testValue msg:[NSString stringWithFormat:@"%@: %d != %d", msg, testValue, YES]];
    [self trace:[NSString stringWithFormat:@"%@...OK", msg]];
}

- (void)assertTr:(BOOL)testValue msgFormat:(NSString *)format, ... {
    
    va_list argumentsList;
    
    if ( format ) {
        va_start( argumentsList, format );
        [[self asserter] assertTrue:testValue args:argumentsList msgFormat:format];
        va_end( argumentsList );
    }
    
}


//- (void)errorFormat:(NSString *)format, ... {
//    
//    va_list argumentsList;
//    
//    if ( format ) {
//        va_start( argumentsList, format );
//        [[PSLogger sharedLogger] errorFormat:format args:argumentsList sender:self];
//        va_end( argumentsList );
//    }
//    
//}

- (void)assertVal:(NSUInteger )obtainedVal isEq:(NSUInteger )correctVal msg:(NSString *)msg {
    [[self asserter] assertTrue:( correctVal == obtainedVal ) msg:[NSString stringWithFormat:@"%@: %ld != %ld", msg, (long)correctVal, (long)obtainedVal]];
    [self trace:[NSString stringWithFormat:@"%@: [%ld] = [%ld]", msg, (long)correctVal, (long)obtainedVal]];
}

- (void)assertObj:(id)object isEq:(id)model msg:(NSString *)msg {
    if ( [model isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSDictionary class]] ) {
        [[self asserter] assertDict:(NSDictionary *)object isEq:(NSDictionary *)model msg:msg];
    } else {        
        [self assertObject:object isEqualTo:model msg:[NSString stringWithFormat:@"%@: [%@] != [%@]", msg, model, object]];
        NSString *sign = [object isEqual:model] ? @"=" : @"!=";
        [self trace:[NSString stringWithFormat:@"%@: [%@] %@ [%@]", msg, model, sign, object]];
    }
}

- (void)assertArray:(NSArray *)obtained isEq:(NSArray *)model msg:(NSString *)msg {
    // System.out.print( getClass().getName() + " " + msg );
    [self log:[NSString stringWithFormat:@"%@ %@", [self className], msg]];
    [[self asserter] assertVal:[obtained count] isEq:[model count] msg:[NSString stringWithFormat:@"%@ Testing array size: ", msg]];
    for ( NSUInteger i = 0; i < [obtained count] ; i++ ) {
        id mod = model[i];
        id obj = obtained[i];
        [self assertObj:obj isEq:mod msg:msg];
    }
    [self log:@"...OK\n"];
}

- (void)assertDict:(NSDictionary *)obtained isEq:(NSDictionary *)model msg:(NSString *)msg {
    [self log:[NSString stringWithFormat:@"%@ %@", [self className], msg]];
    [[self asserter] assertVal:[obtained count] isEq:[model count] msg:[NSString stringWithFormat:@"%@ Testing dict size: ", msg]];
    for ( id aKey in [obtained allKeys] ) {
        id mod =model[aKey];
        id obj = obtained[aKey];
        [self assertObj:obj isEq:mod msg:msg];
    }
    [self log:@"...OK\n"];
}

@end



