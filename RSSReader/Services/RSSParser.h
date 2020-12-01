//
//  RSSParser.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>

@class FeedItem;

NS_ASSUME_NONNULL_BEGIN

@interface RSSParser : NSObject 

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;
- (void)parseFeedWithData:(NSData *)data andArray:(NSMutableArray<FeedItem *>*)array completion:(void(^)(NSError* _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
