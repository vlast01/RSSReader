//
//  FeedItem.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedItem.h"

@implementation FeedItem

- (void)dealloc {
    [_title release];
    [_newsDescription release];
    [_link release];
    [_pubDate release];
    [_category release];
    [super dealloc];
}

@end
