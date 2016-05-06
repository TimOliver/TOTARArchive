//
//  TOTARArchiveFileEntry.m
//  TOTARArchive
//
//  Created by Tim Oliver on 5/05/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TOTARArchiveItem.h"

@interface TOTARArchiveItem ()

@property (nonatomic, strong, readwrite) NSString  *name;
@property (nonatomic, assign, readwrite) NSInteger fileSize;
@property (nonatomic, strong, readwrite) NSDate    *creationDate;
@property (nonatomic, strong, readwrite) NSData    *fileData;

@property (nonatomic, strong) NSData *data;

@end

@implementation TOTARArchiveItem

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init]) {
        _data = data;
        _fileSize = -1;
    }
    
    return self;
}

- (NSString *)name
{
    if (_name)
        return _name;
    
    NSData *nameChunk = [self.data subdataWithRange:NSMakeRange(0, 100)];
    _name = [[NSString alloc] initWithData:nameChunk encoding:NSUTF8StringEncoding];
    return _name;
}

- (NSInteger)fileSize
{
    if (_fileSize >= 0) {
        return _fileSize;
    }
    
    NSData *sizeChunk = [self.data subdataWithRange:NSMakeRange(124, 12)];
    _fileSize = strtol(sizeChunk.bytes, NULL, 8);
    return _fileSize;
}

- (NSData *)fileData
{
    if( _fileData) {
        return _fileData;
    }
    
    _fileData = [self.data subdataWithRange:NSMakeRange(512, self.fileSize)];
    return _fileData; 
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"File Name: %@ Size: %ld Data: %@", self.name, self.fileSize, [[NSString alloc] initWithData:self.fileData encoding:NSUTF8StringEncoding] ];
}

@end
