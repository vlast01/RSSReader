//
//  UIViewController+ActivityIndicator.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 13.01.21.
//

#import "UIViewController+ActivityIndicator.h"

@implementation UIViewController (ActivityIndicator)

- (void)showActivityIndicator:(UIActivityIndicatorView *)spinner {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [spinner startAnimating];
}

- (void)hideActivityIndicator:(UIActivityIndicatorView *)spinner {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [spinner stopAnimating];
}

- (void)showRefreshAlertWithAlertActions:(UIAlertAction *)firstAction secondAction:(UIAlertAction *)secondAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reload feed?", nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
