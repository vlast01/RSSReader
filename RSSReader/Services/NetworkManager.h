//
//  NetworkManager.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

- (void)loadFeedWithCompliteon:(void (^)(NSData*))completion;

@end

NS_ASSUME_NONNULL_END
