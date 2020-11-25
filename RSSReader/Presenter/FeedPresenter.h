//
//  FeedPresenter.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "FeedItem.h"
#import "RSSParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject

- (id)initWithArray:(NSMutableArray<FeedItem*>*)array networkManager:(NetworkManager *)manager parser:(RSSParser *)parser;
//- (id)initWithNetworkManager:(NetworkManager *)manager parser:(RSSParser *)parser;
- (void)loadNewsWithCompletion:(void(^)( NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
