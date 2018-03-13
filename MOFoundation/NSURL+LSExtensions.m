//
//  NSURL+LSExtensions.m
//  Librisse
//
//  Created by Patrice on 03/09/13.
//  Copyright (c) 2013 Librisse. All rights reserved.
//

#import "NSURL+LSExtensions.h"
@import Foundation;
//#if TARGET_OS_IPHONE
//@import UIKit;
//#else
//@import AppKit;
//#endif

@implementation NSURL (LSExtensions)

- (NSString *)pathByReplacingExtensionBy:(NSString *)ext {
    return [[[self path] stringByDeletingPathExtension] stringByAppendingPathExtension:ext];
}

- (NSURL *)URLByReplacingExtensionBy:(NSString *)ext {
    return [[self URLByDeletingPathExtension] URLByAppendingPathExtension:ext];
}


//+ (BOOL)canReadURLFromPasteboard:(NSPasteboard *)pboard {
//    
//    return 
//    [pboard canReadObjectForClasses:@[[NSURL class]] options:@{}] ||
//    [pboard canReadItemWithDataConformingToTypes:@[NSURLPboardType, NSFilenamesPboardType]];
//     
//}
//
//+ (NSArray *)readURLsFromPasteboard:(NSPasteboard *)pboard {
//    
//    NSArray *URLs = [pboard readObjectsForClasses:@[[NSURL class]] options:@{}];
//    
//    if ( [URLs isEmpty] ) {
//        
//        NSString *type = [pboard availableTypeFromArray:@[NSURLPboardType, NSFilenamesPboardType]];
//        
//        if ([type isEqualToString:NSURLPboardType]) {
//            URLs = [NSArray arrayWithObjects:[NSURL URLFromPasteboard:pboard], nil];
//        } else if ([type isEqualToString:NSFilenamesPboardType]) {
//            
//            NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
//            
//            if ([filenames count]  > 0) {
//                NSMutableArray *files = [NSMutableArray array];
//                for (NSString *filename in filenames) {
//                    [files addObject:[NSURL fileURLWithPath:[filename stringByExpandingTildeInPath]]];
//                }
//                URLs = files;
//                
//            }
//            
//        }
//        
//    }
//    
//    return URLs;
//    
//}
//
//+ (BOOL)canReadFileURLFromPasteboard:(NSPasteboard *)pboard {
//    
//    return
//    [pboard canReadObjectForClasses:@[[NSURL class]] options:@{ NSPasteboardURLReadingFileURLsOnlyKey : @YES }] ||
//    [pboard canReadItemWithDataConformingToTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
//    
//}
//
//+ (NSArray *)readFileURLsFromPasteboard:(NSPasteboard *)pboard {
//    
//    NSArray *fileURLs = [pboard readObjectsForClasses:@[[NSURL class]] options:@{ NSPasteboardURLReadingFileURLsOnlyKey : @YES }];
//    
//    if ( [fileURLs count] == 0 && [[pboard types] containsObject:NSFilenamesPboardType] ) {
//        
//        NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
//        
//        if ([filenames count]  > 0) {
//            
//            NSMutableArray *files = [NSMutableArray array];
//            for (NSString *filename in filenames) {
//                [files addObject:[NSURL fileURLWithPath:[filename stringByExpandingTildeInPath]]];
//            }
//            fileURLs = files;
//            
//        }
//        
//    }
//    
//    return fileURLs;
//}

- (NSString *)urlUTIType {
    
    NSString *urlUTI;
    BOOL result = NO;
    
    result = [self getResourceValue:&urlUTI forKey:NSURLTypeIdentifierKey error:NULL];
    
    return (result) ? urlUTI : nil;
        
}

//- (BOOL)isImageURL {
//    
//    NSString *urlUTI;
//    BOOL result = NO;
//    
//    if ( [self getResourceValue:&urlUTI forKey:NSURLTypeIdentifierKey error:NULL] ) {
//        // We could use UTTypeConformsTo((CFStringRef)type, kUTTypeImage), but we want to make sure it is an image UTI type that NSImage can handle
//        if ( [[NSImage imageTypes] containsObject:urlUTI] ) {
//            // We can use it with NSImage
//            result = YES;
//        } 
//    }
//    
//    return result;
//    
//}
//
//- (BOOL)isFolderURL {
//    
//    NSString *urlUTI;
//    BOOL result = NO;
//    
//    if ([self getResourceValue:&urlUTI forKey:NSURLTypeIdentifierKey error:NULL]) {
//        // We could use UTTypeConformsTo((CFStringRef)type, kUTTypeImage), but we want to make sure it is an image UTI type that NSImage can handle
//        if ([urlUTI isEqualToString:(id)kUTTypeFolder]) {
//            // It is a folder
//            result = YES;
//        }
//    }
//    
//    return result;
//    
//}
//
//- (BOOL )unzipFile {
//    
//    NSString* zipPath = [self lastPathComponent];    
//    NSString* targetFolder = [[self URLByDeletingLastPathComponent] path];
//    NSArray *arguments = [NSArray arrayWithObject:zipPath];
//    NSTask *myTask = [[NSTask alloc] init];
//    
//    [myTask setLaunchPath:@"/usr/bin/unzip"];
//    [myTask setCurrentDirectoryPath:targetFolder];
//    [myTask setArguments:arguments];
//    [myTask launch];
//    [myTask waitUntilExit]; //remove this to start the task concurrently
//    int status = [myTask terminationStatus];
//    
//    return (status == 0);
//    
//}
//
//- (NSURL *)zippedURL {
//    return [self URLByAppendingPathExtension:@"zip"];
//}
//
//- (BOOL )zipFile {
//    
//    NSString *inPath = [self lastPathComponent];
//    NSString *outpath = [inPath stringByAppendingPathExtension:@"zip"];
//    NSString* targetFolder = [[self URLByDeletingLastPathComponent] path];
//    NSArray *arguments = @[@"-rq", outpath, inPath];
//    NSTask *myTask = [[NSTask alloc] init];
//    
//    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:[self path]] ) {
//        [self errorFormat:@"Zip failed. File does not exit: %@", [self path]];
//        return NO;
//    }
//    
//    [myTask setLaunchPath:@"/usr/bin/zip"];
//    [myTask setCurrentDirectoryPath:targetFolder];
//    [myTask setArguments:arguments];
//    [myTask launch];
//    [myTask waitUntilExit]; //remove this to start the task concurrently
//    int status = [myTask terminationStatus];
//    
//    return (status == 0);
//    
//}


@end
