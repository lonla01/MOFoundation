//
//  NSObject+Conveniences.m
//  Parolisse
//
//  Created by Patrice on 24/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
#import "NSArray_Conveniences.h"
#import "PSLogger.h"

@implementation NSData ( Conveniences )

- (id)objectRepresentationOfClass:(Class )aClass {
    
    NSError *error = nil;
    
    id unarchivedObject = [NSKeyedUnarchiver unarchivedObjectOfClass:aClass fromData:self error:&error];
    
    if (error) {
        [self errorFormat:@"Error unarchiving object from data - [%@]", [error localizedDescription]];
    }
    
    return unarchivedObject;
}

@end

@implementation NSObject ( Conveniences )

- (void )touch {}

- (NSString *) pathForResource:(NSString *)name ofType:(NSString *)extension {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    if (path == nil) {
        [self error:[NSString stringWithFormat:@"Unable to find resource: %@.%@", name, extension]];
    }
    
    return path;
}

- (NSURL *)URLForResource:(NSString *)name ofType:(NSString *)extension {
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
    
    if (url == nil) {
        [self error:[NSString stringWithFormat:@"Unable to find resource: %@.%@", name, extension]];
    }
    
    return url;
}

- (NSString *) pathForResource:(NSString *)name ofType:(NSString *)extension inDirectory:(NSString *)directory {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension inDirectory:directory];
        
        if (path == nil) {
            [self debugFormat:@"Main bundle path is %@", [[NSBundle mainBundle] bundlePath]];
                [self error:[NSString stringWithFormat:@"Unable to find resource: %@.%@ in directory: %@", 
                             name, extension, directory]];
        }
        
        return path;
}

- (NSString *)stringContainedInFile:(NSString *)fileName ofType:(NSString *)fileType {
    
    NSString *plistPath = [self pathForResource:fileName ofType:fileType];
    NSData *headingData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *filePath = [[NSString alloc] initWithData:headingData encoding:NSUTF8StringEncoding];
    
    return filePath;
}

- (NSString *) concatDesc:(id)anObject {
    NSMutableString *concat = [[NSMutableString alloc] initWithString:[self description]];
    if ( anObject != nil ) {
         [concat appendString:[anObject description]];
    }   else {
        [concat appendString:@"Nil"];
    }
    
    return concat;
}

- (NSData *)dataFromObject:(id)object {
    return [object dataRepresentation];
}

- (id)objectFromData:(NSData *)data ofClass:(Class )aClass {
    return [data objectRepresentationOfClass:aClass];
}

- (NSData *)dataRepresentation {
    
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:&error];
    
    if (error) {
        [self errorFormat:@"Error archiving object of class:[%@] - [%@]", [self class], [error localizedDescription]];
    }
    
    return data;
    
}

- (NSUserDefaults *)prefs {
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - Collection

- (BOOL)isCollection {
    return [self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]];
}

- (BOOL)isEmptyCollection {
    return [self isCollection] && [(NSArray *)self isEmpty];
}

@end


