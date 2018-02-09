//
//  NSData+PSCompression.m
//  Librisse
//
//  Created by Serge LONLA on 13/06/12.
//  Copyright (c) 2012 Librisse. All rights reserved.
//

#import "NSData+PSCompression.h"
#import <bzlib.h>
#import <ImageIO/ImageIO.h>

@implementation NSData (PSCompression)
// 
// implementation modified after http://www.cocoadev.com/index.pl?NSDataPlusBzip (removed exceptions)
//

- (NSData *)bzipData;
{
	int compression = 5;
    int bzret, buffer_size = 1000000;
	bz_stream stream = { 0 };
	stream.next_in = (char *)[self bytes];
	stream.avail_in = (int)[self length];
	
	NSMutableData *buffer = [[NSMutableData alloc] initWithLength:buffer_size];
	stream.next_out = [buffer mutableBytes];
	stream.avail_out = buffer_size;
	
	NSMutableData *compressed = [NSMutableData dataWithCapacity:[self length]];
	
	BZ2_bzCompressInit(&stream, compression, 0, 0);
    BOOL hadError = NO;
    do {
        bzret = BZ2_bzCompress(&stream, (stream.avail_in) ? BZ_RUN : BZ_FINISH);
        if (bzret != BZ_RUN_OK && bzret != BZ_STREAM_END) {
            hadError = YES;
            compressed = nil;
        } else {        
            [compressed appendBytes:[buffer bytes] length:(buffer_size - stream.avail_out)];
            stream.next_out = [buffer mutableBytes];
            stream.avail_out = buffer_size;
        }
    } while(bzret != BZ_STREAM_END && NO == hadError);
    
    BZ2_bzCompressEnd(&stream);
    
	return compressed;
}

- (NSData *)bunzipData;
{
	int bzret;
	bz_stream stream = { 0 };
	stream.next_in = (char *)[self bytes];
	stream.avail_in = (int)[self length];
	
	const NSInteger buffer_size = 10000;
	NSMutableData *buffer = [[NSMutableData alloc] initWithLength:buffer_size];
	stream.next_out = [buffer mutableBytes];
	stream.avail_out = buffer_size;
	
	NSMutableData *decompressed = [NSMutableData dataWithCapacity:[self length]];
	
	BZ2_bzDecompressInit(&stream, 0, NO);
    BOOL hadError = NO;
    do {
        bzret = BZ2_bzDecompress(&stream);
        if (bzret != BZ_OK && bzret != BZ_STREAM_END) {
            hadError = YES;
            decompressed = nil;
        } else {        
            [decompressed appendBytes:[buffer bytes] length:(buffer_size - stream.avail_out)];
            stream.next_out = [buffer mutableBytes];
            stream.avail_out = buffer_size;
        }
    } while(bzret != BZ_STREAM_END && NO == hadError);
    
    BZ2_bzDecompressEnd(&stream);
    
	return decompressed;
}

- (BOOL)isBzipData;
{
    static NSData *bzipHeaderData = nil;
    static NSUInteger bzipHeaderDataLength = 0;
    
    if (nil == bzipHeaderData) {
        char *h = "BZh";
        bzipHeaderData = [[NSData alloc] initWithBytes:h length:strlen(h)];
        bzipHeaderDataLength = [bzipHeaderData length];
    }
    
    return [self length] >= bzipHeaderDataLength && 
           [bzipHeaderData isEqual:[self subdataWithRange:NSMakeRange(0, bzipHeaderDataLength)]];
}

- (BOOL)isPlistData;
{
    static NSData *plistHeaderData = nil;
    static NSUInteger plistHeaderDataLength = 0;
    
    if (nil == plistHeaderData) {
        char *h = "bplist00";
        plistHeaderData = [[NSData alloc] initWithBytes:h length:strlen(h)];
        plistHeaderDataLength = [plistHeaderData length];
    }
    
    return [self length] >= plistHeaderDataLength && 
           [plistHeaderData isEqual:[self subdataWithRange:NSMakeRange(0, plistHeaderDataLength)]];
}

@end

#pragma mark - 

#if TARGET_OS_OSX

    @implementation NSData (LSExtensions)

        static NSData *convertTIFFDataToPDF(NSData *tiffData)
        {
            // this should accept any image data types we're likely to run across, but PICT returns a zero size image
            CGImageSourceRef imsrc = CGImageSourceCreateWithData((__bridge CFDataRef)tiffData,
                                                                 (__bridge CFDictionaryRef)@{ (id)kCGImageSourceTypeIdentifierHint : (id)kUTTypeTIFF} );
            
            NSMutableData *pdfData = nil;
            
            if (imsrc && CGImageSourceGetCount(imsrc)) {
                CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imsrc, 0, NULL);
                
                pdfData = [NSMutableData dataWithCapacity:[tiffData length]];
                CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfData);
                
                // create full size image, assuming pixel == point
                const CGRect rect = CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
                
                CGContextRef ctxt = CGPDFContextCreate(consumer, &rect, NULL);
                CGPDFContextBeginPage(ctxt, NULL);
                CGContextDrawImage(ctxt, rect, cgImage);
                CGPDFContextEndPage(ctxt);
                
                CGContextFlush(ctxt);
                
                CGDataConsumerRelease(consumer);
                CGContextRelease(ctxt);
                CGImageRelease(cgImage);
            }
            
            if (imsrc) CFRelease(imsrc);
            
            return pdfData;
        }


        - (NSData *)convertTIFFDataToPDF {
            return convertTIFFDataToPDF( self );
        }

    @end

#endif

