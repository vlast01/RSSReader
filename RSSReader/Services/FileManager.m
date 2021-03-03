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

@implementation FileManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _path = [[NSString alloc] initWithFormat:@"%@/History", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    }
    return self;
}

- (void)writeToFile:(SearchFeedItem *)item {

    NSLog(@"%@",[self readData]);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item requiringSecureCoding:YES error:nil];
    [data writeToFile:self.path atomically:NO];
    NSLog(@"%@",[self readData]);
    
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
