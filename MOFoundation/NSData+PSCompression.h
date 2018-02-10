//
//  NSData+Compression.h
//  Librisse
//
//  Created by Serge LONLA on 13/06/12.
//  Copyright (c) 2012 Librisse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (PSCompression)

- (NSData *)bzipData;
- (NSData *)bunzipData;
- (BOOL)isBzipData;
- (BOOL)isPlistData;


@end

#if TARGET_OS_OSX

    @interface NSData (LSExtensions)

    - (NSData *)convertTIFFDataToPDF;

    @end

#endif
