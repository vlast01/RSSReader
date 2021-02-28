//
//  SearchViewController.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import <UIKit/UIKit.h>
#import "SearchPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

@property (nonatomic, retain)SearchPresenter *presenter;

@end

NS_ASSUME_NONNULL_END
