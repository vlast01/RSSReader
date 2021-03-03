//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedPresenter.h"

@interface FeedPresenter ()

@property (nonatomic, retain) NetworkManager *networkManager;
@property (nonatomic, retain) RSSParser *parser;
@property (nonatomic, retain) NSMutableArray* feedItemArray;
@property (nonatomic, copy) void (^completion)(NSError *);
@property (nonatomic, copy) NSString *url;

@end

@implementation FeedPresenter

- (id)initWithArray:(NSMutableArray *)array networkManager:(NetworkManager *)manager parser:(RSSParser *)parser url:(NSString *)url {
    if (self = [super init]) {
        if (array) {
            _feedItemArray = [array retain];
        }
        _url = [url retain];
        _networkManager = [manager retain];
        _parser = [parser retain];
    }
    return self;
}

- (void)asyncLoadNewsWithCompletion:(void (^)(NSError *))completion {
    if (completion) {
        self.completion = completion;
        [NSThread detachNewThreadSelector:@selector(loadNews) toTarget:self withObject:nil];
    }
}

- (void)loadNews {
    @autoreleasepool {
        __block typeof(self) weakSelf = self;
        [self.networkManager loadFeed:self.url completion:^(NSData * data, NSError *error) {
            if (error && weakSelf.completion) {
                weakSelf.completion(error);
            }
            else {
                [weakSelf parseRowData:data completion:weakSelf.completion];
            }
        }];
    }
}

- (void)parseRowData:(NSData *)data completion:(void (^)(NSError *))completion{
    [self.parser parseFeedWithData:data array:self.feedItemArray completion:^(NSError *error) {
        completion(error);
    }];
}

- (NSMutableArray *)feedItemArray {
    if (!_feedItemArray) {
        _feedItemArray = [NSMutableArray new];
    }
    return _feedItemArray;
}

- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [_parser release];
    [_completion release];
    [_url release];
    [super dealloc];
}
@end
