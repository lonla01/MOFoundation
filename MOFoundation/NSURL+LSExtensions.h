//
//  NSURL+LSExtensions.h
//  Librisse
//
//  Created by Patrice on 03/09/13.
//  Copyright (c) 2013 Librisse. All rights reserved.
//

@import Foundation;
#if TARGET_OS_IPHONE
#else
@import AppKit;
#endif

@interface NSURL (LSExtensions)

- (NSString *)pathByReplacingExtensionBy:(NSString *)ext;

- (NSURL *)URLByReplacingExtensionBy:(NSString *)ext;

//+ (BOOL)canReadURLFromPasteboard:(NSPasteboard *)pboard;
//
//+ (NSArray *)readURLsFromPasteboard:(NSPasteboard *)pboard ;
//
//+ (BOOL)canReadFileURLFromPasteboard:(NSPasteboard *)pboard;

//- (NSString *)urlUTIType;
//
//- (BOOL)isImageURL;
//
//- (BOOL)isFolderURL;
//
//- (BOOL )zipFile;
//- (NSURL *)zippedURL;
//
//- (BOOL )unzipFile;

@end
