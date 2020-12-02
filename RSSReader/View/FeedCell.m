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

- (void)setItem:(FeedItem *)item {
    self.feedItem = item;
}

- (void)setupCell {
    self.backgroundColor = UIColor.whiteColor;
    [self setupLayout];
}

- (void)setupLayout {
    [self.contentView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.title];
    [self.stackView addArrangedSubview:self.pubDate];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kCellSpacing],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kCellSpacing],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing],
    ]];
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.stackView];
        _stackView.spacing = 10;
    }
    return _stackView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.numberOfLines = 0;
        _title.text = _feedItem.title;
    }
    return _title;
}

- (UILabel *)pubDate {
    if (!_pubDate) {
        _pubDate = [UILabel new];
        _pubDate.font = [UIFont systemFontOfSize:10];
        _pubDate.text = self.feedItem.pubDate;
    }
    return _pubDate;
}

- (void)dealloc {
    [_title release];
    [_pubDate release];
    [_feedItem release];
    [_stackView release];
    [super dealloc];
}

@end
