//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedPresenter.h"
#import "NetworkManager.h"
#import "RSSParser.h"

@implementation FeedPresenter

- (id)initWithArray:(NSMutableArray *)array {
    if (self = [super init]) {
        self.feedItemArray = array;
    }
    return self;
}

- (void)loadNewsWithCompletion:(void (^)(BOOL))completion {
    if (self.networkManager == nil) {
        [self setupNetworkManager];
    }
    [self.networkManager loadFeedWithCompliteon:^(NSData * data) {
        [self parseRowData:data completion:^(BOOL success) {
            completion(success);
        }];
    }];
}

- (void)parseRowData:(NSData *)data completion:(void (^)(BOOL))completion{
    RSSParser *parser = [RSSParser new];
    [parser parseFeedWithData:data andArray:self.feedItemArray completion:^(BOOL success) {
        completion(success);
    }];
    [parser release];
}

- (void)setupNetworkManager {
    NetworkManager *networkManager = [NetworkManager new];
    self.networkManager = networkManager;
    [networkManager release];
}

- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [super dealloc];
}
@end
