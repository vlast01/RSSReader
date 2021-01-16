//
//  WebViewController.m
//  RSSReader
//
//  Created by Uladzislau Stankevich on 7.01.21.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <UIScrollViewDelegate>

@property (nonatomic, assign)WKWebView *webView;
@property (nonatomic, retain)UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain)UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, retain)UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, retain)UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, retain)UIBarButtonItem *safariBarButtonItem;
@property (nonatomic, retain)UIBarButtonItem *spacerBarButtonItem;
@property (nonatomic) CGFloat contentOffsetLastY;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupLayout];
    [self setupToolBar];
    [self openURL];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = [url retain];
    }
    return self;
}

- (void)setupLayout {
    [self.view addSubview:self.webView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.scrollView.delegate = self;
        _webView.allowsBackForwardNavigationGestures = true;
    }
    return _webView;
}

- (void)openURL {
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:nsrequest];
}

- (void)setupToolBar {
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self setToolbarItems:@[self.backBarButtonItem, self.spacerBarButtonItem, self.forwardBarButtonItem, self.spacerBarButtonItem, self.refreshBarButtonItem, self.spacerBarButtonItem, self.safariBarButtonItem, self.spacerBarButtonItem, self.stopBarButtonItem] animated:NO];
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                           target:self
                                                                           action:@selector(goBack)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                           target:self
                                                                           action:@selector(goForward)];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                           target:self
                                                                           action:@selector(refresh)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)safariBarButtonItem {
    if (!_safariBarButtonItem) {
        _safariBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(openInSafari)];
    }
    return _safariBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                           target:self
                                                                           action:@selector(stop)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)spacerBarButtonItem {
    if (!_spacerBarButtonItem) {
        _spacerBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:self
                                                                           action:@selector(stop)];
    }
    return _spacerBarButtonItem;
}


- (void)goBack {
    [self.webView goBack];
}

- (void)goForward {
    [self.webView goForward];
}

- (void)refresh {
    [self.webView reload];
}

- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:self.webView.URL
                                         options:@{}
                               completionHandler:nil];
}

- (void)stop {
    [self.webView stopLoading];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  self.contentOffsetLastY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  BOOL shouldHide = scrollView.contentOffset.y > self.contentOffsetLastY;
  [self.navigationController setNavigationBarHidden:shouldHide animated:true];
  [self.navigationController setToolbarHidden:shouldHide animated:true];
}

- (void)dealloc {
    [_backBarButtonItem release];
    [_forwardBarButtonItem release];
    [_refreshBarButtonItem release];
    [_safariBarButtonItem release];
    [_stopBarButtonItem release];
    [_spacerBarButtonItem release];
    [_url release];
    [super dealloc];
}

@end
