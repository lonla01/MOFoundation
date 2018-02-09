//
//  PSRomanNumParser.m
//  Parolisse
//
//  Created by Patrice on 19/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

#import "PSRomanNumberDetector.h"
#import "PSLogger.h"

static NSMutableDictionary *_RomanNumbers = nil;
static PSRomanNumberDetector *_Singleton = nil;

@interface PSRomanNumberDetector( Private )

- (NSUInteger) _checkArgument:(NSString *)romanNumber;
/**
 * Takes a single char string as argument and returns its decimal equivalent.
 */
- (NSNumber *) _atomicDecimalValue:(NSString *)romanNumber;

- (NSNumber *) _biAtomicDecimalValue:(NSString *)romanNumber;

@end

@implementation PSRomanNumberDetector

+ (PSRomanNumberDetector *)singleton {
    if ( _Singleton == nil ) {
        _Singleton = [[self alloc] init];
    }
    return _Singleton;
}

- (NSMutableDictionary *) romanDict {
    if (_RomanNumbers == nil) {
        _RomanNumbers = [NSMutableDictionary new];
         _RomanNumbers[@"I"] = @1;
         _RomanNumbers[@"V"] = @5;
         _RomanNumbers[@"X"] = @10;
         _RomanNumbers[@"L"] = @50;
         _RomanNumbers[@"C"] = @100;
         _RomanNumbers[@"D"] = @500;
         _RomanNumbers[@"M"] = @1000;
    }
    return _RomanNumbers;
}

- (BOOL) isRomanAtomicChar:(NSString *)romanChar {
    if ( [romanChar length] > 1 ) return NO;
    NSString *upCaseNum = [romanChar uppercaseString];
    NSArray*romanSet = [[self romanDict] allKeys];
    if ( [romanSet containsObject:upCaseNum] )
        return YES;
    else {
        return NO;
    }
}

/**
 * Checks if a given string represent or not a roman number.
 */
- (BOOL) isRomanNumber:(NSString *)aRomanString {
    return [self _checkArgument:[aRomanString uppercaseString]] == PSRomanNumParserArgValid;
}

/**
 * Takes a string representing a roman number and compute its decimal 
 * equivalent. The method throws an IllegalArgumentException if the 
 * string is not a valid representation of a roman number.
 */
- (NSNumber *)decimalValue:(NSString *)aRomanNumber {
    NSString *upCaseNum = [aRomanNumber uppercaseString];
    NSString *prefix = nil, *lastTwo = nil;
    NSNumber *retVal = nil;
    NSUInteger len = [upCaseNum length];
    
    if ( [self _checkArgument:upCaseNum] != PSRomanNumParserArgValid ) {        
        @throw [NSException  exceptionWithName:NSInvalidArgumentException 
                                       reason:[NSString stringWithFormat:@"This argument is not a roman number: [%@]", aRomanNumber]  
                                        userInfo:nil];
    }
    if ( len == 1 ) 
        return [self _atomicDecimalValue:upCaseNum];
    if ( len == 2 )
        return [self _biAtomicDecimalValue:upCaseNum];
    
    //lastTwo      = [upCaseNum substringWithRange:NSMakeRange( len-2, len     )];
    //prefix = [upCaseNum substringWithRange:NSMakeRange(         0, len-2 )];
    prefix     = [upCaseNum substringToIndex:len-2];
    lastTwo  = [upCaseNum substringFromIndex:len-2];
    [self trace:[NSString stringWithFormat:@"String[%@] prefix[%@] last2[%@]", upCaseNum, prefix, lastTwo]];
    
    retVal = [self _biAtomicDecimalValue:lastTwo];
    retVal = @( [retVal intValue] + [[self decimalValue:prefix] intValue] );
    
    return retVal;                  
}

@end

@implementation PSRomanNumberDetector( Private )

- (NSUInteger) _checkArgument:(NSString *)romanNumber {
    if ( (romanNumber == nil) || ( [romanNumber length] == 0 ) )
        return PSRomanNumParserArgEmpty;
    if ([romanNumber length] == 1) {
        if ( [self isRomanAtomicChar: romanNumber] )
            return PSRomanNumParserArgValid;
        else {
            return PSRomanNumParserArgInvalid;
        }
    }
    for (int i = 0; i < [romanNumber length]; i++) {
        //TODO: We could use -[NSString stringToIndex:0] for the following 2 lines.
        unichar aChar = [romanNumber characterAtIndex:i];
        NSString *curChar = [NSString stringWithCharacters:&aChar length:1];
        [self verbose:[NSString stringWithFormat:@"rN=[%@] cC=[%@] i=[%d]", romanNumber, curChar, i]];
        NSNumber *decValue = [self _atomicDecimalValue:curChar];
        if (decValue == nil)
            return PSRomanNumParserArgInvalid;
    }
    return PSRomanNumParserArgValid;
}

/**
 * Takes a single char string as argument and returns its decimal equivalent.
 */
- (NSNumber *) _atomicDecimalValue:(NSString *)romanNumber {
    if ( romanNumber == nil || [romanNumber length] != 1 ) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Argument length should be exactly one." userInfo:nil];
    }
    return (NSNumber *)[self romanDict][romanNumber];
}

- (NSNumber *) _biAtomicDecimalValue:(NSString *)romanNumber {
    if ( romanNumber == nil || [romanNumber length] != 2 )
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Argument length should be exactly two." userInfo:nil];
    
    unichar aChar = [romanNumber characterAtIndex:0];
    NSString *leftChar = [NSString stringWithCharacters:&aChar length:1];
    NSString *rightChar = [romanNumber substringFromIndex:1];
    [self trace:[NSString stringWithFormat:@"left[%@] right[%@]", leftChar, rightChar]];                       
    //NSString *leftChar    = [romanNumber substringWithRange:NSMakeRange(0, 1)];
    //NSString *rightChar = [romanNumber substringWithRange:NSMakeRange(1, 2)];    
    NSNumber *leftVal     = [self _atomicDecimalValue:leftChar    ];
    NSNumber *rightVal  = [self _atomicDecimalValue:rightChar ];
    
    if ( [leftVal compare: rightVal] == NSOrderedAscending )
        return @( [rightVal intValue] - [leftVal intValue] );
    else 
        return @( [rightVal intValue] + [leftVal intValue] );
}

@end

@implementation NSString( PSRomanNumberParsing ) 
    //Checks if the receiving string represents a roman number or not.
    - (BOOL) isRomanNumber {
        return [[PSRomanNumberDetector singleton] isRomanNumber:self];
    }
    
    /**
     * The receiving string is supposed to be representing a roman number. The method computes its decimal 
     * equivalent. The method throws an IllegalArgumentException if the 
     * string is not a valid representation of a roman number.
     */
    - (NSNumber *)romanNumberDecimalValue {
        return [[PSRomanNumberDetector singleton] decimalValue:self];
    }
    
@end
