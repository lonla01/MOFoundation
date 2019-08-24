//
//  PSRange.m
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

#import "PSRange.h"

@implementation PSRange

@synthesize start = _start;
@synthesize end = _end;

- (id)initWithStart:(id)start end:(id)end {
    
    if (( self = [super init] )) {
        self.start = start;
        self.end = end;
    }
    
    return self;
}

+ (PSRange *)rangeWithStart:(id)start end:(id)end {
    PSRange *aRange = [[PSRange alloc] initWithStart:start end:end];
    return aRange;
}

- (NSUInteger )intStart {
    return [self.start integerValue];
}

- (NSUInteger )intEnd {
    return [self.end integerValue];
}

- (NSNumber *)numberStart {
    return (NSNumber *)self.start;
}

- (NSNumber *)numberEnd {
    return (NSNumber *)self.end;
}

- (NSUInteger )length {
    return self.intEnd - self.intStart;
}

- (void)ensureIntegrity {
    
    if ( ! [_start respondsToSelector:@selector(compare:)] ) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"Edges of a range should be comparable" userInfo:nil];
    }
    if ( [_start compare:_end] == NSOrderedDescending ) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The start of the range should be greater than the end" userInfo:nil];
    }
}

- (BOOL )contains:(id)element {
    
    [self ensureIntegrity];
    NSComparisonResult startResult = [_start compare:element];
    NSComparisonResult endResult = [element compare:_end];
    
    return (startResult == NSOrderedSame || startResult == NSOrderedAscending) && 
           (endResult == NSOrderedSame || endResult == NSOrderedAscending);
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@ , %@]", _start, _end];
}

- (BOOL)isEqual:(id)object {
    
    if ( object == nil ) return NO;
    if ( ! [object isKindOfClass:[self class]] ) return NO;
    PSRange *another = (PSRange *)object;
    
    return [self.start isEqual:another.start] && [self.end isEqual:another.end];
}

- (NSUInteger )hash {
    return 10 * [self.start hash] + [self.end hash];
}

@end
