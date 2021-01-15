//
//  FeedViewController.m
//  RSSReader
//
//  Created by Владислав Станкевич on 17.11.20.
//

#import "FeedViewController.h"
#import "FeedCell.h"
#import "FeedItem.h"
#import "UIViewController+ActivityIndicator.h"
#import "CustomTableViewProtocol.h"
#import "WebViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, CustomTableViewProtocol>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) FeedPresenter* presenter;
@property (nonatomic, retain) NSMutableArray<FeedItem*>* feedItemArray;
@property (nonatomic, retain) NSMutableArray *flagsArray;
@property (nonatomic, copy) NSString *pageTitle;

@end

NSString * const kPageTitle = @"TUT.BY";
NSString * const kErrorTitle = @"Error";

@implementation FeedViewController

- (id)initWithFeedItemArray:(NSMutableArray *)feedItemArray presenter:(FeedPresenter *)presenter{
    self = [super init];
    if (self) {
        _feedItemArray = [feedItemArray retain];
        _presenter = [presenter retain];
        _pageTitle = kPageTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [self loadNews];
    self.navigationItem.title = self.pageTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)setupLayout {
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)loadNews {
    [self showActivityIndicator];
    [self.presenter asyncLoadNewsWithCompletion:^(NSError *error) {
        [self hideActivityIndicator];
        if (!error) {
            [self fillFlagsArray];
            [self.tableView reloadData];
        }
        else {
            [self showError:error];
        }
    }];
}

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrorTitle
                                                                   message:error.localizedDescription
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
    }
    return _tableView;
}

- (NSMutableArray *)flagsArray {
    if (!_flagsArray) {
        _flagsArray = [NSMutableArray new];
    }
    return _flagsArray;
}

#pragma mark TableViewDataSourse implementation

- (void)fillFlagsArray {
    [self.flagsArray removeAllObjects];
    for (int i = 0; i < self.feedItemArray.count; i++) {
        [self.flagsArray addObject:@0];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.isDescriptionShown = self.flagsArray[indexPath.row];
    cell.delegate = self;
    [cell configureWithItem: self.feedItemArray[indexPath.row] index:(int)indexPath.row];
    [cell setupCell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItemArray.count;
}

#pragma mark TableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *url = [NSURL URLWithString:self.feedItemArray[indexPath.row].link];
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

#pragma mark CustomTableViewProtocol implementation

- (void)changeFlag:(int)index {
    if ([self.flagsArray[index] isEqual:@0]) {
        self.flagsArray[index] = @1;
    }
    else {
        self.flagsArray[index] = @0;
    }
}

- (void)refreshTableView:(int)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealloc {
    [_tableView release];
    [_presenter release];
    [_feedItemArray release];
    [_flagsArray release];
    [_pageTitle release];
    [super dealloc];
}

@end
