//
//  TOTARArchiveTests.m
//  TOTARArchiveTests
//
//  Created by Tim Oliver on 5/05/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOTARArchive.h"

@interface TOTARArchiveTests : XCTestCase

@end

@implementation TOTARArchiveTests

- (void)testTARFile
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Test" withExtension:@"tar"];
    TOTARArchive *archive = [TOTARArchive archiveWithFileAtURL:fileURL];
    XCTAssertNotNil(archive);
    
    NSLog(@"%@", archive.items);
}

@end
