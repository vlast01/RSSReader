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
#import "UIColor+ColorCategory.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, CustomTableViewProtocol>

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, retain) NSMutableDictionary *cellHeightsDictionary;
@property (nonatomic, retain) UIActivityIndicatorView* spinner;

@end

NSString * const kErrorTitle = @"Error";
NSString * const kErrorRetry = @"Retry";
NSString * const kCellID = @"cellId";
NSString * const kReloadAlertMessage = @"Reload feed?";
NSString * const kYesActionTitle = @"Yes";
NSString * const kNoActionTitle = @"NO";

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
    [self.view addSubview:self.spinner];
}

- (void)setupLayout {
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];
}

- (void)loadNews {
    [self showActivityIndicator:self.spinner];
    __block typeof(self) weakSelf = self;
    [self.presenter asyncLoadNewsWithCompletion:^(NSError *error) {
        [weakSelf hideActivityIndicator:self.spinner];
        if (!error) {
            [weakSelf.tableView reloadData];
        }
        else {
            [weakSelf showError:error];
        }
    }];
}

- (void)showError:(NSError *)error {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(kErrorTitle, nil)
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* retry = [UIAlertAction actionWithTitle:NSLocalizedString(kErrorRetry, nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
            [self loadNews];
        }];
        [alert addAction:retry];
        [self presentViewController:alert animated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:FeedCell.class forCellReuseIdentifier:kCellID];
        _tableView.backgroundColor = [UIColor backgroundColor];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _spinner;
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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self showRefreshAlert];
    }
}

- (void)showRefreshAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(kReloadAlertMessage, nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* Yes = [UIAlertAction actionWithTitle:NSLocalizedString(kYesActionTitle, nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
        [self.feedItemArray removeAllObjects];
        [self loadNews];
    }];
    
    UIAlertAction* No = [UIAlertAction actionWithTitle:NSLocalizedString(kNoActionTitle, nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
    }];
    [alert addAction:Yes];
    [alert addAction:No];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    [_tableView release];
    [_presenter release];
    [_feedItemArray release];
    [_pageTitle release];
    [_cellHeightsDictionary release];
    [_spinner release];
    [super dealloc];
}

@end
