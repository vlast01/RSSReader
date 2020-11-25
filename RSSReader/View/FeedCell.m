//
//  FeedCell.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedCell.h"

@implementation FeedCell

int const kCellSpacing = 10;

- (void)configureWithItem:(FeedItem *)item {
    self.feedItem = item;
}

- (void)setupCell {
    self.backgroundColor = UIColor.whiteColor;
    [self setupTitle];
    [self setupPubDate];
    [self setupConstraints];
}

- (void)setupTitle {
    UILabel *title = [UILabel new];
    self.title = title;
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    self.title.numberOfLines = 0;
    [title release];
    [self addSubview:self.title];
    if (self.feedItem.title != nil) {
        self.title.text = self.feedItem.title;
    }
}

- (void)setupPubDate {
    UILabel *pubDate = [UILabel new];
    self.pubDate = pubDate;
    self.pubDate.translatesAutoresizingMaskIntoConstraints = NO;
    self.pubDate.font = [UIFont systemFontOfSize:10];
    [pubDate release];
    [self addSubview:self.pubDate];
    if (self.feedItem.pubDate != nil) {
        self.pubDate.text = self.feedItem.pubDate;
    }
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.title.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:kCellSpacing],
        [self.title.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-kCellSpacing],
        [self.title.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.title.heightAnchor constraintEqualToConstant:50],
        [self.pubDate.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-kCellSpacing],
        [self.pubDate.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-kCellSpacing],
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
    [super dealloc];
}

@end
