//
//  FeedCell.h
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"
#import "CustomTableViewProtocol.h"
#import "USCellStates.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell

@property (nonatomic, retain, readonly) UILabel *title;
@property (nonatomic, retain, readonly) UILabel *pubDate;
@property (nonatomic, assign) NSNumber *isDescriptionShown;
@property (nonatomic, weak) id <CustomTableViewProtocol> delegate;
@property (nonatomic, assign) int index;

- (void)configureWithItem:(FeedItem *)item index:(int)index flag:(NSNumber *)isDescriptionShown ;

@end

NS_ASSUME_NONNULL_END
