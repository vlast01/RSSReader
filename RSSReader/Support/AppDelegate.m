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
    
    
    self.window.rootViewController = navController;
    [searchViewController release];
    [navController release];
  //  [feedItemArray release];
    return YES;
}


- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
