//
//  SearchFeedItem.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchFeedItem.h"

@implementation SearchFeedItem

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.url forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectOfClass:[SearchFeedItem class] forKey:@"title"];
        self.url = [coder decodeObjectOfClass:[SearchFeedItem class] forKey:@"url"];
     }
     return self;
}

- (void)dealloc {
    [_title release];
    [_url release];
    [super dealloc];
}



@end
