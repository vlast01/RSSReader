//
//  WebViewController.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 7.01.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController

@property (nonatomic, retain, readonly)NSURL *url;
- (instancetype) initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
