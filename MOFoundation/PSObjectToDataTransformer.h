//
//  PSObjectToDataTransformer.h
//  Librisse
//
//  Created by Serge LONLA on 13/06/12.
//  Copyright (c) 2012 Librisse. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *PSObjectToDataTransformerName;
extern NSString *PSHitToDataTransformerName;

@interface PSObjectToDataTransformer : NSValueTransformer

@end

@interface PSHitToDataTransformer : PSObjectToDataTransformer

@end
