//
//  SearchPresenter.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchPresenter.h"
#import "HTMLParser.h"

@interface SearchPresenter ()

@property (nonatomic, strong) NetworkManager *networkManager;

@end

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
        @try {
            NSString *html = [self.networkManager downloadHTML:url];

            HTMLParser *htmlParser = [HTMLParser new];
            [htmlParser parseHTML:html array:(NSMutableArray<SearchFeedItem *> *)array];
            [htmlParser release];
                if (array.count == 0) {
                    [self.delegate showException:@"No RSS feeds"];
                }
                completion();
        } @catch (NSException *exception) {
            [self.delegate showException:@"No such site"];
            completion();
        } @finally {

        }
    } else {
        [self.delegate showException:@"Bad format"];
        completion();
    }
}

- (BOOL)validateUrl: (NSString *) candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (NSString *)configureURL:(NSString *)url {
    if (![url containsString:@"https://"] && ![url containsString:@"Https://"]) {
        url = [NSString stringWithFormat:@"https://%@", url];
    }
    return url;
}

- (void)dealloc {
    [_networkManager release];
    [super dealloc];
}

@end
