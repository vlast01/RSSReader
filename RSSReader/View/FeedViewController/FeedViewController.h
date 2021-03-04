//
//  FeedViewController.h
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"
#import "USCellStates.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController

@property (nonatomic, retain) NSMutableArray<FeedItem*>* feedItemArray;
@property (nonatomic, retain) FeedPresenter* presenter;

- (id)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
