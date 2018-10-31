//
//  UIView+PSExtensions.m
//  Parolisse
//
//  Created by Serge LONLA on 11/07/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

#import "UIView+PSExtensions.h"
#import "PSLogger.h"

@implementation UIView (PSExtensions)

- (NSString *)debugStringForIndentLevel:(NSUInteger )level {
    NSMutableString *debugString = [NSMutableString string];
    
    for ( NSUInteger i = 0; i < level; i++) {
        [debugString appendString:@" "];
    }
    [debugString appendFormat:@"View = %@ Frame = %@ AR = %d Mask = %d", self, 
     NSStringFromCGRect([self frame]), [self autoresizesSubviews], (int )[self autoresizingMask]];
    for ( UIView *subView in [self subviews] ) {
        [debugString appendString:@"\n"];
        [debugString appendString:[subView debugStringForIndentLevel:(level+1)]];
    }
    
    return debugString;
}


- (void)debugView {    
    [self debug:[NSString stringWithFormat:@"\n%@", [self debugStringForIndentLevel:3]]];
}

- (UIView *)subviewOfClass:(Class )aClass {
    
    UIView *resultView = nil;
    NSArray *subviews = [self subviews];
    
    for ( UIView *aSubView in subviews ) {
        if ( [aSubView isKindOfClass:aClass] ) {
            resultView = aSubView;
            break;
        } else {
            resultView = [aSubView subviewOfClass:aClass];
            if ( resultView == nil ) {
                continue;
            } else {
                break;
            }
        }
    }
    
    return resultView;
}

@end
