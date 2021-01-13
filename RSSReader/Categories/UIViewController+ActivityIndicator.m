//
//  UIViewController+ActivityIndicator.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 13.01.21.
//

#import "UIViewController+ActivityIndicator.h"

@implementation UIViewController (ActivityIndicator)

- (void)showActivitiIndicator {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

- (void)hideActivitiIndicator {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}


@end
