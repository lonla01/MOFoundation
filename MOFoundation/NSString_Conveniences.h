//
//  NSObject+Conveniences.h
//  Parolisse
//
//  Created by Patrice on 24/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

@import Foundation.NSString;
@import Foundation.NSRange;

#if TARGET_OS_OSX
@import AppKit.NSAttributedString;
#endif

@interface NSString ( Conveniences ) 

- (BOOL)isEmpty;
- (NSString *)appendString:(NSString *)suffix;
- (NSString *)capitalizeFirstChar;
- (NSRange )fullRange;
- (BOOL)isAllUpperCaps;

- (NSString *)firstChar;
- (NSString *)lastChar;
- (NSString *)firstWord;
- (BOOL)isSingleWord;

- (NSString *)trimLeadingBlanks;
- (NSString *)trimTrailingBlanks;
- (NSString *)removeDiacritics;

- (NSArray *)componentsSeparatedByCharactersInSet:(NSCharacterSet *)separators include:(BOOL)include;

@property (nonatomic, readonly) NSString *headText;
@property (nonatomic, readonly) NSString *tailText;
@property (nonatomic, readonly) NSString *shortText;

- (BOOL)isCaseInsensitiveEqual:(NSString *)aString;
- (NSComparisonResult)localizedCaseInsensitiveNumericCompare:(NSString *)aStr;

@end

@interface NSAttributedString ( Conveniences )

- (NSRange )fullRange;
#if TARGET_OS_OSX
    - (NSSize)naturalSize;
#endif

@end

#if TARGET_OS_OSX
@interface NSMutableAttributedString (Conveniences)

- (void )underlineWithColor:(NSColor *)color;
- (void )strikeOutWithColor:(NSColor *)color;

@end
#endif

