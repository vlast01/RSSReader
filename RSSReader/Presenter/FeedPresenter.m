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
        if (array) {
            self.feedItemArray = array;
        }
        else {
            self.feedItemArray = [[NSMutableArray new] autorelease];
        }
    }
    return self;
}

- (void)loadNewsWithCompletion:(void (^)(BOOL))completion {
    self.networkManager = [NetworkManager sharedInstance];
    [self.networkManager loadFeedWithCompliteon:^(NSData * data) {
        [self parseRowData:data completion:^(BOOL success) {
            completion(success);
        }];
    }];
}

- (void)parseRowData:(NSData *)data completion:(void (^)(BOOL))completion{
    RSSParser *parser = [RSSParser sharedInstance];
    [parser parseFeedWithData:data andArray:self.feedItemArray completion:^(BOOL success) {
        completion(success);
    }];
    [parser release];
}


- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [super dealloc];
}
@end
