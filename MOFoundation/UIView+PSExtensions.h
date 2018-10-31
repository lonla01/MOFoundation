//
//  UIView+PSExtensions.h
//  Parolisse
//
//  Created by Serge LONLA on 11/07/12.
//  Copyright (c) 2012 Serge P. LONLA. All rights reserved.
//

#import <UIKit/UIView.h>

@interface UIView (PSExtensions)

- (NSString *)debugStringForIndentLevel:(NSUInteger )level;

- (void)debugView;

- (UIView *)subviewOfClass:(Class )aClass;

@end
