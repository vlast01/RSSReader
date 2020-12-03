//
//  NetworkManager.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>

@class FeedItem;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadFeedWithCompletion:(void (^)(NSData* _Nullable, NSError* _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
