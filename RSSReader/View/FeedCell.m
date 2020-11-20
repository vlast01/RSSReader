//
//  FeedCell.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedCell.h"

@implementation FeedCell

- (void)setupCell {
    self.backgroundColor = UIColor.whiteColor;
    [self setupTitle];
    [self setupPubDate];
    [self setupConstraints];
}

- (void)setupTitle {
    UILabel *title = [[UILabel alloc] init];
    self.title = title;
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    [title release];
    [self addSubview:self.title];
    if (self.feedItem.title != nil) {
        self.title.text = self.feedItem.title;
    }
}

- (void)setupPubDate {
    UILabel *pubDate = [[UILabel alloc] init];
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
        [self.title.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [self.title.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.title.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.pubDate.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [self.pubDate.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:20],
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
    [super dealloc];
}

@end
