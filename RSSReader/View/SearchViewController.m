//
//  SearchViewController.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import "SearchViewController.h"
#import "SearchFeedItem.h"
#import "AlertProtocol.h"
#import "FeedViewController.h"
#import "UIViewController+ActivityIndicator.h"
#import "FileManager.h"
#import "UIColor+ColorCategory.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AlertProtocol>

@property (nonatomic, retain)UISearchBar *searchBar;
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray<SearchFeedItem *>*itemsArray;

@end

CGFloat const kSearchBarBorderWidth = 1;

NSString * const kNavigationItemTitleText = @"Search feeds";
NSString * const kSearchBarPlaceholder = @"Enter site name";
NSString * const kSellIdentifier = @"cellId";
NSString * const kSectionHeaderTitle = @"RESULTS";
NSString * const kErrorText = @"Error";
NSString * const kCancelText = @"Cancel";
NSString * const kDirectFeedTitle = @"Feed";


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.presenter.delegate = self;
    [self addViews];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = kNavigationItemTitleText;
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
        _searchBar.placeholder = kSearchBarPlaceholder;
        _searchBar.layer.borderWidth = kSearchBarBorderWidth;
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
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSellIdentifier];
    }
    return _tableView;
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSellIdentifier];
    cell.textLabel.text = self.itemsArray[indexPath.row].title;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return kSectionHeaderTitle;
}

#pragma mark UITableViewDataDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self saveChoise:self.itemsArray[indexPath.row]];
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

    __block typeof(self) weakSelf = self;
    [self.presenter checkDirectLink:searchBar.text completion:^(NSError * error, NSMutableArray *  array) {
        if (array.count>0) {
            
            [self saveChoise:[self prepareItem:searchBar.text]];
            [weakSelf.navigationController pushViewController:[self prepareFeedControllerToPresent:array url:searchBar.text] animated:false];
       
        } else {
            NSMutableArray *itemsArray = [NSMutableArray new];
            weakSelf.itemsArray = itemsArray;

            [weakSelf.presenter searchFeeds:searchBar.text array:itemsArray completion:^{
                [weakSelf hideActivityIndicator];
                [weakSelf.tableView reloadData];
            }];
            [itemsArray release];
        }

    }];
}

- (FeedViewController *)prepareFeedControllerToPresent:(NSMutableArray *)array url:(NSString *)url{
    FeedViewController *directFeedController = [[FeedViewController alloc] initWithTitle:kDirectFeedTitle];
    directFeedController.feedItemArray = array;
    RSSParser *parser = [RSSParser new];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithArray:array networkManager:[NetworkManager sharedInstance] parser:parser url:url];
    directFeedController.presenter = presenter;
    [parser release];
    [presenter release];
    return [directFeedController autorelease];
}

- (SearchFeedItem *)prepareItem:(NSString *)url {
    SearchFeedItem *item = [SearchFeedItem new];
    item.title = kDirectFeedTitle;
    item.url = url;
    return [item autorelease];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrorText
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:kCancelText style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)saveChoise:(SearchFeedItem *)item{

    FileManager *fileManager = [[FileManager alloc] init];
    [fileManager writeToFile:item];
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
