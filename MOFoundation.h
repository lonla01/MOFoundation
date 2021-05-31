//
//  MOFoundation.h
//  MOFoundation
//
//  Created by Patrice on 09/02/2018.
//  Copyright © 2018 Patrice. All rights reserved.
//
#import <Availability.h>

#ifndef MOFoundation_h
#define MOFoundation_h
#endif /* MOFoundation_h */

#ifndef __IPHONE_8_0
#warning "This project uses features only available in iPhone SDK 8.0 and later."
#endif

#ifdef __OBJC__

#import <MOFoundation/PSAssert.h>
#import <MOFoundation/PSLogger.h>
#import <MOFoundation/NSString_Conveniences.h>
#import <MOFoundation/NSObject_Conveniences.h>
#import <MOFoundation/NSError_Conveniences.h>
#import <MOFoundation/NSNumber_Conveniences.h>
#import <MOFoundation/NSArray_Conveniences.h>
#import <MOFoundation/NSString_Conveniences.h>
#import <MOFoundation/NSManagedObjectContext+Conveniences.h>
#import <MOFoundation/PSRange.h>
#import <MOFoundation/PSVisitor.h>
#import <MOFoundation/PSStack.h>
#import <MOFoundation/LSUtil.h>
#import <MOFoundation/PSTokenizer.h>
#import <MOFoundation/PSStringToNumberTransformer.h>
#import <MOFoundation/NSData+PSCompression.h>
#import <MOFoundation/NSDate+PSExtensions.h>
#import <MOFoundation/NSURL+LSExtensions.h>
#import <MOFoundation/PSRomanNumberDetector.h>
#import <MOFoundation/NSDateFormatter+LSExtensions.h>

#endif

