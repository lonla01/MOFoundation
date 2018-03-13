//
//  NSError_Conveniences.m
//  Librisse
//
//  Created by Serge LONLA on 19/11/11.
//  Copyright 2011 Librisse. All rights reserved.
//

#import <Foundation/NSException.h>
#import "NSError_Conveniences.h"
#import "PSLogger.h"
#if TARGET_OS_OSX
    #import <AppKit/NSAlert.h>
#endif

// A string constant declared in the header.
NSString *LSErrorDomain = @"com.Librisse.ErrorDomain";
NSString *LSSystemErrorDomain = @"com.Librisse.system.ErrorDomain";
static NSUInteger LSPosixOffset = 1000;
static NSString *LSErrorFile = @"LSErrorMessages";
static NSString *LSExceptionName = @"LSExceptionName";

@implementation NSError ( Conveniences )

+ (NSDictionary *)userInfoWithCode:(NSUInteger )code descriptionValue:(NSString *)descValue {
    
    // An NSError has a bunch of parameters that determine how it's presented to the user. We specify two of them here. They're localized strings that we look up in LSErrorMessages.strings, whose keys are derived from the error code and an indicator of which kind of localized string we're looking up. The value: strings are specified so that at least something is shown if there's a problem with the strings file, but really they should never ever be shown to the user. When testing an app like Librisse you really have to make sure that you've seen every call of LSErrorWithCode() executed since the last time you did things like change the set of available error codes or edit the strings files.
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *description = [NSString stringWithFormat:@"description%ld", (long)code];
    NSString *failureReason = [NSString stringWithFormat:@"failureReason%ld", (long)code];
    NSString *failureValue = @"An unknown error occurred.";
    NSString *localizedDescription;
    NSString *localizedFailureReason;
    NSDictionary *errorUserInfo;
    
    if (descValue == nil) {
        descValue = @"Librisse could not complete the operation because an unknown error occurred.";
    }
    
    localizedDescription = [mainBundle localizedStringForKey:description value:descValue table:LSErrorFile];
    localizedFailureReason = [mainBundle localizedStringForKey:failureReason value:failureValue table:LSErrorFile];
    errorUserInfo = @{NSLocalizedDescriptionKey: localizedDescription, NSLocalizedFailureReasonErrorKey: localizedFailureReason};
    
    return errorUserInfo;
    
}

+ (NSDictionary *)userInfoWithCode:(NSUInteger )code {
    
    return [self userInfoWithCode:code descriptionValue:nil];
    
}

+ (NSDictionary *)userInfoWithException:(NSException *)exception {
    
    NSMutableDictionary *excUserInfo = [[self userInfoWithCode:6 descriptionValue:[exception description]] mutableCopy];
    NSString *excName = [exception name];
    
    if (excName) excUserInfo[LSExceptionName] = excName;
    
    return excUserInfo;
    
}

+ (NSDictionary *)userInfoForPath:(NSString *)path desc:(NSString *)desc code:(NSUInteger )code {
    
    NSMutableDictionary *fileUserInfo = [[self userInfoWithCode:code] mutableCopy];
    
    if (path)
        fileUserInfo[NSFilePathErrorKey] = path;
    if (desc)
        fileUserInfo[NSLocalizedDescriptionKey] = desc;
    
    return fileUserInfo;
}

+ (NSError *)errorWithCode:(NSInteger )code {
    
    // In Librisse we know that no one's going to be paying attention to the domain and code that we use here, but still we don't specify junk values. Certainly we don't just use NSCocoaErrorDomain and some random error code.
    return [NSError errorWithDomain:LSErrorDomain code:code userInfo:[self userInfoWithCode:code]];
    
}

+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *localUserInfo;
    
    localUserInfo = [[self userInfoWithCode:code] mutableCopy];
    [localUserInfo addEntriesFromDictionary:userInfo];
    
    return [NSError errorWithDomain:LSErrorDomain code:code userInfo:localUserInfo];
}

+ (NSError *)errorWithCode:(NSInteger )code error:(NSError *)error {
    
    NSMutableDictionary *userInfo = [[self userInfoWithCode:code] mutableCopy];
    
    if ( error ) userInfo[NSUnderlyingErrorKey] = error;
    
    return [NSError errorWithDomain:LSErrorDomain code:code userInfo:userInfo];
    
}

+ (NSError *)errorWithException:(NSException *)exception {
    
    return [NSError errorWithDomain:LSErrorDomain code:LSFatalError userInfo:[self userInfoWithException:exception]];
    
}

+ (NSError *)posixErrorWithCode:(NSInteger )code filePath:(NSString *)path {
    return [NSError errorWithDomain:NSPOSIXErrorDomain code:code 
                           userInfo:[self userInfoForPath:path desc:nil 
                                                     code:(code+LSPosixOffset)]];
}

+ (NSError *)posixErrorWithCode:(NSInteger )code desc:(NSString *)desc {
    return [NSError errorWithDomain:NSPOSIXErrorDomain code:code 
                           userInfo:[self userInfoForPath:nil desc:desc 
                                                     code:(code+LSPosixOffset)]];
}


+ (id)userCancelledErrorWithUnderlyingError:(NSError *)error {
    return [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:@{NSUnderlyingErrorKey: error}];
}

+ (NSError *)systemErrorWithCode:(NSInteger)code filePath:(NSString *)path desc:desc {
    return [NSError errorWithDomain:LSSystemErrorDomain code:code userInfo:[self userInfoForPath:path desc:desc code:code]];
}

NSString *LSPosixLocalizedString( NSString *message, NSString *comment ) {
    return NSLocalizedStringFromTable( message, @"LSPosixErrors", comment );
}

- (BOOL )isIgnorablePOSIXError {
    if ( [[self domain] isEqualToString:NSPOSIXErrorDomain] ) {
        return  [self code] == ENOATTR || [self code] == ENOTSUP || 
                [self code] == EINVAL  || [self code] == EPERM   || [self code] == EACCES;
    } else {        
        return NO;
    }
}

#pragma mark - Extensions

+ (id)writeFileErrorWithLocalizedDescription:(NSString *)description {
    return [NSError errorWithDomain:LSErrorDomain code:LSFileWriteError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

+ (id)readFileErrorWithLocalizedDescription:(NSString *)description {
    return [NSError errorWithDomain:LSErrorDomain code:LSFileReadError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

+ (id)readPasteboardErrorWithLocalizedDescription:(NSString *)description {
    return [NSError errorWithDomain:LSErrorDomain code:LSPasteboardReadError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

+ (id)printDocumentErrorWithLocalizedDescription:(NSString *)description {
    return [NSError errorWithDomain:LSErrorDomain code:LSDocumentPrintError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey, nil]];
}

- (BOOL)isUserCancelledError {
    return [[self domain] isEqualToString:NSCocoaErrorDomain] && [self code] == NSUserCancelledError;
}

#pragma mark - Convenience

#if TARGET_OS_OSX

    - (void)ensureFileWriteSuccess:(BOOL)writeSuccess {
        if ( writeSuccess == NO ) {
            [self error:@"Error writing to file" err:[NSError errorWithCode:4 error:self]];
        }
    }

    + (void)checkFileOperationSuccess:(BOOL)writeSuccess error:(NSError *)error errMsg:(NSString *)errMsg {
        if ( writeSuccess == NO ) {
            NSError *error;
            [self error:errMsg err:[NSError errorWithCode:4 error:error]];
            error = [NSError errorWithCode:4 error:error];
            [error presentAlertWithCode:4];
        }
    }



    - (void)presentAlertWithCode:(NSUInteger)code {
        
        NSError *wrapperError = [NSError errorWithCode:code error:self];
        NSAlert *alert = [[NSAlert alloc] init];
        
        alert.messageText = wrapperError.localizedDescription;
        alert.informativeText = wrapperError.localizedFailureReason;
        [alert runModal];
        
    }

    - (void)presentAlertWithCode:(NSUInteger)code inWindow:(NSWindow *)window {
        
        NSError *wrapperError = [NSError errorWithCode:code error:self];
        NSAlert *alert = [[NSAlert alloc] init];
        
        alert.messageText = wrapperError.localizedDescription;
        alert.informativeText = wrapperError.localizedFailureReason;
//        [alert beginSheetModalForWindow:window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            ;
        }];
        
    }

#endif

@end
