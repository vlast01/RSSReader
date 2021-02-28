//
//  HTMLParser.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "HTMLParser.h"
#import "SearchFeedItem.h"

@interface HTMLParser ()

@property (nonatomic, strong) NSRegularExpression *rssRegEx;
@property (nonatomic, strong) NSRegularExpression *titleRegEx;
@property (nonatomic, strong) NSRegularExpression *hrefRegEx;

@end

NSString *const kRSSPattern = @"<link[^>]+type=\"application/rss\\+xml\".*?>";
NSString *const kTitlePattern = @"title=\"(.*?)\"";
NSString *const kHrefPattern = @"href=\"(.*?)\"";

@implementation HTMLParser

- (void)parseHTML:(NSString *)htmlString array:(NSMutableArray<SearchFeedItem *> *)array; {

    NSArray* matches = [self.rssRegEx matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
            for ( NSTextCheckingResult* match in matches )
            {
                NSString* matchText = [htmlString substringWithRange:[match range]];
               [array addObject:[self parseMatch:matchText]];
            }
}

- (SearchFeedItem *)parseMatch:(NSString *)match {

    NSString *title = [self findSubstringWithPattern:kTitlePattern originalString:match];
    NSString *url = [self findSubstringWithPattern:kHrefPattern originalString:match];
    SearchFeedItem *item = [SearchFeedItem new];
    item.title = title;
    item.url = url;
    return [item autorelease];
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
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        _rssRegEx = [[NSRegularExpression alloc] initWithPattern:kRSSPattern options:regexOptions error:nil];

    }
    return _rssRegEx;
}

- (NSRegularExpression *)titleRegEx {
    if (!_titleRegEx) {
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        _titleRegEx = [[NSRegularExpression alloc] initWithPattern:kTitlePattern options:regexOptions error:nil];

    }
    return _titleRegEx;
}

- (NSRegularExpression *)hrefRegEx {
    if (!_hrefRegEx) {
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        _hrefRegEx = [[NSRegularExpression alloc] initWithPattern:kHrefPattern options:regexOptions error:nil];

    }
    return _hrefRegEx;
}

- (void)dealloc {
    [_rssRegEx release];
    [_titleRegEx release];
    [_hrefRegEx release];
    [super dealloc];
}

@end

