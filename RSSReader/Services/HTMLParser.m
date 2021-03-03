//
//  HTMLParser.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "HTMLParser.h"
#import "SearchFeedItem.h"

@interface HTMLParser ()

@property (nonatomic, retain) NSRegularExpression *rssRegEx;
@property (nonatomic, retain) NSRegularExpression *titleRegEx;
@property (nonatomic, retain) NSRegularExpression *hrefRegEx;
@property (nonatomic, copy) NSString *siteName;

@end

NSString *const kRSSPattern = @"<link[^>]+type=\"application/rss\\+xml\".*?>";
NSString *const kTitlePattern = @"title=\"(.*?)\"";
NSString *const kHrefPattern = @"href=\"(.*?)\"";

@implementation HTMLParser

- (void)parseHTML:(NSString *)htmlString array:(NSMutableArray<SearchFeedItem *> *)array sitename:(NSString *)sitename; {
    
    self.siteName = sitename;
    
    NSArray* matches = [self.rssRegEx matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [htmlString substringWithRange:[match range]];
        [array addObject:[self parseMatch:matchText]];
    }
}

- (SearchFeedItem *)parseMatch:(NSString *)match {
    
    NSString *title = [self findSubstringWithPattern:kTitlePattern originalString:match];
    NSString *url = [self findSubstringWithPattern:kHrefPattern originalString:match];

    if (![url containsString:@"http"]) {
        url = [self relativePathComplementing:url];
    }
  
    SearchFeedItem *item = [SearchFeedItem new];
    item.title = title;
    item.url = url;
    return [item autorelease];
}

- (NSString *)relativePathComplementing:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@",self.siteName, path];;
}

- (NSString *)findSubstringWithPattern:(NSString *)pattern originalString:(NSString *)originalString{
    
    NSArray *matches;
    if ([pattern isEqualToString:kTitlePattern]) {
        matches = [self.titleRegEx matchesInString:originalString options:0 range:NSMakeRange(0, [originalString length])];
    }
    else {
        matches = [self.hrefRegEx matchesInString:originalString options:0 range:NSMakeRange(0, [originalString length])];
    }
    NSRange matchRange = [matches[0] rangeAtIndex:1];
    return [originalString substringWithRange:matchRange];
}

- (NSRegularExpression *)rssRegEx {
    if (!_rssRegEx) {
        _rssRegEx = [[NSRegularExpression alloc] initWithPattern:kRSSPattern options:NSRegularExpressionCaseInsensitive error:nil];
        
    }
    return _rssRegEx;
}

- (NSRegularExpression *)titleRegEx {
    if (!_titleRegEx) {
        _titleRegEx = [[NSRegularExpression alloc] initWithPattern:kTitlePattern options:NSRegularExpressionCaseInsensitive error:nil];
        
    }
    return _titleRegEx;
}

- (NSRegularExpression *)hrefRegEx {
    if (!_hrefRegEx) {
        _hrefRegEx = [[NSRegularExpression alloc] initWithPattern:kHrefPattern options:NSRegularExpressionCaseInsensitive error:nil];
        
    }
    return _hrefRegEx;
}

- (void)dealloc {
    [_rssRegEx release];
    [_titleRegEx release];
    [_hrefRegEx release];
    [_siteName release];
    [super dealloc];
}

@end

