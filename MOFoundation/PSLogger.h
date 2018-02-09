//
//  PSLogger.h
//  Parolisse
//
//  Created by Patrice on 15/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//
@import Foundation;

@interface PSLogger : NSObject {
@private
    BOOL _mute;
    BOOL _debug;
    BOOL _trace;
    BOOL _verbose;
    BOOL _stackPrint;
}

@property ( nonatomic, assign ) BOOL mute;
@property( nonatomic, assign ) BOOL debug;
@property( nonatomic, assign ) BOOL trace;
@property( nonatomic, assign ) BOOL verbose;
@property( nonatomic, assign ) BOOL stackPrint;
@property( nonatomic, assign ) BOOL production;

- (id) init;
- (BOOL) isLogging;
- (BOOL) isDebugging;
- ( BOOL) isTracing;
- (BOOL) isVerbosing;
- (BOOL) isStackPrinting;
- (NSString *)description;
+ (PSLogger *)sharedLogger;
+ (void) setSharedLogger:(PSLogger *)logger;


#pragma mark -
#pragma mark L O G G I N G

- (NSString *)constructMsg:(NSString *) message sender:(id)sender;

- (void) logMsg:(NSString *)message;
- (void) logMsg:(NSString *)message  sender:(id)sender;
- (void )logFormat:(NSString *)format args:(va_list )argList sender:sender;
- (void) warnMsg:(NSString *)message;
- (void) warnMsg:(NSString *)message  sender:(id)sender;
- (void) errorMsg:(NSString *)message sender:(id)sender;
- (void )errorFormat:(NSString *)format args:(va_list )argList sender:sender;
- (void) errorMsg:(NSString *)message sender:(id)sender exception:(NSException *)e ;
- (void) errorMsg:(NSString *)message sender:(id)sender error:(NSError *)e ;
- (void )errorFormat:(NSString *)format args:(va_list )argList sender:sender error:(NSError *)error;
// Those are for private use only !
- (void)errorMsg:(NSString *)message;

// We print to System.err as a mean to highlight the msg in Jbuilder
- (void) shoutMsg:(NSString *)message ;
- (void) shoutMsg:(NSString *)message sender:(id)sender;
- (void) debugMsg:(NSString *)message ;
- (void) debugMsg:(NSString *)message  sender:(id)sender;
- (void )debugFormat:(NSString *)format args:(va_list )argList sender:(id)sender;
- (void) traceMsg:(NSString *)message;
- (void) traceMsg: (NSString *)message  sender:(id)sender;
- (void) verboseMsg:(NSString *)message;
- (void) verboseMsg: (NSString *)message  sender:(id)sender;

@end

#pragma mark  -
#pragma mark    N S O B J E C T ( P S L O G G E R    C O N V E N I E N C E S )

@interface NSObject (PSLoggerConveniences) 

- (void) log:(NSString *)msg;
- (void) warn:(NSString *)msg;
- (void) shout:(NSString *)msg;
- (void) debug:(NSString *)msg;
- (void) debugFormat:(NSString *)format, ...;
- (void) trace:(NSString *)msg;
- (void) verbose:(NSString *)msg ;
- (void) error:(NSString *)msg;
- (void) error:(NSString *)msg exc:(NSException *)e;
- (void) error:(NSString *)msg err:(NSError *)e;
- (void) errorFormat:(NSString *)format, ...;
// This signature takes the NSError object as the first argument instead of the NSString.
// This is because the var arg list makes it impossible to pass another arg after itself.
- (void)error:(NSError *)error format:(NSString *)format, ...;

@end

@interface NSObject (ParolisseConveniences)

@property (readonly) NSString * className;
@property (readonly) PSLogger * logger;

@end

