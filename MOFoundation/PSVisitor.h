//
//  PSVisitor.h
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

@import Foundation;

@interface PSVisitor : NSObject {
    id _result;
}

@property (nonatomic, strong) id result;
@property (weak, nonatomic, readonly) NSMutableString *stringResult;
@property (weak, nonatomic, readonly) NSMutableArray *arrayResult;
@property (weak, nonatomic, readonly) NSMutableSet *setResult;
@property (weak, nonatomic, readonly) NSNumber *numberResult;

- (id)initWithResult:(id)result;
- (void)resetState;
- (void)visitMe:(id)host;

@end
