//
//  PSRange.h
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

@import Foundation;

@interface PSRange : NSObject {
    @protected
    id _start;
    id _end;
}

@property (nonatomic, strong) id start;
@property (nonatomic, strong) id end;

@property (nonatomic, readonly) NSUInteger intStart;
@property (nonatomic, readonly) NSUInteger intEnd;
@property (nonatomic, readonly) NSUInteger length;

@property (weak, nonatomic, readonly) NSNumber *numberStart;
@property (weak, nonatomic, readonly) NSNumber *numberEnd;

- (id)initWithStart:(id)start end:(id)end;
- (BOOL )contains:(id)element;

+ (PSRange *)rangeWithStart:(id)start end:(id)end;

@end

NS_INLINE BOOL PSLocationInRange(NSUInteger loc, NSRange range) {
    return (!(loc < range.location) && (loc - range.location) <= range.length) ? YES : NO;
}
