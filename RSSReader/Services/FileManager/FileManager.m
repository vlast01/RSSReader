//
//  FileManager.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "FileManager.h"


@interface FileManager ()

@property (nonatomic, retain) NSString *path;

@end

NSString * const kHistoryFolder = @"/History";
NSString * const kDocumentsFolder = @"Documents";

@implementation FileManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _path = [[NSString alloc] initWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingPathComponent:kDocumentsFolder], kHistoryFolder];
    }
    return self;
}

- (void)writeToFile:(SearchFeedItem *)item {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item requiringSecureCoding:YES error:nil];
    [data writeToFile:self.path atomically:NO];
}

- (SearchFeedItem *)readData {
    NSData *data = [[NSMutableData alloc]initWithContentsOfFile:self.path];
    SearchFeedItem *result = [NSKeyedUnarchiver unarchivedObjectOfClass:[SearchFeedItem class] fromData:data error:nil];
    [data release];
    return result;

}

- (void)dealloc {
    [_path release];
    [super dealloc];
}

@end
