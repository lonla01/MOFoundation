//
//  PSRomanNumParser.h
//  Parolisse
//
//  Created by Patrice on 19/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

@import Foundation;

enum {
    PSRomanNumParserArgValid = 0,
    PSRomanNumParserArgInvalid = -1,
    PSRomanNumParserArgEmpty = -2
};


@interface PSRomanNumberDetector : NSObject {
}

+ (PSRomanNumberDetector *)singleton;
- (NSMutableDictionary *) romanDict;
- (BOOL) isRomanAtomicChar:(NSString *)romanChar;

 //Checks if a given string represent or not a roman number.
- (BOOL) isRomanNumber:(NSString *)aRomanString;

/**
 * Takes a string representing a roman number and compute its decimal 
 * equivalent. The method throws an IllegalArgumentException if the 
 * string is not a valid representation of a roman number.
 */
- (NSNumber *)decimalValue:(NSString *)aRomanNumber;

@end

@interface NSString ( PSRomanNumberParsing ) 
    //Checks if the receiving string represents a roman number or not.
    - (BOOL) isRomanNumber;
    
    /**
     * The receiving string is supposed to be representing a roman number. The method computes its decimal 
     * equivalent. The method throws an IllegalArgumentException if the 
     * string is not a valid representation of a roman number.
     */
    - (NSNumber *)romanNumberDecimalValue;
    
@end
