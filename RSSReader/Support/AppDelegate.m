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
#import "RSSParser.h"
#import "SearchPresenter.h"
#import "SearchViewController.h"
#import "FileManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    UINavigationController *navController = [self prepareNavController];
    [self.window makeKeyAndVisible];
    [window release];

    [navController pushViewController:[self prepareSearchViewController] animated:false];
    
    SearchFeedItem *item = [self getLastChoise];

    if (item) {
        [navController pushViewController:[self prepareFeedViewControllerWithItem:item] animated:false];
    }
    
    self.window.rootViewController = navController;
    return YES;
}

- (SearchFeedItem *)getLastChoise {
    FileManager *fileManager = [[FileManager alloc] init];
    SearchFeedItem *item = [fileManager readData];
    [fileManager release];
    return item;
}

- (UINavigationController *)prepareNavController {
    UINavigationController *navController = [UINavigationController new];
    [navController.navigationBar setTintColor:UIColor.blackColor];
    navController.navigationBar.backgroundColor = UIColor.whiteColor;
    return [navController autorelease];
}

- (FeedViewController *)prepareFeedViewControllerWithItem:(SearchFeedItem *)item{
    NSMutableArray *feedItemArray = [NSMutableArray new];
    FeedViewController *feed = [[FeedViewController alloc] initWithTitle:item.title];
    feed.feedItemArray = feedItemArray;
    RSSParser *parser = [RSSParser new];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:feedItemArray networkManager:[NetworkManager sharedInstance] parser:parser url:item.url];
    feed.presenter = presenter;
    [parser release];
    [presenter release];
    [feedItemArray release];
    return [feed autorelease];
}

- (SearchViewController *)prepareSearchViewController {
    SearchPresenter *presenter = [[SearchPresenter alloc] initWithNetworkManager:[NetworkManager sharedInstance]];
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.presenter = presenter;
    [presenter release];
    return [searchViewController autorelease];
}


- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
