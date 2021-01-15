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
@property (nonatomic, retain) UIStackView *stackView;
@property (nonatomic, retain) UIView *buttonView;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UILabel *newsDescription;
@property (nonatomic, retain) UILabel *category;
@property (nonatomic, retain) UIStackView *descriptionStackView;

@end

int const kCellSpacing = 10;

@implementation FeedCell

- (void)configureWithItem:(FeedItem *)item index:(int)index{
    self.feedItem = item;
    self.index = index;
}

- (void)setupCell {
    self.backgroundColor = UIColor.whiteColor;
    [self setupLayout];
}

- (void)setupLayout {
    [self.contentView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.title];
    [self.stackView addArrangedSubview:self.category];
    [self.stackView addArrangedSubview:self.pubDate];
    [self.stackView addArrangedSubview:self.buttonView];
    [self.buttonView addSubview:self.moreButton];
    [self.stackView addArrangedSubview:self.descriptionStackView];
    [self.descriptionStackView addArrangedSubview:self.newsDescription];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:kCellSpacing],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-kCellSpacing],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kCellSpacing],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kCellSpacing],
        [self.buttonView.heightAnchor constraintEqualToConstant:3*kCellSpacing],
        [self.moreButton.centerYAnchor constraintEqualToAnchor:self.buttonView.centerYAnchor],
        [self.moreButton.trailingAnchor constraintEqualToAnchor:self.buttonView.trailingAnchor],
        [self.moreButton.heightAnchor constraintEqualToConstant:3*kCellSpacing],
        [self.moreButton.widthAnchor constraintEqualToConstant:6*kCellSpacing],
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
    }
    _title.text = _feedItem.title;
    return _title;
}

- (UILabel *)pubDate {
    if (!_pubDate) {
        _pubDate = [UILabel new];
        _pubDate.font = [UIFont systemFontOfSize:10];
    }
    _pubDate.text = self.feedItem.pubDate;
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

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [UIView new];
    }
    return _buttonView;
}

- (void)buttonTapped {
    if ([self.isDescriptionShown isEqual:@1]) {
        self.isDescriptionShown = @0;
    }
    else {
        self.isDescriptionShown = @1;
    }
    [self.delegate changeFlag:self.index];
    [self.delegate refreshTableView:self.index];
}

- (UIStackView *)descriptionStackView {
    if (!_descriptionStackView) {
        _descriptionStackView = [UIStackView new];
    }
    return _descriptionStackView;
}

- (UILabel *)newsDescription {
    if (!_newsDescription) {
        _newsDescription = [UILabel new];
        _newsDescription.numberOfLines = 0;
    }
    if ([_isDescriptionShown  isEqual: @1]) {
        _descriptionStackView.hidden = NO;
        [_moreButton setTitle:[NSString stringWithFormat:@"Less %C", 0x2191] forState:UIControlStateNormal];
    }
    else {
        _descriptionStackView.hidden = YES;
        [_moreButton setTitle:[NSString stringWithFormat:@"More %C", 0x2193] forState:UIControlStateNormal];
    }
    if (_feedItem.newsDescription != nil) {
        _newsDescription.text = _feedItem.newsDescription;
    }
    return _newsDescription;
}

- (UILabel *)category {
    if (!_category) {
        _category = [UILabel new];
        _category.numberOfLines = 0;
        _category.translatesAutoresizingMaskIntoConstraints = NO;
        _category.font = [UIFont boldSystemFontOfSize:10];
    }
    _category.text = self.feedItem.category;
    return _category;
}

- (void)dealloc {
    [_title release];
    [_pubDate release];
    [_feedItem release];
    [_stackView release];
    [_buttonView release];
    [_newsDescription release];
    [_moreButton release];
    [_descriptionStackView release];
    [_category release];
    [super dealloc];
}

@end
