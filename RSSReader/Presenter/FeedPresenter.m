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

-(id)initWithArray:(NSMutableArray *)array {
    if (self = [super init]) {
        self.feedItemArray = array;
    }
    return self;
}

- (void)loadNewsWiithCompletion:(void (^)(BOOL))completion {
    NetworkManager *networkManager = [NetworkManager new];
    self.networkManager = networkManager;
    [networkManager release];
    [networkManager loadFeedWithCompliteon:^(NSData * data) {
        RSSParser *parser = [RSSParser new];
        [parser parseFeedWithData:data andArray:self.feedItemArray completion:^(BOOL success) {
            completion(success);
        }];
        [parser release];
    }];
}

- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [super dealloc];
}
@end
