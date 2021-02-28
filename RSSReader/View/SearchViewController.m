//
//  SearchViewController.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchViewController.h"
#import "SearchFeedItem.h"
#import "ExceptionProtocol.h"
#import "FeedViewController.h"
#import "UIViewController+ActivityIndicator.h"
#import "FileManager.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ExceptionProtocol>

@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray<SearchFeedItem *>*itemsArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"AppBackground"];
    self.presenter.delegate = self;
    [self addViews];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Search feeds";
    [super viewWillAppear:animated];
}

- (void)addViews {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)setupLayout {
    
    [NSLayoutConstraint activateConstraints:@[
        [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.searchBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        _searchBar.placeholder = @"Enter site name";
        _searchBar.layer.borderWidth = 1;
        _searchBar.delegate = self;
        _searchBar.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1].CGColor;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cellId"];
    }
    return _tableView;
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.text = self.itemsArray[indexPath.row].title;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Results";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self saveChoiseAtIndexPath:indexPath];
    [self createAndPushFeedViewController:indexPath];
}

- (void)createAndPushFeedViewController:(NSIndexPath *)indexPath {
    NSMutableArray *feedItemArray = [NSMutableArray new];
    FeedViewController *feed = [[FeedViewController alloc] initWithTitle:self.itemsArray[indexPath.row].title];
    feed.feedItemArray = feedItemArray;
    RSSParser *parser = [RSSParser new];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:feedItemArray networkManager:[NetworkManager sharedInstance] parser:parser url:self.itemsArray[indexPath.row].url];
    feed.presenter = presenter;
    [parser release];
    [presenter release];
    [self.navigationController pushViewController:feed animated:false];
    [feed release];
    [feedItemArray release];
}

#pragma mark UISearchBarDelegate implementation

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self showActivityIndicator];
    NSMutableArray *itemsArray = [NSMutableArray new];
    self.itemsArray = itemsArray;
    __block typeof(self) weakSelf = self;
    [self.presenter searchFeeds:searchBar.text array:itemsArray completion:^{
        [weakSelf hideActivityIndicator];
        [weakSelf.tableView reloadData];
    }];
    [itemsArray release];
}

- (void)showException:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)saveChoiseAtIndexPath:(NSIndexPath *)indexPath{

    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager writeToFile:self.itemsArray[indexPath.row]];
    [fileManager release];

}

- (void)dealloc {
    [_searchBar release];
    [_itemsArray release];
    [_presenter release];
    [_tableView release];
    [super dealloc];
}



@end
