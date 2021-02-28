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
    
    if (![self isRepeat:item]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self readData]];
        [tempArray addObject:item];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempArray requiringSecureCoding:YES error:nil];
        [data writeToFile:self.path atomically:NO];
    }
}


- (NSArray<SearchFeedItem *>*)readData {
    NSData *data = [[NSMutableData alloc]initWithContentsOfFile:self.path];
    NSArray *entries = [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[SearchFeedItem class] fromData:[data autorelease] error:nil];
    
    return entries;
}

- (BOOL)isRepeat:(SearchFeedItem *)item {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self readData]];
    for (SearchFeedItem *note in tempArray) {
        if ([note.title isEqualToString:item.title]) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc {
    [_path release];
    [super dealloc];
}

@end
