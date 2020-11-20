//
//  FeedViewController.h
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) FeedPresenter* presenter;
@property (nonatomic, retain) NSMutableArray<FeedItem*>* feedItemArray;

@end

NS_ASSUME_NONNULL_END
