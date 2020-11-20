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

@property (nonatomic, retain)NSMutableArray<FeedItem *>* array;
@property (nonatomic, retain)NSString *currentElement;

- (void)parseFeedWithData:(NSData *)data andArray:(NSMutableArray<FeedItem *>*)array completion:(void(^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
