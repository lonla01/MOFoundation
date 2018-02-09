//
//  NSTextField+LSExtension.m
//  Librisse
//
//  Created by Patrice on 06/12/13.
//  Copyright (c) 2013 Librisse. All rights reserved.
//

#import "NSTextField+LSExtension.h"

//@implementation NSTextField (LSExtension)
//
//- (void)setAttributedStringValue:(NSAttributedString *)attrString adjustingSize:(BOOL )flag {
//
//    if ( flag ) {
//
//        // Get the text field and compute its natural size
//        static CGFloat LSEmpiricalPaddingFactor = 1.25;
//        NSSize textSize = [attrString naturalSize];
//        [self setAttributedStringValue:attrString];
//        NSRect superFrame = [[self superview] frame];
//        NSSize naturalSize = NSMakeSize( textSize.width * LSEmpiricalPaddingFactor, superFrame.size.height );
//        NSRect textFrame = [self frame];
//        NSRect winFrame = [[self window] frame];
//
//        // Compute the frames of the view hierarchy
//        textFrame = [self frame];
//        textFrame.size = NSMakeSize( MAX( textFrame.size.width, naturalSize.width ), textFrame.size.height );
//        superFrame.size = NSMakeSize( textFrame.size.width, superFrame.size.height );
//        winFrame.size = NSMakeSize( textFrame.size.width, winFrame.size.height );
//
//        // Set the frame of view in the right order (setting the text field frame last)
//        [[self superview] setFrame:superFrame];
//        [[[self window] contentView] setFrameSize:winFrame.size];
//        [[self window] setFrame:winFrame display:YES];
//        [self setFrame:textFrame];
//
//        //[[[textField window] contentView] debugView];
//
//    } else {
//        [super setAttributedStringValue:attrString];
//    }
//
//}
//@end

