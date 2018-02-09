//
//  LSUtil.m
//  Librisse
//
//  Created by Patrice on 21/02/11.
//  Copyright 2011 Librisse. All rights reserved.
//

#import "LSUtil.h"

NSString *PSAbstractMethodInvocationException = @"PSAbstractMethodInvocationException";

NSRange PSSubstractsRanges(NSRange range1, NSRange range2) {
    
    NSRange intersect = NSIntersectionRange(range1, range2);
    NSRange substration;
    
    if ( NSEqualRanges( intersect, PSRangeZero ) ||
        NSEqualRanges( intersect, range1 ) ) {
        
        substration = range1;
        
    } else {
        
        NSUInteger newLocation = MAX(range1.location, range2.location);
        NSUInteger newLength = NSMaxRange(range1) - newLocation;
        substration = NSMakeRange( newLocation, newLength );
        
    }
    
    
    return substration;
}

@implementation LSUtil



@end
