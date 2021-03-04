//
//  SearchFeedItem.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchFeedItem : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* url;

@end

NS_ASSUME_NONNULL_END
