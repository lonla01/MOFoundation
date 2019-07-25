//
//  PSStack.h
//  Parolisse
//
//  Created by Patrice on 27/02/13.
//
//

@import Foundation;

@interface PSStack : NSObject

@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, strong) NSArray *storage;
@property (nonatomic, strong) NSURL *persistenceURL;

#pragma mark - Initializing

- (id)initWithPersistenceURL:(NSURL *)anURL;
- (id)initWithCapacity:(NSUInteger )capacity;
- (id)initWithArray:(NSArray *)anArray;

#pragma mark - Accessing

- (void )push:(id)anObject;
- (id )pop;
- (id )peek;

#pragma mark - Filtering

- (PSStack *)subStackWithPredicate:(NSPredicate *)aPredicate;

#pragma mark - Persistence

+ (PSStack *)stackFromURL:(NSURL *)anURL;
- (void)writeToURL:(NSURL *)anURL;
- (void)synchronize;
- (void)clearStorage;

@end
