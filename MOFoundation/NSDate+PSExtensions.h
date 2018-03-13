//
//  NSDate+PSExtensions.h
//  Parolisse
//
//  Created by Patrice on 28/02/13.
//
//

@import Foundation;

@interface NSDate (PSExtensions)

- (NSString *)unlocalizedDescription;
+ (NSDate *)dateFromUnlocalizedDescription:(NSString *)description;

- (NSNumber *)timeInterval;
+ (NSDate *)dateFromTimeInterval:(NSNumber *)timeInterval;
- (NSString *)displayString;

@end
