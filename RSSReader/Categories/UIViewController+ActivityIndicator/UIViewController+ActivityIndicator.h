//
//  UIViewController+ActivityIndicator.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 13.01.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ActivityIndicator)

- (void)showActivityIndicator:(UIActivityIndicatorView *)spinner;
- (void)hideActivityIndicator:(UIActivityIndicatorView *)spinner;
- (void)showRefreshAlertWithAlertActions:(UIAlertAction *)firstAction secondAction:(UIAlertAction *)secondAction;

@end

NS_ASSUME_NONNULL_END
