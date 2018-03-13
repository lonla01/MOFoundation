//
//  NSArray_Conveniences.h
//  Parolisse
//
//  Created by Patrice on 06/07/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
@import Foundation;
#if TARGET_OS_IPHONE
#else
    @import AppKit.NSTreeNode;
#endif

NSInteger finderSortWithLocale(id string1, id string2, void *locale);

@interface NSArray ( Conveniences ) 

- (id) firstObject;
+ (NSArray *)emptyArray;
- (BOOL)isEmpty;

- (NSUInteger )lastIndex;
- (id)firstObjectOfClass:(Class )aClass;

- (NSSet *)asSet;
- (NSArray *)removeDuplicates;

- (NSArray *)translateWithKey:(NSString *)aKey;
- (NSArray *)translateUsingSelector:(SEL )selector;
- (NSArray *)collectUsingSelector:(SEL)selector withObject:(id)arg;
- (NSArray *)collectUsingSelector:(SEL)selector withTarget:(id)target;
- (NSArray *)sortedStringsWithFinderOptions;
// We create a tree of NSTreeNodes out of a flat list objects and return the root of that tree
#if TARGET_OS_OSX
    - (NSTreeNode *)rootTreeNodeIndexedByKey:(NSString *)aKey;
#endif

- (NSArray *)arrayByRemovingObject:(id)anObject;

@end

@interface NSSet ( Conveniences ) 

+ (NSSet *)emptySet;
- (BOOL)isEmpty;

- (NSSet *)translateUsingSelector:(SEL )selector;
- (NSSet *)collectUsingSelector:(SEL)selector withObject:(id)arg;
- (NSSet *)collectUsingSelector:(SEL)selector withTarget:(id)target;
// We create a tree of NSTreeNodes out of a flat list objects and return the root of that tree
//- (NSTreeNode *)rootTreeNodeIndexedByKey:(NSString *)aKey;
// Do you see this ?

@end
