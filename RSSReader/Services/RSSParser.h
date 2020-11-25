//
//  RSSParser.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RSSParser : NSObject <NSXMLParserDelegate>

@property (atomic, retain)NSMutableArray<FeedItem *>* array;
@property (atomic, retain)NSString *currentElement;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;
- (void)parseFeedWithData:(NSData *)data andArray:(NSMutableArray<FeedItem *>*)array completion:(void(^)(NSError* _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
