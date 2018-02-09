//
//  PSVisitor.m
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

#import "PSVisitor.h"
#import "LSUtil.h"
#import "PSLogger.h"

@implementation PSVisitor

@synthesize result = _result;

- (id)initWithResult:(id)result {
    
    if (( self = [super init] )) {
        self.result = result;
    }
    
    return self;
}


- (void)resetState { self.result = nil; }

- (void)visitMe:(id)host {
    
    if ( host == nil ) {
        [self error:@"Cannot visit <nil> host"];
        return;
    }
    @throw [NSException exceptionWithName:PSAbstractMethodInvocationException reason:NSStringFromSelector(_cmd) userInfo:nil]; 
}

- (NSMutableString *)stringResult {
    return (NSMutableString *)self.result;
}

- (NSNumber *)numberResult {
    return (NSNumber *)self.result;
}

- (NSMutableArray *)arrayResult {
    return (NSMutableArray *)self.result;
}

- (NSMutableSet *)setResult {
    return (NSMutableSet *)self.result;
}

@end
