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
    
    NSString *errorStr = nil;
    id properties = value;
    NSData *data;
    
    if ( properties == nil ) return nil;
    
    data = [NSPropertyListSerialization dataFromPropertyList:properties
                                                      format:NSPropertyListBinaryFormat_v1_0
                                            errorDescription:&errorStr];
    if ( errorStr != nil ) {
        [self errorFormat:@"Error in transformer:[%@]", errorStr];
    }
    data = [data bzipData];
        
    return data;
}

- (id)reverseTransformedValue:(id)value {
    
    NSString *errorStr = nil;
    NSData *data = value;
    NSObject *reverseValue = nil;
    NSPropertyListFormat format;
    
    data = [data bunzipData];
    reverseValue = [NSPropertyListSerialization propertyListFromData:data 
                                                    mutabilityOption:NSPropertyListMutableContainers 
                                                              format:&format 
                                                    errorDescription:&errorStr];
    
    if ( errorStr != nil ) {
        [self errorFormat:@"Error in reverse transformer:[%@]", errorStr];
    }
    
//    [self debugFormat:@"Decompressed: %@", reverseValue];
    
    return reverseValue;
}

@end

@implementation PSHitToDataTransformer

- (id)transformedValue:(id)value {
    
    NSString *errorStr = nil;
    NSData *data;
    
    if ( value == nil ) return nil;
    
    @autoreleasepool {
        
        if ( [value isKindOfClass:[NSSet class]] ) {
            value = [[PSCompactor alloc] initWithArray:[(NSSet *)value allObjects]];
            [value prepareForStorage];
        }
        
        data = [NSPropertyListSerialization dataFromPropertyList:value
                                                          format:NSPropertyListBinaryFormat_v1_0
                                                errorDescription:&errorStr];
        if ( errorStr != nil ) {
            [self errorFormat:@"Error in transformer:[%@]", errorStr];
        }
        data = [data bzipData];
        
    }
    
    return data;
}

- (id)reverseTransformedValue:(id)value {
    
    NSString *errorStr = nil;
    NSData *data = value;
    NSObject *reverseValue = nil;
    NSPropertyListFormat format;
    PSCompactor *compactor;
    
    @autoreleasepool {
        
        data = [data bunzipData];
        reverseValue = [NSPropertyListSerialization propertyListFromData:data
                                                        mutabilityOption:NSPropertyListMutableContainers
                                                                  format:&format
                                                        errorDescription:&errorStr];
        
        if ( errorStr != nil ) {
            [self errorFormat:@"Error in reverse transformer:[%@]", errorStr];
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
