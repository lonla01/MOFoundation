//
//  NSObject+Conveniences.m
//  Parolisse
//
//  Created by Patrice on 24/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//


#import "NSNumber_Conveniences.h"
#import "PSLogger.h"
#if TARGET_OS_OSX
    #import <Foundation/NSUndoManager.h>
    #import <AppKit/NSLayoutManager.h>
    #import <AppKit/NSTextContainer.h>
    #import <AppKit/NSAttributedString.h>
#endif

static NSUInteger HEAD_LENGTH = 20;
static NSUInteger TAIL_LENGTH = 20;

@implementation NSString ( Conveniences )

//@dynamic headText, tailText, shortText;

- (BOOL)isEmpty {
    return [self length] == 0;
}

- (NSString *)appendString:(NSString *)suffix {
        return [NSString stringWithFormat:@"%@%@", self, suffix];
}

- (NSString *)capitalizeFirstChar {
    
    NSString *firstChar = [self substringToIndex:1];
    NSString *remaining = [self substringFromIndex:1];
    
    firstChar = [firstChar uppercaseString];     
    
    return [NSString stringWithFormat:@"%@%@", firstChar, remaining];
}

- (BOOL)isAllUpperCaps {
    NSString *upperCaps = [self uppercaseString];
    
    return [self isEqualToString:upperCaps];
}

- (NSString *)firstChar {
    
    if ( [self length] == 0 ) return nil;
    NSUInteger cutIndexInKey = 1;
    NSString *firstCharInKey = [self substringToIndex:cutIndexInKey];
    
    return firstCharInKey;
}

- (NSRange )fullRange {
    return NSMakeRange( 0, [self length] );
}

- (NSRegularExpression *)trailingBlanksTrimmingRegex {
    NSError *error = nil;
    NSRegularExpression *regex = nil;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(\\s+$)" 
                                                      options:0 
                                                        error:&error];
    
    return regex;
    
}

- (NSRegularExpression *)leadingBlanksTrimmingRegex {
    NSError *error = nil;
    NSRegularExpression *regex = nil;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(^\\s+)"
                                                      options:0
                                                        error:&error];
    
    return regex;
    
}

- (NSString *)lastChar {
    
    if ( [self length] == 0 ) return nil;
    NSUInteger cutIndexInKey = [self length] - 1;
    NSString *lastCharInKey = [self substringFromIndex:cutIndexInKey];
    
    return lastCharInKey;
}

- (NSString *)firstWord {
    
    NSString *firstWord = nil;
    NSRange range = [self rangeOfString:@" "];
    
    if ( range.location != NSNotFound && range.length != 0 ) 
        firstWord = [self substringToIndex:range.location];
    
    return firstWord;
}

- (NSString *)trimTrailingBlanks {
    
    NSString *modified;
    
    modified = [[self trailingBlanksTrimmingRegex] stringByReplacingMatchesInString:self
                                                    options:0
                                                     range:NSMakeRange(0, [self length])
                                              withTemplate:@""];
    
    return modified;
}

- (NSString *)trimLeadingBlanks {
    
    NSString *modified;
    
    modified = [[self leadingBlanksTrimmingRegex] stringByReplacingMatchesInString:self
                                                                            options:0
                                                                              range:NSMakeRange(0, [self length])
                                                                       withTemplate:@""];
    
    return modified;
}

- (NSString *)headText {
    NSNumber *minIndex = [[NSNumber withInteger:[self length]] min:[NSNumber withInteger:HEAD_LENGTH]];
    return [self substringToIndex:[minIndex intValue]];
}

- (NSString *)tailText {
    NSInteger tailIndex = [self length] - TAIL_LENGTH;
    //[self debugFormat:@"len[%d] index[%d]", [self length], tailIndex];
    if ( [self length] < TAIL_LENGTH - 1) return self;
    
    return [self substringFromIndex:tailIndex];
}

- (NSString *)shortText {
    return [NSString stringWithFormat:@"%@...%@", self.headText, self.tailText];
}


- (NSString *)removeDiacritics {
        
    NSData *sanitizedData;
    NSMutableString *sanitizedText;
    
    // Turn accented letters into normal non-accented ones 
    sanitizedData = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    // Corrected back-conversion from NSData to NSString
    sanitizedText = [[NSMutableString alloc] initWithData:sanitizedData encoding:NSASCIIStringEncoding];
    [sanitizedText replaceOccurrencesOfString:@"'" withString:@"" options:0 range:[sanitizedText fullRange]];
        
    return sanitizedText;
}

- (NSArray *)componentsSeparatedByCharactersInSet:(NSCharacterSet *)separators include:(BOOL)include {
    
    NSArray *strings = [self componentsSeparatedByCharactersInSet:separators];
    
	if (!include) return strings;
	
	NSMutableArray *components = [NSMutableArray arrayWithCapacity:[strings count] * 2];
	NSInteger i = -1;
	NSInteger count = [strings count];
    NSUInteger cursor = 0;
    NSString *currentSeparator = nil;
    
	for ( NSString *aString in strings ) {
		i++;
		if ( ![aString isEqualToString:@""] ) [components addObject:aString];
        cursor += [aString length];
        
		if ( (i+1) < count ) { 
            currentSeparator = [self substringWithRange:NSMakeRange( cursor, 1 )];
            [components addObject:currentSeparator];
            cursor += [currentSeparator length];
        }
	}
    
	return components;
}

- (BOOL)isSingleWord {
    
    NSArray *components;
    BOOL result;
    NSPredicate *aPredicate;
    NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
    
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    aPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ! [(NSString *)evaluatedObject isEmpty];
    }];
    components = [self componentsSeparatedByCharactersInSet:charSet];
    components = [components filteredArrayUsingPredicate:aPredicate];
    result = [components count] == 1;    
    
    return result;
                           
}

- (NSString *)cleanFromOptional {
    NSMutableString *buffer = [[NSMutableString alloc] initWithString:self];
    // We clean the raw string from extra characters added by the optional system.
    [buffer replaceOccurrencesOfString:@"Optional(\"" withString:@"" options:0 range:[buffer fullRange]];
    [buffer replaceOccurrencesOfString:@"\")" withString:@"" options:0 range:[buffer fullRange]];
    return buffer;
}

    
- (NSString *)wordAtCharacterIndex:(NSInteger )index {
    __block NSString *result = nil;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if (NSLocationInRange(index, enclosingRange)) {
                                  result = substring;
                                  *stop = YES;
                              }
                          }];
    return result;
}

- (NSRange )rangeOfWordAtCharacterIndex:(NSInteger )index {
    __block NSRange result = NSMakeRange( NSNotFound, 0);
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if (NSLocationInRange(index, enclosingRange)) {
                                  result = enclosingRange;
                                  *stop = YES;
                              }
                          }];
    return result;
}

- (NSString *)naveKeyForLinkDestination {
    
    NSString *strongKey;
    NSArray *components = [self componentsSeparatedByString:@" "];
    
    if (components.count >= 2) {
        strongKey = components[1];
    }
    
    return strongKey;
}

- (NSString *)strongKeyForLinkDestination {
    
    NSMutableString *strongKey = [@"" mutableCopy];
    NSArray *components = [self componentsSeparatedByString:@" "];
    NSString *testament = @"";
    NSString *number = @"";
    NSString *prefix = nil;
    NSString *suffix = [number lastChar];
    
    if (components.count >= 4) {
        testament = components[1];
        number = components[3];
    }
    
    // Find the H or G prefix
    if ( [@"Hebrew" isEqualToString:testament] || [@"Greek" isEqualToString:testament] ) {
        prefix = [testament firstChar];
    }
    
    // Test if the last char is A or B extension and truncate number as needed
    if ( [@"A" isEqualToString:suffix] || [@"B" isEqualToString:suffix] ) {
        NSUInteger len = [number length];
        if ( len > 1 && len <= 5 ) {
            // Truncate the last char in number
            number = [number substringWithRange:NSMakeRange(0, len-1) ];
            
        } else {
            number = nil;
        }
    } else {
        suffix = @"";
    }
    
    // Combine all the parts to get the Strong Key
    if ( number && prefix ) {
        
        NSUInteger len = [number length];
        strongKey = [[NSMutableString alloc] initWithString:prefix];
        // Pad enough zero's at the beginning to make 4 chars
        for ( int i = 0; i < (4 - len); i++ ) {
            [strongKey appendString:@"0"];
        }
        [strongKey appendFormat:@"%@%@", number, suffix];
        
    }
    
    
    return strongKey;
}

#pragma mark - NSAttributedString Compatibility

- (NSString *)string {
    return self;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    
    static NSDictionary *_EmptyDict = nil;
    
    if ( _EmptyDict == nil )
        _EmptyDict = [NSDictionary new];
    
    return _EmptyDict;
    
}

#pragma mark - Extensions from SKim

- (BOOL)isCaseInsensitiveEqual:(NSString *)aString {
    return [self caseInsensitiveCompare:aString] == NSOrderedSame;
}

- (NSComparisonResult)localizedCaseInsensitiveNumericCompare:(NSString *)aStr {
    return [self compare:aStr
                 options:NSCaseInsensitiveSearch | NSNumericSearch
                   range:NSMakeRange(0, [self length])
                  locale:[NSLocale currentLocale]];
}

@end

#pragma mark -

@implementation NSAttributedString ( Conveniences )

- (NSRange )fullRange {
    return NSMakeRange( 0, [self length] );
}

- (BOOL)isEmpty {
    return [self length] == 0;
}

- (NSAttributedString *)_attributedSubstringFromRange:(NSRange )range {

    NSAttributedString *substring = nil;
    
        @try {
            substring = [self attributedSubstringFromRange:range];
        }
        @catch (NSException *exception) {
            [self debugFormat:@"[Range Exception:[%d, %d]", range.location, range.length];
            substring = nil;
        }
    
        return substring;
}

#if TARGET_OS_OSX
    + (NSLayoutManager *)sharedLayoutManager {
        
        // Return a layout manager that can be used for any drawing.
        static NSLayoutManager *_LayoutManager = nil;
        
        if (!_LayoutManager) {
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(1.0e7f, 1.0e7f)];
            _LayoutManager = [[NSLayoutManager alloc] init];
            [textContainer setWidthTracksTextView:NO];
            [textContainer setHeightTracksTextView:NO];
            [_LayoutManager addTextContainer:textContainer];
        }
        
        return _LayoutManager;
        
    }


    - (NSSize)naturalSize {
        
        // Figure out how big this graphic would have to be to show all of its contents. -glyphRangeForTextContainer: forces layout.
        NSLayoutManager *layoutManager = [[self class] sharedLayoutManager];
        NSTextContainer *textContainer = [[layoutManager textContainers] objectAtIndex:0];
        
        [textContainer setContainerSize:NSMakeSize(1.0e7f, 1.0e7f)];
        NSTextStorage *contents = [[NSTextStorage alloc] initWithAttributedString:self];
        [contents addLayoutManager:layoutManager];
        [layoutManager glyphRangeForTextContainer:textContainer];
        NSSize naturalSize = [layoutManager usedRectForTextContainer:textContainer].size;
        [contents removeLayoutManager:layoutManager];
        
        return naturalSize;
        
    }
#endif

@end

#if TARGET_OS_OSX
    @implementation NSMutableAttributedString (Conveniences)

    - (void)underlineWithColor:(NSColor *)color  {
        
        [self addAttribute:NSUnderlineStyleAttributeName
                     value:@(NSUnderlineStyleSingle)
                     range:[self fullRange]];
        [self addAttribute:NSUnderlineColorAttributeName
                     value:color
                     range:[self fullRange]];
        
    }

    - (void )strikeOutWithColor:(NSColor *)color {
        
        [self addAttribute:NSStrikethroughStyleAttributeName
                     value:@(NSUnderlineStyleSingle)
                     range:[self fullRange]];
        [self addAttribute:NSStrikethroughColorAttributeName
                     value:color
                     range:[self fullRange]];
        
    }
    
    @end
#endif


