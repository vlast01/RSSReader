//
//  RSSParser.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSParser : NSObject 

- (void)parseFeedWithData:(NSData *)data array:(NSMutableArray<FeedItem *>*)array completion:(void(^)(NSError* _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
