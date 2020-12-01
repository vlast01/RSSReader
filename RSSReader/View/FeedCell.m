//
//  FeedCell.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedCell.h"
#import "FeedItem.h"

@interface FeedCell ()

@property (nonatomic, retain) FeedItem *feedItem;
@property (nonatomic, retain, readwrite) UILabel *title;
@property (nonatomic, retain, readwrite) UILabel *pubDate;
@property (nonatomic, retain) UIStackView *stackView;

@end

int const kCellSpacing = 10;

@implementation FeedCell

- (void)configureWithItem:(FeedItem *)item {
    self.feedItem = item;
}

- (void)setupCell {
    self.backgroundColor = UIColor.whiteColor;
    [self setupStackView];
    [self setupTitle];
    [self setupPubDate];
    [self setupConstraints];
}

- (void)setupStackView {
    if (!self.stackView) {
        UIStackView *stackView = [UIStackView new];
        self.stackView = stackView;
        [stackView release];
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.stackView];
        self.stackView.spacing = 10;
    }
}

- (void)setupTitle {
    if (!self.title) {
        UILabel *title = [UILabel new];
        self.title = title;
        self.title.translatesAutoresizingMaskIntoConstraints = NO;
        self.title.numberOfLines = 0;
        [title release];
        [self.stackView addArrangedSubview:self.title];
    }
    if (self.feedItem.title) {
        self.title.text = self.feedItem.title;
    }
}

- (void)setupPubDate {
    if (!self.pubDate) {
        UILabel *pubDate = [UILabel new];
        self.pubDate = pubDate;
        self.pubDate.translatesAutoresizingMaskIntoConstraints = NO;
        self.pubDate.font = [UIFont systemFontOfSize:10];
        [pubDate release];
        [self.stackView addArrangedSubview:self.pubDate];
    }
    if (self.feedItem.pubDate) {
        self.pubDate.text = self.feedItem.pubDate;
    }
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kCellSpacing],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kCellSpacing],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing],
    ]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.title.text = @"";
    self.pubDate.text = @"";
}

- (void)dealloc {
    [_title release];
    [_pubDate release];
    [_feedItem release];
    [_stackView release];
    [super dealloc];
}

@end
