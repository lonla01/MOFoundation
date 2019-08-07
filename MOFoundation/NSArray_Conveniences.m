//
//  NSArray_Conveniences.m
//  Parolisse
//
//  Created by Patrice on 06/07/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

//#import "Parolisse_Common.h"
//#import "PSHitDescriptor.h"
#import "NSArray_Conveniences.h"
#import "PSLogger.h"
#import "PSAssert.h"

@implementation NSArray ( Conveniences )

- (id)firstObject {
    return [self isEmpty] ? nil : self[0];
}

- (id)firstObjectOfClass:(Class )aClass {
    
    for ( id aMember in self ) {
        if ( [aMember isKindOfClass:aClass] ) {
            return aMember;
        }
    }
    
    return nil;
}

- (BOOL)isEmpty {
        return [self count] == 0;
}

- (NSUInteger )lastIndex {
    return [self count] - 1;
}

+ (NSArray *)emptyArray {
    static NSArray *EmptyArray_;
    
    if ( EmptyArray_ == nil) {
        EmptyArray_ = @[];
    }
    
    return EmptyArray_;
}

- (NSSet *)asSet {
    return [NSSet setWithArray:self];
}

- (NSArray *)removeDuplicates {
    return [[self asSet] allObjects];
}

- (NSArray *)translateWithKey:(NSString *)aKey {
    
    NSMutableArray *translatedArray = [NSMutableArray arrayWithCapacity:[self count]];
    id retValue;
    
    for ( id element in self ) {
        retValue = [element valueForKey:aKey];
        if ( retValue )
            [translatedArray addObject:retValue];
    }
    
    return translatedArray;
}

/**
 * The selector should match a method taking no argument and returning any object.
 * The selector is sent to each element and the resulting objects are collected in
 * an array to get the tranlated array that we return to the caller.
 */
- (NSArray *)translateUsingSelector:(SEL )selector {
    
    NSMutableArray *translatedArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    __unsafe_unretained id retValue;
    __unsafe_unretained id anyElement;
    NSMethodSignature *methodSig;
    
    if ( [self isEmpty] ) return [NSArray emptyArray];
    
    anyElement = [self firstObject];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( id target in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        if ( retValue != nil )
            [translatedArray addObject:retValue];
    }
    
    return translatedArray;
}

/**
 * The selector should match a method taking one argument and returning an array. 
 * The selector is sent to each element and the resulting arrays are unioned in 
 * the collector array and return by this method.
 */
- (NSArray *)collectUsingSelector:(SEL)selector withObject:(__unsafe_unretained id)arg {
    
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    Class arrayClass = [NSArray class];
    __unsafe_unretained NSArray *retValue;
    id anyElement;
    NSMethodSignature *methodSig;
    
    if ( [self isEmpty] ) return [NSArray emptyArray];
    
    anyElement = [self firstObject];
    [self debug:[NSString stringWithFormat:@"anyElement: %@ selector: %@", anyElement, NSStringFromSelector(selector)]];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( id element in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:element];
        if (arg)
            [invocation setArgument:&arg atIndex:2]; // indexes 0 and 1 are target and selector
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        //        [self debug:[NSString stringWithFormat:@"retValue: %@", retValue]];
        [self assertTrue:[retValue isKindOfClass:arrayClass] msg:@"Invalid return class while collecting"];
        [collector addObjectsFromArray:retValue];
    }
    
    return collector;
    
}

- (NSSet *)collectUsingSelector:(SEL)selector withTarget:(id)target {
    
    NSMutableSet *collector = [[NSMutableSet alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    Class arrayClass = [NSArray class];
    __unsafe_unretained NSArray *retValue;
    id anyElement;
    NSMethodSignature *methodSig;
    
    if ( [self isEmpty] ) return [NSSet emptySet];
    
    anyElement = [self firstObject];
    [self debug:[NSString stringWithFormat:@"anyElement: %@ selector: %@", anyElement, NSStringFromSelector(selector)]];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( __unsafe_unretained id element in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation setArgument:&element atIndex:2]; // indexes 0 or 1 are target and selector
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        //        [self debug:[NSString stringWithFormat:@"retValue: %@", retValue]];
        [self assertTrue:[retValue isKindOfClass:arrayClass] msg:@"Invalid return class while collecting"];
        [collector addObjectsFromArray:retValue];
    }
    
    return collector;
}


NSComparisonResult finderSortWithLocale(id string1, id string2, void *locale) {
    
    static NSStringCompareOptions comparisonOptions =
    NSCaseInsensitiveSearch | NSNumericSearch |
    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    
    NSRange string1Range = NSMakeRange(0, [string1 length]);
    
    return [string1 compare:string2
                    options:comparisonOptions
                      range:string1Range
                     locale:(__bridge NSLocale *)locale];
}

- (NSArray *)sortedStringsWithFinderOptions {
    return [self sortedArrayUsingFunction:finderSortWithLocale
                                  context:(__bridge void *)([NSLocale currentLocale])];
}

// We create a tree of NSTreeNodes out of a flat list objects and return the root of that tree
#if TARGET_OS_OSX
    - (NSTreeNode *)rootTreeNodeIndexedByKey:(NSString *)aKey {
        
        NSTreeNode *rootNode = [NSTreeNode treeNodeWithRepresentedObject:@"Root Tree Node"];
        NSMutableDictionary *nodesByType = [NSMutableDictionary dictionaryWithCapacity:[self count]];
        
        for ( NSTreeNode *eachNode in self ) {
            
            NSString *groupingProperty = [eachNode valueForKey:aKey];
            NSTreeNode *parentNode = nodesByType[groupingProperty];
            if ( parentNode == nil ) {
                parentNode = [NSTreeNode treeNodeWithRepresentedObject:eachNode];
                nodesByType[groupingProperty] = parentNode;
                [[rootNode mutableChildNodes] addObject:parentNode];
            }
            NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:eachNode];
            [[parentNode mutableChildNodes] addObject:childNode];
            
        }
        
        return rootNode;
    }
#endif

- (NSArray *)arrayByRemovingObject:(id)anObject {
    
    __block NSMutableArray *result = [NSMutableArray new];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ( obj != self ) {
            [result addObject:obj];
        }
    }];
    
    return result;
    
}

- (NSNumber *)sumOfObjects {
    
    __block NSInteger sum = 0;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *number = (NSNumber *)obj;
        if ( obj != self ) {
            sum += [number integerValue];
        }
    }];
    
    return @(sum);
    
}

@end

#pragma mark -

@implementation NSSet ( Conveniences )

- (BOOL)isEmpty {
        return [self count] == 0;
}

+ (NSSet *)emptySet {
        static NSSet *EmptySet_;
        
        if ( EmptySet_ == nil) {
                EmptySet_ = [NSSet set];
        }
        
        return EmptySet_;
}

- (NSSet *)translateUsingSelector:(SEL )selector {
    
    NSMutableSet *translatedArray = [[NSMutableSet alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    __unsafe_unretained id retValue;
    __unsafe_unretained id anyElement;
    NSMethodSignature *methodSig;
    
    anyElement = [self anyObject];
    [self debug:[NSString stringWithFormat:@"anyElement: %@ selector: %@", [anyElement className], NSStringFromSelector(selector)]];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( id target in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        if ( retValue != nil )
            [translatedArray addObject:retValue];
    }
    
    //    [self debug:[NSString stringWithFormat:@"translatedArray: %@", translatedArray]];
    
    return translatedArray;
}

- (NSSet *)collectUsingSelector:(SEL)selector withObject:(__unsafe_unretained id)arg {
    
    NSMutableSet *collector = [[NSMutableSet alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    Class arrayClass = [NSArray class];
    __unsafe_unretained NSArray *retValue;
    id anyElement;
    NSMethodSignature *methodSig;
    
    if ( [self isEmpty] ) return [NSSet emptySet];
    
    anyElement = [self anyObject];
    [self debug:[NSString stringWithFormat:@"anyElement: %@ selector: %@", anyElement, NSStringFromSelector(selector)]];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( id element in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:element];
        [invocation setArgument:&arg atIndex:2]; // indexes 0 or 1 are target and selector
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        //        [self debug:[NSString stringWithFormat:@"retValue: %@", retValue]];
        [self assertTrue:[retValue isKindOfClass:arrayClass] msg:@"Invalid return class while collecting"];
        [collector addObjectsFromArray:retValue];
    }
    
    return collector;
}

- (NSSet *)collectUsingSelector:(SEL)selector withTarget:(id)target {
    
    NSMutableSet *collector = [[NSMutableSet alloc] initWithCapacity:[self count]];
    NSInvocation *invocation;
    Class arrayClass = [NSArray class];
    __unsafe_unretained NSArray *retValue;
    id anyElement;
    NSMethodSignature *methodSig;
    
    if ( [self isEmpty] ) return [NSSet emptySet];
    
    anyElement = [self anyObject];
    [self debug:[NSString stringWithFormat:@"anyElement: %@ selector: %@", anyElement, NSStringFromSelector(selector)]];
    methodSig = [anyElement methodSignatureForSelector:selector];
    invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    for ( __unsafe_unretained id element in self ) {
        [invocation setSelector:selector];
        [invocation setTarget:target];
        [invocation setArgument:&element atIndex:2]; // indexes 0 or 1 are target and selector
        [invocation invoke];
        [invocation getReturnValue:&retValue];
        //        [self debug:[NSString stringWithFormat:@"retValue: %@", retValue]];
        [self assertTrue:[retValue isKindOfClass:arrayClass] msg:@"Invalid return class while collecting"];
        [collector addObjectsFromArray:retValue];
    }
    
    return collector;
}

#if TARGET_OS_OSX
    // We create a tree of NSTreeNodes out of a flat list objects and return the root of that tree
    - (NSTreeNode *)rootTreeNodeIndexedByKey:(NSString *)aKey {
        
        NSTreeNode *rootNode = [NSTreeNode treeNodeWithRepresentedObject:@"Root Tree Node"];
        NSMutableDictionary *nodesByType = [NSMutableDictionary dictionaryWithCapacity:[self count]];
        
        for ( NSTreeNode *eachNode in self ) {
            
            NSString *groupingProperty = [eachNode valueForKey:aKey];
            NSTreeNode *parentNode = nodesByType[groupingProperty];
            if ( parentNode == nil ) {
                parentNode = [NSTreeNode treeNodeWithRepresentedObject:eachNode];
                nodesByType[groupingProperty] = parentNode;
                [[rootNode mutableChildNodes] addObject:parentNode];
            }
            NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:eachNode];
            [[parentNode mutableChildNodes] addObject:childNode];
            
        }
        
        return rootNode;
}
#endif




@end

