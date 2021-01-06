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

@end

@implementation FeedPresenter

- (id)initWithArray:(NSMutableArray *)array networkManager:(NetworkManager *)manager parser:(RSSParser *)parser{
    if (self = [super init]) {
        if (array) {
            _feedItemArray = [array retain];
        }
        else {
            _feedItemArray = [NSMutableArray new];
        }
        _networkManager = [manager retain];
        _parser = [parser retain];
    }
    return self;
}

- (void)asyncLoadNewsWithCompletion:(void (^)(NSError *))completion {
    self.completion = completion;
    [NSThread detachNewThreadSelector:@selector(loadNews) toTarget:self withObject:nil];
}

- (void)loadNews {
    @autoreleasepool {
        [self.networkManager loadFeedWithCompletion:^(NSData * data, NSError *error) {
            if (error) {
                self.completion(error);
            }
            else {
                [self parseRowData:data completion:self.completion];
            }
        }];
    }
}

- (void)parseRowData:(NSData *)data completion:(void (^)(NSError *))completion{
    [self.parser parseFeedWithData:data array:self.feedItemArray completion:^(NSError *error) {
        completion(error);
    }];
}

- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [_parser release];
    [_completion release];
    [super dealloc];
}
@end
