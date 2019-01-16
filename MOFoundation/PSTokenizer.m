//
//  PSTokenizer.m
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//
                                                                                                                                                                                                                                                                                                                                                        
#import "PSTokenizer.h"
#import <MOFoundation/NSString_Conveniences.h>

@implementation PSTokenizer

@synthesize components = _components;
@synthesize separators = _separators;
@synthesize currentIndex = _currentIndex;

- (id)initWithString:(NSString *)string separators:(NSString *)separators {
    
    if (( self = [super init] )) {
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:separators];
        self.components = [string componentsSeparatedByCharactersInSet:charSet include:YES];
//        self.components = [string componentsSeparatedByCharactersInSet:charSet];
        self.separators = separators;
    }
    
    return self;
}

- (BOOL)hasMoreTokens {
    return self.currentIndex < [self.components count];
}

- (NSString *)nextToken {
    return (self.components)[(_currentIndex++)];
}

- (NSUInteger )remainingTokenCount {
    return [self.components count] - self.currentIndex;
}

@end
