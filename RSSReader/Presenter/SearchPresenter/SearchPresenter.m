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
            [self.delegate showAlert:kNoSuchSiteMessage];
            completion();
        } else {
            HTMLParser *htmlParser = [HTMLParser new];
            [htmlParser parseHTML:html array:array sitename:url];
            [htmlParser release];
            if (array.count == 0) {
                [self.delegate showAlert:kNoRSSFeedsMessage];
            }
            completion();
        }
    } else {
        [self.delegate showAlert:kBadFormatMessage];
        completion();
    }
    [array release];
}

- (BOOL)validateUrl: (NSString *) candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (NSString *)configureURL:(NSString *)url {

    if (url.length>7) {
        NSString *httpsCase = [url substringToIndex:8];
        if ([httpsCase caseInsensitiveCompare:@"https://"] == NSOrderedSame) {
            return [url stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"https://"];;
        }
        else {
            NSString *httpsCase = [url substringToIndex:7];
            if ([httpsCase caseInsensitiveCompare:@"http://"] == NSOrderedSame) {
                NSLog(@"222");
                return [url stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@"http://"];;
            }
        }
    }
    return [NSString stringWithFormat:@"https://%@", url];
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
                [weakSelf.delegate showAlert:kNoSuchSiteMessage];
            }
        }];
    } else {
        [self.delegate showAlert:kBadFormatMessage];
    }
}

- (void)dealloc {
    [_networkManager release];
    [super dealloc];
}

@end
