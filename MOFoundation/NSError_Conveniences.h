//
//  NSError_Conveniences.h
//  Librisse
//
//  Created by Serge LONLA on 19/11/11.
//  Copyright 2011 Librisse. All rights reserved.
//

@import Foundation;

// Librisse establishes its own error domain, and some errors in that domain.
//extern NSString *LSErrorDomain;

extern NSString *LSErrorDomain;
extern NSString *LSPosixLocalizedString( NSString *message, NSString *comment );

enum {
    LSFileReadError = 1,
    LSPasteboardReadError = 2,
    LSTIFFWriteError = 3,
    LSFileWriteError = 4,
    LSUnarchiveError = 5,
    LSFatalError = 6,
    LSDocumentPrintError = 7,
    LSDocumentExportError = 8,
    LSDocumentEmailError = 9,
    LSDocumentOpenInWordError = 10,
    LSAppleScriptCompileError = 50,
    LSAppleScriptExecuteError = 51,
    LSSecurityAuthorizationError = 100,
    LSSecurityLibraryInsertionError = 101,
    LSSecurityBookmarkCreationError = 102
};
typedef NSUInteger LSErrorCodeType;

@interface NSError ( Conveniences )

// Application Level Errors
+ (NSError *)errorWithCode:(NSInteger )code;
+ (NSError *)errorWithCode:(NSInteger )code error:(NSError *)error;
+ (NSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
+ (NSError *)errorWithException:(NSException *)exception;
+ (NSError *)systemErrorWithCode:(NSInteger )code filePath:(NSString *)path desc:errorString;
+ (id)userCancelledErrorWithUnderlyingError:(NSError *)error;

/// Low Level Errors
+ (NSError *)posixErrorWithCode:(NSInteger )err desc:(NSString *)desc;
+ (NSError *)posixErrorWithCode:(NSInteger )err filePath:(NSString *)path;
- (BOOL )isIgnorablePOSIXError;

/// Other Extensions
+ (id)writeFileErrorWithLocalizedDescription:(NSString *)description;
+ (id)readFileErrorWithLocalizedDescription:(NSString *)description;
+ (id)readPasteboardErrorWithLocalizedDescription:(NSString *)description;
+ (id)printDocumentErrorWithLocalizedDescription:(NSString *)description;
- (BOOL)isUserCancelledError;

#if TARGET_OS_OSX
    - (void)ensureFileWriteSuccess:(BOOL)writeSuccess;
    + (void)checkFileOperationSuccess:(BOOL)writeSuccess error:(NSError *)error errMsg:(NSString *)errMsg;
    - (void)presentAlertWithCode:(NSUInteger)code;
    - (void)presentAlertWithCode:(NSUInteger)code inWindow:(NSWindow *)window;
#endif

@end
