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

@property (nonatomic, retain, readonly) UILabel *title;
@property (nonatomic, retain, readonly) UILabel *pubDate;

- (void)setupCell;
- (void)setItem:(FeedItem *)item;

@end

NS_ASSUME_NONNULL_END
