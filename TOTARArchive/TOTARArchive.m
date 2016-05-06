//
//  TOTARArchive.m
//  TOTARArchive
//
//  Created by Tim Oliver on 5/05/2016.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TOTARArchive.h"
#import "TOTARArchiveItem.h"

// Format Definitions
const NSInteger kTARBlockSize    = 512;
const NSInteger kTARTypePosition = 156;
const NSInteger kTARNamePosition = 0;
const NSInteger kTARNameSize     = 100;
const NSInteger kTARSizePosition = 124;
const NSInteger kTARSizeSize     = 12;

@interface TOTARArchive ()

@property (nonatomic, strong, readwrite) NSURL *fileURL;
@property (nonatomic, strong, readwrite) NSArray *items;

@property (nonatomic, strong) NSData *data;

- (BOOL)loadData;
- (BOOL)loadItems;

@end

@implementation TOTARArchive

- (instancetype)initWithFileAtURL:(NSURL *)url
{
    if (self = [super init]) {
        _fileURL = url;
        
        if ([self loadData] == NO) {
            return nil;
        }
    }
    
    return self;
}

+ (TOTARArchive *)archiveWithFileAtURL:(NSURL *)url
{
    return [[TOTARArchive alloc] initWithFileAtURL:url];
}

#pragma mark - Data Processing -
- (BOOL)loadData
{
    if (self.data) {
        return YES;
    }
    
    NSError *error = nil;
    self.data = [NSData dataWithContentsOfURL:self.fileURL options:NSDataReadingMappedIfSafe error:&error];
    if (error || self.data == nil) {
        return NO;
    }
    
    return [self loadItems];
}

- (BOOL)loadItems
{
    if (self.data.length == 0) {
        return NO;
    }
    
    NSInteger offset = 0;
    NSMutableArray *items = [NSMutableArray array];
    
    // Loop through each entry in the file
    while (offset < self.data.length) {
        // Get the entire header block
        NSData *entryHeader = [self.data subdataWithRange:NSMakeRange(offset, kTARBlockSize)];
        
        // Get the section of the header holding the file size and convert it
        NSData *fileSizeField = [entryHeader subdataWithRange:NSMakeRange(124, 12)];
        long fileSize = strtol(fileSizeField.bytes, NULL, 8);
        
        // Make sure the data block is padded out to 512 bytes
        NSInteger sizeWithPadding = fileSize;
        if (sizeWithPadding % kTARBlockSize != 0) {
            sizeWithPadding += (kTARBlockSize - (sizeWithPadding % kTARBlockSize));
        }
        
        // With the header and the size of the data block, we can work out the total size of this block
        NSInteger entrySize = kTARBlockSize + sizeWithPadding;
        
        //Get the type of the file to see if we need to expose it
        NSData *fileTypeField = [entryHeader subdataWithRange:NSMakeRange(kTARTypePosition, 1)];
        unsigned char *fileType = (unsigned char *)fileTypeField.bytes;
        
        if (*fileType == '0') {
            NSData *entryBlock = [self.data subdataWithRange:NSMakeRange(offset, entrySize)];
            TOTARArchiveItem *item = [[TOTARArchiveItem alloc] initWithData:entryBlock];
            [items addObject:item];
        }
        
        offset += entrySize;
    }
    
    self.items = [NSArray arrayWithArray:items];
    
    return YES;
}

@end
