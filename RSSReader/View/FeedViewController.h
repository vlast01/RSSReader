//
//  FeedViewController.h
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController

- (id)initWithFeedItemArray:(NSMutableArray *)feedItemArray presenter:(FeedPresenter *)presenter;

@end

NS_ASSUME_NONNULL_END
