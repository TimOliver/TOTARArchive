//
//  TOTARArchive.h
//  TOTARArchive
//
//  Created by Tim Oliver on 5/05/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTARArchive : NSObject

@property (nonatomic, readonly) NSURL *fileURL;
@property (nonatomic, readonly) NSArray *items;

- (instancetype)initWithFileAtURL:(NSURL *)url;
+ (TOTARArchive *)archiveWithFileAtURL:(NSURL *)url;

- (NSData *)dataForItemAtIndex:(NSInteger)index error:(NSError **)error;
- (BOOL)extractItemAtIndex:(NSInteger)index toFileAtURL:(NSURL *)url error:(NSError **)error;

@end
