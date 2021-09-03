//
//  NSObject+Conveniences.h
//  Parolisse
//
//  Created by Patrice on 24/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

@interface NSData ( Conveniences )
- (id)objectRepresentationOfClass:(Class )aClass;
@end

@interface NSObject ( Conveniences ) 

- (void )touch; // Do nothing
- (NSString *) pathForResource:(NSString *)name ofType:(NSString *)extension;
- (NSURL *)URLForResource:(NSString *)name ofType:(NSString *)extension;

// pathForResource sometime returns nil, so this becomes handy
- (NSString *)stringContainedInFile:(NSString *)fileName ofType:(NSString *)fileType;

// Returns a string which is the concatenation of the receiver description and the argument description.
- (NSString *) concatDesc:(id)anObject;
- (NSString *) pathForResource:(NSString *)name ofType:(NSString *)extension inDirectory:(NSString *)directory;

- (NSData *)dataFromObject:(id)properties;
- (id)objectFromData:(NSData *)data;
- (NSData *)dataRepresentation;

- (NSUserDefaults *)prefs;

- (BOOL)isCollection;
- (BOOL)isEmptyCollection;

@end


