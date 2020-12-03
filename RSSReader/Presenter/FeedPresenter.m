//
//  FeedPresenter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedPresenter.h"
#import "NetworkManager.h"
#import "FeedItem.h"
#import "RSSParser.h"

@interface FeedPresenter ()

@property (nonatomic, retain) NetworkManager *networkManager;
@property (nonatomic, retain) RSSParser *parser;
@property (nonatomic, retain) NSMutableArray* feedItemArray;

@end

@implementation FeedPresenter

- (id)initWithArray:(NSMutableArray *)array networkManager:(NetworkManager *)manager parser:(RSSParser *)parser{
    if (self = [super init]) {
        if (array) {
            _feedItemArray = array;
            [_feedItemArray retain];
        }
        else {
            _feedItemArray = [NSMutableArray new];
        }
        _networkManager = [manager retain];
        _parser = [parser retain];
    }
    return self;
}

- (void)loadNewsWithCompletion:(void (^)(NSError *))completion {
    [self.networkManager loadFeedWithCompletion:^(NSData * data, NSError *error) {
        if (error) {
            completion(error);
        }
        else {
            [self parseRowData:data completion:completion];
        }
    }];
}

- (void)parseRowData:(NSData *)data completion:(void (^)(NSError *))completion{
    [self.parser parseFeedWithData:data andArray:self.feedItemArray completion:^(NSError *error) {
        completion(error);
    }];
}

- (void)dealloc {
    [_networkManager release];
    [_feedItemArray release];
    [_parser release];
    [super dealloc];
}
@end
