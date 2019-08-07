//
//  PSStack.m
//  Parolisse
//
//  Created by Patrice on 27/02/13.
//
//

#import "PSStack.h"
#import "NSArray_Conveniences.h"

/**
 * This seam to be a LIFO stack
 */
@implementation PSStack {
    NSMutableArray *_storage;
}

@synthesize storage = _storage;

- (id)init {
    return [self initWithCapacity:30];
}

- (id)initWithPersistenceURL:(NSURL *)anURL {
    
    if (( self = [self init] )) {
        self.persistenceURL = anURL;
    }
    
    return self;
}

- (id)initWithCapacity:(NSUInteger )capacity {
    
    if (( self = [super init] )) {
        // The minimum capacity is 10
        if ( capacity < 10 ) capacity = 10;
        _storage = [[NSMutableArray alloc] initWithCapacity:capacity];
        self.capacity = capacity;
    }
    
    return self;
}

- (id)initWithArray:(NSArray *)anArray {
    
    if (( self = [self init] )) {
        _storage = [anArray mutableCopy];
    }
    
    return self;
}

- (void)push:(id)anObject {
    [_storage addObject:anObject];
}

- (id)pop {
    
    if ( [_storage count] > self.capacity ) {
        [_storage removeObjectAtIndex:0];
    }
    id anObject = [_storage lastObject];
    [_storage removeLastObject];
    
    return anObject;
    
}

- (id )peek {
    // Says if there something left to pop in the stack and returns it
    id result = ([_storage isEmpty]) ? nil : [_storage lastObject];
    return result;
}

- (void)clearStorage {
    [(NSMutableArray *)self.storage removeAllObjects];
    [self synchronize];
}

#pragma mark - Filtering

- (PSStack *)subStackWithPredicate:(NSPredicate *)aPredicate {
    
    NSArray *filteredStorage = [self.storage filteredArrayUsingPredicate:aPredicate];
    PSStack *subStack = [[[self class] alloc] initWithArray:filteredStorage];
    
    return subStack;
    
}

#pragma mark - Persistence

+ (PSStack *)stackFromURL:(NSURL *)anURL {
    
    NSArray *deserializedArray = [[NSArray alloc] initWithContentsOfURL:anURL];
    PSStack *deserializedStack;
    
    if ( deserializedArray == nil ) {
        deserializedArray = [NSMutableArray new];
    }
    deserializedStack = [[self alloc] initWithArray:deserializedArray];
    deserializedStack.persistenceURL = anURL;
    
    return deserializedStack;
    
}

- (void)synchronize {
    [self writeToURL:self.persistenceURL];
}

- (void)writeToURL:(NSURL *)anURL {
    [_storage writeToURL:anURL atomically:YES];
}

@end
