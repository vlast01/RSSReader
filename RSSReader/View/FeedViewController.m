//
//  FeedViewController.m
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import "FeedViewController.h"
#import "FeedCell.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    if (self.feedItemArray == nil) {
        [self setupFeedItemArray];
    }
    [self setupPresenter];
    if (self.tableView == nil) {
        [self setupTableView];
    }
    [self setupConstraints];
    [self loadNews];
}

- (void)setupPresenter {
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:self.feedItemArray];
    self.presenter = presenter;
    [presenter release];
}

- (void)setupFeedItemArray {
    NSMutableArray *feedItemArray = [NSMutableArray new];
    self.feedItemArray = feedItemArray;
    [feedItemArray release];
}

- (void)loadNews {
    [self.presenter loadNewsWithCompletion:^(BOOL success) {
        if (success) {
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Loading error");
        }
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:FeedCell.class forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:self.tableView];
    [tableView release];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (self.feedItemArray.count != 0) {
        [cell configureWithItem: self.feedItemArray[indexPath.row]];
    }
    [cell setupCell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] openURL:[[[NSURL alloc] initWithString:self.feedItemArray[indexPath.row].link] autorelease]];
}

- (void)dealloc {
    [_tableView release];
    [_presenter release];
    [_feedItemArray release];
    [super dealloc];
}

@end
