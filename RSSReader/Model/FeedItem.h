//
//  FeedItem.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedItem : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* newsDescription;
@property (nonatomic, copy) NSString* link;
@property (nonatomic, copy) NSString* pubDate;

@end

NS_ASSUME_NONNULL_END
