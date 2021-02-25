//
//  FeedCell.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "FeedCell.h"

@interface FeedCell ()

@property (nonatomic, retain) FeedItem *feedItem;
@property (nonatomic, retain, readwrite) UILabel *title;
@property (nonatomic, retain, readwrite) UILabel *pubDate;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UILabel *newsDescription;
@property (nonatomic, retain) UILabel *category;

@property (nonatomic, retain) NSLayoutConstraint *descriptionLeft;
@property (nonatomic, retain) NSLayoutConstraint *descriptionRight;
@property (nonatomic, retain) NSLayoutConstraint *descriptionTop;
@property (nonatomic, retain) NSLayoutConstraint *descriptionBottom;
@property (nonatomic, retain) NSLayoutConstraint *buttonBottom;

@end

int const kCellSpacing = 10;
int const kButtonHeight = 30;
int const kButtonWidth = 60;
int const kFontSize = 10;
int const kAdditionalStackViewSpacing = 5;

@implementation FeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"AppBackground"];
        self.descriptionTop = [self.newsDescription.topAnchor constraintEqualToAnchor:self.moreButton.bottomAnchor constant:kCellSpacing];
        self.descriptionBottom = [self.newsDescription.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kCellSpacing];
        self.descriptionLeft = [self.newsDescription.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing];
        self.descriptionRight = [self.newsDescription.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing];

        self.buttonBottom = [self.moreButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kCellSpacing];
        self.buttonBottom.priority = 500;
        [self addViews];
        [self setupLayout];
    }
    return self;
}

- (void)configureWithItem:(FeedItem *)item index:(int)index {
    self.feedItem = item;
    self.index = index;
    self.title.text = [[self.feedItem.title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    self.category.text = self.feedItem.category;
    self.pubDate.text = self.feedItem.pubDate;
    if (self.feedItem.isDescriptionShown) {
        self.newsDescription.text = self.feedItem.newsDescription;
        [NSLayoutConstraint activateConstraints:@[self.descriptionTop, self.descriptionLeft, self.descriptionRight, self.descriptionBottom
        ]];
        [self.moreButton setTitle:[NSString stringWithFormat:@"Less %C", 0x2191] forState:UIControlStateNormal];
    }
    else {
        self.newsDescription.text = @"";
        [NSLayoutConstraint deactivateConstraints:@[self.descriptionTop, self.descriptionLeft, self.descriptionRight, self.descriptionBottom
        ]];
        [self.moreButton setTitle:[NSString stringWithFormat:@"More %C", 0x2193] forState:UIControlStateNormal];
    }}

- (void)addViews {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.pubDate];
    [self.contentView addSubview:self.category];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.newsDescription];
}

- (void)setupLayout {
    [NSLayoutConstraint activateConstraints:@[
        [self.title.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kCellSpacing],
        [self.title.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing],
        [self.title.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing],

        [self.pubDate.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing],
        [self.pubDate.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:kCellSpacing],

        [self.category.leadingAnchor constraintEqualToAnchor:self.pubDate.trailingAnchor constant:kCellSpacing],
        [self.category.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:kCellSpacing],
        
        [self.moreButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing],
        [self.moreButton.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:kCellSpacing],
        self.buttonBottom,
    ]];
}


- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.numberOfLines = 0;
        _title.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _title;
}

- (UILabel *)pubDate {
    if (!_pubDate) {
        _pubDate = [UILabel new];
        _pubDate.font = [UIFont systemFontOfSize:kFontSize];
        _pubDate.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pubDate;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton new];
        [_moreButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
        _moreButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_moreButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UILabel *)newsDescription {
    if (!_newsDescription) {
        _newsDescription = [UILabel new];
        _newsDescription.numberOfLines = 0;
        _newsDescription.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _newsDescription;
}

- (UILabel *)category {
    if (!_category) {
        _category = [UILabel new];
        _category.numberOfLines = 0;
        _category.translatesAutoresizingMaskIntoConstraints = NO;
        _category.font = [UIFont boldSystemFontOfSize:kFontSize];
    }
    return _category;
}

- (void)buttonTapped {
    [self changeState];
    [self.delegate refreshTableViewCell:self.index];
}

- (void)changeState {
        self.feedItem.isDescriptionShown = !self.feedItem.isDescriptionShown;
}

- (void)dealloc {
    [_title release];
    [_pubDate release];
    [_feedItem release];
    [_newsDescription release];
    [_moreButton release];
    [_category release];
    [_buttonBottom release];
    [_descriptionTop release];
    [_descriptionLeft release];
    [_descriptionRight release];
    [_descriptionBottom release];
    [super dealloc];
}

@end
