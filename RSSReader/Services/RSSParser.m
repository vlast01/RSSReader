//
//  RSSParser.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "RSSParser.h"
#import "NSString+DateConverter.h"
#import "NSXMLParser+InitializationWithDelegate.h"

@interface RSSParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void (^completion)(NSError *);
@property (nonatomic, retain)NSMutableArray<FeedItem *>* array;
@property (nonatomic, retain)NSString *currentElement;
@property (nonatomic, retain) NSMutableString *tempString;

@end

NSString * const kItem = @"item";
NSString * const kTitle = @"title";
NSString * const kDescription = @"description";
NSString * const kLink = @"link";
NSString * const kPubDate = @"pubDate";
NSString * const kCategory = @"category";
NSString * const kInitialFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
NSString * const kDesiredFormat = @"yyyy/MM/dd";

@implementation RSSParser

- (void)parseFeedWithData:(NSData *)data array:(NSMutableArray<FeedItem *>*)array completion:(void (^)(NSError *))completion{
    NSXMLParser *parser = [NSXMLParser parserWithData:data delegate:self];
    self.array = [array retain];
    self.completion = completion;
    [array release];
    [parser parse];
    completion(nil);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.tempString = [[NSMutableString new] autorelease];
    self.currentElement = elementName;
    if([elementName isEqualToString:kItem]) {
        [self.array addObject:[[FeedItem new] autorelease]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if (self.array.count != 0) {
        if ([self.currentElement isEqualToString:kTitle]) {
            if (!self.array.lastObject.title) {
                self.array.lastObject.title = string;
            }
            else {
                self.array.lastObject.title = [self.array.lastObject.title stringByAppendingString:string];
            }
        }
        else if ([self.currentElement isEqualToString:kDescription] && !self.array.lastObject.newsDescription) {
            [self.tempString appendString:string];
        }
        else if ([self.currentElement isEqualToString:kLink] && !self.array.lastObject.link) {
            self.array.lastObject.link = string;
        }
        else if ([self.currentElement isEqualToString:kPubDate] && !self.array.lastObject.pubDate) {
            self.array.lastObject.pubDate = [string changeDate:string fromFormat:kInitialFormat toFormat:kDesiredFormat];
        }
        else if ([self.currentElement isEqualToString:kCategory] && !self.array.lastObject.category) {
            self.array.lastObject.category = string;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kDescription]) {
        [self parseDescription:self.tempString];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) {
        self.completion(parseError);
    }
}

- (void)parseDescription:(NSMutableString *)description {
    
    description = [[self deleteUselessTagsFromDescription:description] mutableCopy];
    self.array.lastObject.newsDescription = description;
    [description release];
}

- (NSString *)deleteUselessTagsFromDescription:(NSString *)description {
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSError *error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"<[^<]+?>"
                                                                           options:regexOptions
                                                                             error:&error];
    NSArray* matches = [regex matchesInString:description options:0 range:NSMakeRange(0, [description length])];
    NSString *resultString = [NSString stringWithString:description];
    for ( NSTextCheckingResult* match in matches )
    {
        NSString* matchText = [description substringWithRange:[match range]];
        resultString = [resultString stringByReplacingOccurrencesOfString:matchText withString:@""];
    }
    return resultString;
}

- (void)dealloc {
    [_completion release];
    [_currentElement release];
    [_array release];
    [_tempString release];
    [super dealloc];
}

@end
