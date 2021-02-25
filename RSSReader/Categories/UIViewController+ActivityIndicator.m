//
//  UIViewController+ActivityIndicator.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 13.01.21.
//

#import "UIViewController+ActivityIndicator.h"

@implementation UIViewController (ActivityIndicator)

- (void)showActivityIndicator {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

- (void)hideActivityIndicator {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

@end
