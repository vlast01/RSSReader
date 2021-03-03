//
//  SearchPresenter.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import <Foundation/Foundation.h>
#import "SearchFeedItem.h"
#import "NetworkManager.h"
#import "AlertProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPresenter : NSObject

@property (nonatomic, assign) id <AlertProtocol> delegate;

- (id)initWithNetworkManager:(NetworkManager *)manager;
- (void)searchFeeds:(NSString *)url array:(NSMutableArray<SearchFeedItem *> *)array completion:(void (^)(void))completion;
- (void)checkDirectLink:(NSString *)url completion:(void (^)(NSError *, NSMutableArray *array))completion;

@end

NS_ASSUME_NONNULL_END
