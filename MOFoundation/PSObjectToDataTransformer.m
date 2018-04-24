//
//  PSObjectToDataTransformer.m
//  Librisse
//
//  Created by Serge LONLA on 13/06/12.
//  Copyright (c) 2012 Librisse. All rights reserved.
//

#import "PSObjectToDataTransformer.h"
#import "PSHitDescriptor.h"

NSString *PSObjectToDataTransformerName = @"PSObjectToDataTransformerName";
NSString *PSHitToDataTransformerName = @"PSHitToDataTransformerName";

@implementation PSObjectToDataTransformer

+ (Class)transformedValueClass { return [NSData class]; }

+ (BOOL)allowsReverseTransformation { return YES; }

- (id)transformedValue:(id)value {
    
    NSError *error = nil;
    id properties = value;
    NSData *data;
    
    if ( properties == nil ) return nil;
    
//    data = [NSPropertyListSerialization dataFromPropertyList:properties
//                                                      format:NSPropertyListBinaryFormat_v1_0
//                                            errorDescription:&errorStr];
    data = [NSPropertyListSerialization dataWithPropertyList:properties format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    if ( error != nil ) {
        [self errorFormat:@"Error in transformer:[%@]", [error localizedDescription]];
    }
    data = [data bzipData];
        
    return data;
}

- (id)reverseTransformedValue:(id)value {
    
    NSError *error = nil;
    NSData *data = value;
    NSObject *reverseValue = nil;
    NSPropertyListFormat format;
    
    data = [data bunzipData];
    reverseValue = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:&format error:&error];
    if ( error != nil ) {
        [self errorFormat:@"Error in reverse transformer:[%@]", [error localizedDescription]];
    }
    
//    [self debugFormat:@"Decompressed: %@", reverseValue];
    
    return reverseValue;
}

@end

@implementation PSHitToDataTransformer

- (id)transformedValue:(id)value {
    
    NSError *error = nil;
    NSData *data;
    
    if ( value == nil ) return nil;
    
    @autoreleasepool {
        
        if ( [value isKindOfClass:[NSSet class]] ) {
            value = [[PSCompactor alloc] initWithArray:[(NSSet *)value allObjects]];
            [value prepareForStorage];
        }
        
        data = [NSPropertyListSerialization dataWithPropertyList:value format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
        if ( error != nil ) {
            [self errorFormat:@"Error in transformer:[%@]", [error localizedDescription]];
        }
        data = [data bzipData];
        
    }
    
    return data;
}

- (id)reverseTransformedValue:(id)value {
    
    NSError *error = nil;
    NSData *data = value;
    NSObject *reverseValue = nil;
    NSPropertyListFormat format;
    PSCompactor *compactor;
    
    @autoreleasepool {
        
        data = [data bunzipData];
        reverseValue = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:&format error:&error];
        if ( error != nil ) {
            [self errorFormat:@"Error in reverse transformer:[%@]", [error localizedDescription]];
        }
        
        if ( ! [reverseValue isKindOfClass:[NSArray class]] ) {
            // We expect reverseValue to contain an array of compound strings
            [self errorFormat:@"Expecting value of NSArray class. Got: %@", [reverseValue className]];
        }
        
        compactor = [[PSCompactor alloc] initWithArray:(NSArray *)reverseValue];
        [compactor awakeFromStorage];
        
    }
    
    return compactor;
}


@end
