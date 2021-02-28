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
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, retain) NSMutableDictionary *cellHeightsDictionary;

@end

NSString * const kPageTitle = @"TUT.BY";
NSString * const kErrorTitle = @"Error";
NSString * const kErrorRetry = @"Retry";
NSString * const kCellID = @"cellId";

@implementation FeedViewController

- (id)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _pageTitle = [title retain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    [self setupLayout];
    [self loadNews];
    self.navigationItem.title = self.pageTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)addViews {
    [self.view addSubview:self.tableView];
}

- (void)setupLayout {
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)loadNews {
    [self showActivityIndicator];
    __block typeof(self) weakSelf = self;
    [self.presenter asyncLoadNewsWithCompletion:^(NSError *error) {
        [weakSelf hideActivityIndicator];
        if (!error) {
            [weakSelf.tableView reloadData];
        }
        else {
            [weakSelf showError:error];
        }
    }];
}

- (void)showError:(NSError *)error {

    @try {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrorTitle
//                                                                       message:error.localizedDescription
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* retry = [UIAlertAction actionWithTitle:kErrorRetry
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//            [self loadNews];
//        }];
//        [alert addAction:retry];
//        [self presentViewController:alert animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        
    }
 
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:FeedCell.class forCellReuseIdentifier:kCellID];
    }
    return _tableView;
}

- (NSMutableDictionary *)cellHeightsDictionary {
    if (!_cellHeightsDictionary) {
        _cellHeightsDictionary = [NSMutableDictionary new];
    }
    return _cellHeightsDictionary;
}

#pragma mark TableViewDataSourse implementation

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    [cell configureWithItem: self.feedItemArray[indexPath.row] index:(int)indexPath.row];
    cell.delegate = self;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.cellHeightsDictionary setObject:@(cell.frame.size.height) forKey:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.cellHeightsDictionary objectForKey:indexPath];
    return [height boolValue] ? height.doubleValue : UITableViewAutomaticDimension;
}

#pragma mark CustomTableViewProtocol implementation

- (void)refreshTableViewCell:(int)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView performBatchUpdates:^{
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } completion:nil];
}

- (void)dealloc {
    [_tableView release];
    [_presenter release];
    [_feedItemArray release];
    [_pageTitle release];
    [_cellHeightsDictionary release];
    [super dealloc];
}

@end
