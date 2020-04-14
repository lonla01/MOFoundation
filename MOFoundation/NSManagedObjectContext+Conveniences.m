//
//  NSManagedObjectContext+Conveniences.m
//  Parolisse
//
//  Created by Serge LONLA on 31/05/12.
//  Copyright (c) 2012 Softisse S.A.R.L.. All rights reserved.
//

#import "NSManagedObjectContext+Conveniences.h"
#import "PSLogger.h"
#import "PSAssert.h"

@implementation NSManagedObjectContext (Conveniences)

- (void)saveChanges {
    
    NSError *error = nil;
//    NSInteger insertCount = [[self insertedObjects] count];
//    NSInteger deleteCount = [[self deletedObjects] count];
//    NSInteger updatedCount = [[self updatedObjects] count];
    
    // We wrap the save in and autorelease pool to get rid of all the NSConcreteMutableData created by the transformer.
    @autoreleasepool {
    
        //[self debugFormat:@"Performing save operation..."];
        if ( ! [self hasChanges] ) return;
        if ( ! [self save: &error] ) { 
            [self error:@"Error while saving" err:error];
            exit(1);
        }
        
    }
//    [self debug:[NSString stringWithFormat:@"Changes saved successfully. (i, d, u) = [%ld, %ld, %ld] ",
//                 (long)insertCount, (long)deleteCount, (long)updatedCount]];
}

- (NSManagedObject *)objectFromUniqueIdentifier:(NSString *)uniqueId {
    
    NSURL *objectURL;
    NSString *objectURI;
    NSManagedObject *aManagedObject;
    NSManagedObjectID *objectID;
    
    @try {
        objectURI = uniqueId;
        objectURL = [NSURL URLWithString:objectURI];
        objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:objectURL];
        aManagedObject = [self objectWithID:objectID];
    }
    @catch (id exception) {
        aManagedObject = nil;
        [self errorFormat:@"Unable to resolve URI: %@", objectURL];
        return nil;
    }
    
    return aManagedObject;
}

@end
