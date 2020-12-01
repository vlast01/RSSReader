//
//  FeedViewController.m
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import "FeedViewController.h"
#import "FeedCell.h"
#import "FeedPresenter.h"
#import "FeedItem.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) FeedPresenter* presenter;
@property (nonatomic, retain) NSMutableArray<FeedItem*>* feedItemArray;

@end

@implementation FeedViewController

- (id)initWithFeedItemArray:(NSMutableArray *)feedItemArray andPresenter:(FeedPresenter *)presenter{
    self = [super init];
    if (self) {
        self.feedItemArray = feedItemArray;
        self.presenter = presenter;
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    [self tableView];
    [self setupConstraints];
    [self loadNews];
}

- (void)loadNews {
    [self.presenter loadNewsWithCompletion:^(NSError *error) {
        if (!error) {
            [self.tableView reloadData];
        }
        else {
            [self showError:error];
        }
    }];
}

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[NSString stringWithFormat:@"%@", error.localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:FeedCell.class forCellReuseIdentifier:@"cellId"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
    return UITableViewAutomaticDimension;
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
