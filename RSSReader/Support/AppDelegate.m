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
    UINavigationController *navController = [UINavigationController new];
    [self.window makeKeyAndVisible];
    [window release];

    NetworkManager *manager = [NetworkManager new];
    
    SearchPresenter *presenter = [[SearchPresenter alloc] initWithNetworkManager:manager];
    [manager release];
    SearchViewController *searchViewController = [SearchViewController new];
    searchViewController.presenter = presenter;
    [presenter release];
    [navController pushViewController:searchViewController animated:false];
    
    FileManager *fileManager = [[FileManager alloc] init];
    SearchFeedItem *item = [fileManager readData];
    [fileManager release];
    if (item) {
        NSMutableArray *feedItemArray = [NSMutableArray new];
        FeedViewController *feed = [[FeedViewController alloc] initWithTitle:item.title];
        feed.feedItemArray = feedItemArray;
        RSSParser *parser = [RSSParser new];
        FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:feedItemArray networkManager:[NetworkManager sharedInstance] parser:parser url:item.url];
        feed.presenter = presenter;
        [navController pushViewController:feed animated:false];
        [parser release];
        [presenter release];
        [feed release];
        [feedItemArray release];
    }
    
    
    self.window.rootViewController = navController;
    [searchViewController release];
    [navController release];
    return YES;
}


- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
