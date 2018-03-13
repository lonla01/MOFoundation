//
//  PSTokenizer.h
//  Parolisse
//
//  Created by Serge LONLA on 16/08/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

@import Foundation;

@interface PSTokenizer : NSObject {
    
    NSArray *_components;
    NSString *_separators;
    BOOL _includeSeparators;
    NSUInteger _currentIndex;
    
}

@property (nonatomic, strong) NSArray *components;
@property (nonatomic, copy) NSString *separators;
@property (nonatomic, assign) NSUInteger currentIndex;

- (id)initWithString:(NSString *)string separators:(NSString *)separators;
- (BOOL)hasMoreTokens;
- (NSString *)nextToken;
- (NSUInteger )remainingTokenCount;

@end
