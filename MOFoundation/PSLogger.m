//
//  PSLogger.m
//  Parolisse
//
//  Created by Patrice on 15/06/10.
//  Copyright 2010 Softisse S.A.R.L.. All rights reserved.
//

#import "PSLogger.h"

@implementation PSLogger

@synthesize mute = _mute;
@synthesize debug = _debug;
@synthesize trace = _trace;
@synthesize verbose = _verbose;
@synthesize stackPrint = _stackPrint;

static PSLogger *_SharedLogger = nil;

- (id) init {
    if ((self = [super init])) {
        self.mute = NO;
        self.debug = YES;
        self.trace = NO;
        self.verbose = NO;
        self.stackPrint = YES;
        self.production = NO;
    }
    return self;
}

+ (PSLogger *)sharedLogger {
    if (_SharedLogger == nil) {
        _SharedLogger = [[PSLogger alloc] init];    
    }
    return _SharedLogger;
}

+ (void) setSharedLogger:(PSLogger *)logger { _SharedLogger = logger; }

- (BOOL) isLogging   { return ! self.mute; }
- (BOOL) isDebugging { return [self isLogging]   && [self debug]; }
- (BOOL) isTracing   { return [self isDebugging] && self.trace; }
- (BOOL) isVerbosing { return [self isTracing]   && self.verbose; }

/**
 * The boolean value returned by this method controls if the logger prints
 * the exception stack traces or not.
 */
- (BOOL) isStackPrinting {
    return self.stackPrint || [self isTracing];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PSLogger  { Mute=%d Debug=%d  Trace=%d Verbose=%d StackPrint=%d }", 
            self.mute, self.debug, self.trace, self.verbose, self.stackPrint];
}

#pragma mark -
#pragma mark L O G G I N G

- (NSString *)constructMsg:(NSString *) message sender:(id)sender {   
    
    NSString *prefix;
    
    // The sender could be a Class. In this case we ask it of its description and not its class name.
    prefix = ( [sender respondsToSelector:@selector(className)] ) ? [sender className] : [sender description];
    
    return [prefix stringByAppendingFormat:@": %@",  message];
}

- (void )logMsg:(NSString *)message  {
    if ( [self isLogging] )
        NSLog( @"%@", message );
}

- (void) logMsg: (NSString *)message  sender:(id)sender {
        [self logMsg: [self constructMsg:message sender:sender]];
}

- (void )logFormat:(NSString *)format args:(va_list )argList sender:sender {
    
    NSString *message;
    
    if ( ! format ) return ;
    
    message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self logMsg:message sender:sender];
    
}

- (void) warnMsg: (NSString *)message  {
    if ( [self isLogging] )
        [self logMsg:message];
}

- (void) warnMsg: (NSString *)message  sender:(id)sender {
    [self logMsg: [self constructMsg:message sender:sender]];
}

// This is for private use only !
- (void)errorMsg:(NSString *)message {
        if ( message == nil ) return;
    if (self.isLogging) {
        NSString *errorMsg = [[NSString alloc] initWithFormat:@"!!! %@", message];
        NSLog( @"%@", errorMsg );
    }
}

- (void)errorMsg:(NSString *)message sender:(id)sender {
    [self errorMsg:[self constructMsg:message sender:sender]];
}

- (void )errorFormat:(NSString *)format args:(va_list )argList sender:sender {
    
    NSString *message;
    
    if ( ! format ) return ;
    
    message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self errorMsg:message sender:sender];
    
}


- (void) errorMsg:(NSString *)message sender:(id)sender exception:(NSException *)exception {
    NSString *errorMsg = [[NSString alloc] initWithFormat:@"EXCEPTION: %@ ::: %@", message,
                          ( (exception != nil) && [exception reason] != nil) ? [exception reason] : @"Unknown Error"];
    [self errorMsg:[self constructMsg:errorMsg sender:sender]];
    if ( [self isStackPrinting] ) {
        [self errorMsg:[[exception callStackSymbols] description]];
        [self errorMsg:[NSString stringWithFormat:@"ERROR Details: %@", [exception userInfo]]];
    }
    if ( self.production ) {
        //[NSApp presentError:[NSError errorWithException:exception]];
        //exit(-1);
    }
}

- (void) errorMsg:(NSString *)message sender:(id)sender error:(NSError *)error {
    NSString *errorMsg = [[NSString alloc] initWithFormat:@"ERROR: %@ ::: %@", message,
                          ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error"];
    [self errorMsg:[self constructMsg:errorMsg sender:sender]];
    if ( [self isStackPrinting] ) {
        [self errorMsg:[NSString stringWithFormat:@"ERROR Details: %@", [[error userInfo] description]]];
    }
}

- (void )errorFormat:(NSString *)format args:(va_list )argList sender:sender error:(NSError *)error {
    
    NSString *message;
    
    if ( ! format ) return ;
    
    message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self errorMsg:message sender:sender error:error];
    
}


- (void)shoutMsg:(NSString *)message {
    [self errorMsg:message];
}

- (void) shoutMsg:(NSString *)message sender:(id)sender {
    [self shoutMsg:[self constructMsg:message sender:sender]];
}
     
- (void) debugMsg:(NSString *)message  {
    if ( [self isDebugging] )
        [self logMsg:message];
}

- (void) debugMsg: (NSString *)message  sender:(id)sender {
    [self debugMsg: [self constructMsg:message sender:sender]];
}

- (void )debugFormat:(NSString *)format args:(va_list )argList sender:(id)sender {
    
    NSString *message;
    
    if ( ! format ) return ;
    
    message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self debugMsg:message sender:sender];
    
}


- (void) traceMsg:(NSString *)message  {
    if ( [self isTracing] )
        [self logMsg:message];
}

- (void) traceMsg: (NSString *)message  sender:(id)sender {
    [self traceMsg: [self constructMsg:message sender:sender]];
}

- (void) verboseMsg:(NSString *)message  {
    if ( [self isVerbosing] )
        [self logMsg:message];
}

- (void) verboseMsg: (NSString *)message  sender:(id)sender {
    [self verboseMsg: [self constructMsg:message sender:sender]];
}

@end

#pragma mark  -
#pragma mark    N S O B J E C T ( P S L O G G E R    C O N V E N I E N C E S )

@implementation NSObject (PSLoggerConveniences) 

- (void) log:(NSString *)msg {
    [[self logger] logMsg:msg sender:self];
}

- (void) warn:(NSString *)msg {
    [[PSLogger sharedLogger] warnMsg:msg sender:self];
}

- (void) shout:(NSString *)msg {
    [[PSLogger sharedLogger] shoutMsg:msg sender:self];
}

- (void) debug:(NSString *)msg {
    [[PSLogger sharedLogger] debugMsg:msg sender:self];
}

- (void) trace:(NSString *)msg {
    [[PSLogger sharedLogger] traceMsg:msg sender:self];
}

- (void) verbose:(NSString *)msg {
    [[PSLogger sharedLogger] verboseMsg:msg sender:self];
}

- (void) error:(NSString *)msg {
    [[PSLogger sharedLogger] errorMsg:msg sender:self exception:nil];
}

- (void) error:(NSString *)msg exc:(NSException *)e {
    [[PSLogger sharedLogger] errorMsg:msg sender:self exception:e];
}

- (void) error:(NSString *)msg err:(NSError *)e {
    [[PSLogger sharedLogger] errorMsg:msg  sender:self error:e];
}

/// Variable args versions 
- (void) debugFormat:(NSString *)format, ... {
    
    va_list argumentsList;
    
    if ( format ) {
        va_start( argumentsList, format );
        [[PSLogger sharedLogger] debugFormat:format args:argumentsList sender:self];
        va_end( argumentsList );
    }

}

- (void) errorFormat:(NSString *)format, ... {
    
    va_list argumentsList;
    
    if ( format ) {
        va_start( argumentsList, format );
        [[PSLogger sharedLogger] errorFormat:format args:argumentsList sender:self];
        va_end( argumentsList );
    }
    
}

- (void)error:(NSError *)error format:(NSString *)format, ... {
    
    va_list argumentsList;
    
    if ( format ) {
        va_start( argumentsList, format );
        [[PSLogger sharedLogger] errorFormat:format args:argumentsList sender:self error:error];
        va_end( argumentsList );
    }
    
}




@end

@implementation NSObject (ParolisseConveniences)

- (NSString *)className {
    return [[self class] description];
}

- (PSLogger *)logger {
    return [PSLogger sharedLogger];
}

@end


