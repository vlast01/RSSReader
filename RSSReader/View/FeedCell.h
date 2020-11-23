//
//  FeedCell.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *pubDate;
@property (nonatomic, retain) FeedItem *feedItem;

- (void)setupCell;
- (void)configureWithItem:(FeedItem *)item;

@end

NS_ASSUME_NONNULL_END
