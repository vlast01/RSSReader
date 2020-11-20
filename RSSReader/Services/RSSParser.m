//
//  RSSParser.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "RSSParser.h"
#import "FeedItem.h"

@implementation RSSParser

- (void)parseFeedWithData:(NSData *)data andArray:(NSMutableArray<FeedItem *>*)array completion:(void (^)(BOOL))completion{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    self.array = array;
    [array release];
    parser.delegate = self;
    BOOL success = [parser parse];
    [parser release];
    completion(success);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.currentElement = elementName;
    if([elementName isEqualToString:@"item"]) {
        FeedItem *item = [FeedItem new];
        [self.array addObject:item];
        [item release];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.array.count != 0) {
        if ([self.currentElement isEqualToString:@"title"] && self.array.lastObject.title == nil) {
            self.array.lastObject.title = string;
        }
        else if ([self.currentElement isEqualToString:@"description"] && self.array.lastObject.newsDescription == nil) {
            self.array.lastObject.newsDescription = string;
        }
        else if ([self.currentElement isEqualToString:@"link"] && self.array.lastObject.link == nil) {
            self.array.lastObject.link = string;
        }
        else if ([self.currentElement isEqualToString:@"pubDate"] && self.array.lastObject.pubDate == nil) {
            self.array.lastObject.pubDate = [self parseDate:string];
        }
    }
}

- (NSString *)parseDate:(NSString *)oldDateString {
    NSDateFormatter *oldFormatter = [NSDateFormatter new];
    [oldFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *oldDate = [oldFormatter dateFromString:oldDateString];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *newDateString = [dateFormatter stringFromDate:oldDate];
    [oldFormatter release];
    [dateFormatter release];
    return newDateString;
}

- (void)dealloc {
    [_currentElement release];
    [_array release];
    [super dealloc];
}

@end
