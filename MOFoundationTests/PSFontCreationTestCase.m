//
//  PSFontCreationTestCase.m
//  MOFoundationTests
//
//  Created by Patrice on 30/06/2019.
//  Copyright © 2019 Patrice. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PSFontCreationTestCase : XCTestCase

@end

@implementation PSFontCreationTestCase

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFontCreation {
    NSArray *fontFamilies = @[@"Helvetica", @"Avenir Next Condensed"];
    [fontFamilies enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fontFamily = (NSString *)obj;
        NSLog( @"Testing font family:[%@]", fontFamily );
        [self testFontFamily:fontFamily];
    }];
}

- (void)testFontFamily:(NSString *)fontFamily {
    CGFloat fontSize = 14.0;
    UIFont *font = [UIFont fontWithName:fontFamily size:fontSize];
    XCTAssertNotNil(font);
}

- (void)testDefaultFonts {
    NSArray *familyNames = [UIFont familyNames];
    
    [familyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fontFamily = (NSString *)obj;
        NSLog( @"Testing font family:[%@]", fontFamily );
        [self testFontFamily:fontFamily];
    }];
}

@end
