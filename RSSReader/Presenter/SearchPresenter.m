//
//  SearchPresenter.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchPresenter.h"
#import "HTMLParser.h"
#import "RSSParser.h"

@interface SearchPresenter ()

@property (nonatomic, retain) NetworkManager *networkManager;

@end

NSString * const kNoSuchSiteMessage = @"No such site";
NSString * const kNoRSSFeedsMessage = @"No RSS feeds";
NSString * const kBadFormatMessage = @"Bad format";

@implementation SearchPresenter

- (id)initWithNetworkManager:(NetworkManager *)manager {
    if (self = [super init]) {
        _networkManager = [manager retain];
    }
    return self;
}

- (void)searchFeeds:(NSString *)url array:(NSMutableArray<SearchFeedItem *> *)array completion:(void (^)(void))completion {
    [array retain];
    url = [self configureURL:url];
    if ([self validateUrl:url]) {
        NSString *html = [self.networkManager downloadHTML:url];
        
        if ([html isEqualToString:@""]) {
            [self.delegate showException:kNoSuchSiteMessage];
            completion();
        } else {
            HTMLParser *htmlParser = [HTMLParser new];
            [htmlParser parseHTML:html array:array sitename:url];
            [htmlParser release];
            if (array.count == 0) {
                [self.delegate showException:kNoRSSFeedsMessage];
            }
            completion();
        }
    } else {
        [self.delegate showException:kBadFormatMessage];
        completion();
    }
    [array release];
}

- (BOOL)validateUrl: (NSString *) candidate {
    NSString *urlRegEx = @"(http|https|Http|Https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (NSString *)configureURL:(NSString *)url {
    if (![url containsString:@"http://"] && ![url containsString:@"Http://"] && ![url containsString:@"https://"] && ![url containsString:@"Https://"] && ![url containsString:@"HTTPS://"] && ![url containsString:@"HTTP://"] && ![url containsString:@"HTTPs://"]) {
        url = [NSString stringWithFormat:@"https://%@", url];
    }
    return url;
}

- (void)checkDirectLink:(NSString *)url completion:(void (^)(NSError * , NSMutableArray * ))completion {
    
    url = [self configureURL:url];
    
    if ([self validateUrl:url]) {
        __block typeof(self) weakSelf = self;
        [self.networkManager loadFeed:url completion:^(NSData * data, NSError * error) {
            if (data) {
                RSSParser *rssParser = [RSSParser new];
                NSMutableArray *array = [NSMutableArray new];
                [rssParser parseFeedWithData:data array:array completion:^(NSError * error) {
                    completion(nil, array);

                }];
                [rssParser release];
                [array release];
            }
            else {
                [weakSelf.delegate showException:kNoSuchSiteMessage];
            }
        }];
    } else {
        [self.delegate showException:kBadFormatMessage];
    }
}

- (void)dealloc {
    [_networkManager release];
    [super dealloc];
}

@end
