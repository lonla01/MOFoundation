//
//  NSManagedObjectContext+Conveniences.h
//  Parolisse
//
//  Created by Serge LONLA on 31/05/12.
//  Copyright (c) 2012 Softisse S.A.R.L.. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Conveniences)

- (void)saveChanges;
- (NSManagedObject *)objectFromUniqueIdentifier:(NSString *)uniqueId;

@end
