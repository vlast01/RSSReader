//
//  FeedPresenter.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#include "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPresenter : NSObject

@property (nonatomic, retain) NetworkManager *networkManager;
@property (nonatomic, retain) NSMutableArray* feedItemArray;

- (id)initWithArray:(NSMutableArray<FeedItem*>*)array;
//- (id)initWithEmptyArray;
- (void)loadNewsWithCompletion:(void(^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
