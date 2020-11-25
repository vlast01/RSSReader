//
//  AppDelegate.m
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "FeedPresenter.h"
#import "NetworkManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    UINavigationController *navController = [UINavigationController new];
    NSMutableArray *feedItemArray = [NSMutableArray new];
    FeedViewController *feed = [FeedViewController new];
    feed.feedItemArray = feedItemArray;
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:feedItemArray networkManager:[NetworkManager sharedInstance] parser:[RSSParser sharedInstance]];
    feed.presenter = presenter;
    [presenter release];
    [navController pushViewController:feed animated:false];
    [self.window makeKeyAndVisible];
    [feed release];
    [window release];
    self.window.rootViewController = navController;
    [navController release];
    [feedItemArray release];
    return YES;
}


- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
