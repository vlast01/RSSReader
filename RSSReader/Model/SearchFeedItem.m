//
//  SearchFeedItem.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchFeedItem.h"

NSString * const kTitleKey = @"title";
NSString * const kUrlKey = @"url";

@implementation SearchFeedItem

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:kTitleKey];
    [coder encodeObject:self.url forKey:kUrlKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectOfClass:[SearchFeedItem class] forKey:kTitleKey];
        self.url = [coder decodeObjectOfClass:[SearchFeedItem class] forKey:kUrlKey];
     }
     return self;
}

- (void)dealloc {
    [_title release];
    [_url release];
    [super dealloc];
}



@end
