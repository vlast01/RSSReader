//
//  FileManager.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import <Foundation/Foundation.h>
#import "SearchFeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject

- (void)writeToFile:(SearchFeedItem *)item;
- (SearchFeedItem *)readData ;

@end

NS_ASSUME_NONNULL_END
