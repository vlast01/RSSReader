//
//  RSSParser.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "RSSParser.h"
#import "FeedItem.h"
#import "NSString+DateConverter.h"
#import "NSXMLParser+InitializationWithDelegate.h"

@interface RSSParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void (^completion)(NSError *);
@property (nonatomic, retain)NSMutableArray<FeedItem *>* array;
@property (nonatomic, retain)NSString *currentElement;

@end

NSString *kItem = @"item";
NSString *kTitle = @"title";
NSString *kDescription = @"description";
NSString *kLink = @"link";
NSString *kPubDate = @"pubDate";

@implementation RSSParser

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance {
    static RSSParser *uniqueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[RSSParser alloc] initPrivate];
    });
    return uniqueInstance;
}

- (void)parseFeedWithData:(NSData *)data andArray:(NSMutableArray<FeedItem *>*)array completion:(void (^)(NSError *))completion{
    NSXMLParser *parser = [NSXMLParser parserWithData:data andDelegate:self];
    self.array = array;
    self.completion = completion;
    [array release];
    [parser parse];
    completion(nil);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.currentElement = elementName;
    if([elementName isEqualToString:kItem]) {
        [self.array addObject:[[FeedItem new] autorelease]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.array.count != 0) {
        if ([self.currentElement isEqualToString:kTitle] && !self.array.lastObject.title) {
            self.array.lastObject.title = string;
        }
        else if ([self.currentElement isEqualToString:kDescription] && !self.array.lastObject.newsDescription) {
            self.array.lastObject.newsDescription = string;
        }
        else if ([self.currentElement isEqualToString:kLink] && !self.array.lastObject.link) {
            self.array.lastObject.link = string;
        }
        else if ([self.currentElement isEqualToString:kPubDate] && !self.array.lastObject.pubDate) {
            self.array.lastObject.pubDate = [string parseDate:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) {
        self.completion(parseError);
    }
}

- (void)dealloc {
    [_completion release];
    [_currentElement release];
    [_array release];
    [super dealloc];
}

@end
