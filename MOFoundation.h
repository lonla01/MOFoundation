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

#import "PSAssert.h"
#import "NSString_Conveniences.h"
#import "NSObject_Conveniences.h"
#import "NSNumber_Conveniences.h"
#import "NSArray_Conveniences.h"
#import "NSString_Conveniences.h"
#import "NSManagedObjectContext+Conveniences.h"
#import "UIView+PSExtensions.h"
#import "UIColor+Conveniences.h"
#import "UIImage+Conveniences.h"

#endif
