//
//  TOTARArchiveFileEntry.h
//  TOTARArchive
//
//  Created by Tim Oliver on 5/05/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTARArchiveItem : NSObject

@property (nonatomic, readonly) NSString  *name;
@property (nonatomic, readonly) NSInteger fileSize;
@property (nonatomic, readonly) NSDate    *creationDate;
@property (nonatomic, readonly) NSData    *fileData;

- (instancetype)initWithData:(NSData *)data;

@end
