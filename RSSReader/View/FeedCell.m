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
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UILabel *newsDescription;
@property (nonatomic, retain) UILabel *category;
@property (nonatomic, retain) UIStackView *additionalInfoStackView;
@property (nonatomic, retain) UIView *spacingView;

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
        [self setupLayout];
    }
    return self;
}

- (void)configureWithItem:(FeedItem *)item index:(int)index flag:(NSNumber *)isDescriptionShown{
    self.feedItem = item;
    self.index = index;
    self.isDescriptionShown = isDescriptionShown;
    self.title.text = self.feedItem.title;
    self.category.text = self.feedItem.category;
    self.newsDescription.text = self.feedItem.newsDescription;
    self.pubDate.text = self.feedItem.pubDate;
    switch ([self.isDescriptionShown intValue]) {
        case USCellStateShown:
            self.newsDescription.hidden = NO;
            [self.moreButton setTitle:[NSString stringWithFormat:@"Less %C", 0x2191] forState:UIControlStateNormal];
            break;
        case USCellStateHidden:
            self.newsDescription.hidden = YES;
            [self.moreButton setTitle:[NSString stringWithFormat:@"More %C", 0x2193] forState:UIControlStateNormal];
    }
}

- (void)setupLayout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.title];
    [self.stackView addArrangedSubview:self.additionalInfoStackView];
    [self.additionalInfoStackView addArrangedSubview:self.pubDate];
    [self.additionalInfoStackView addArrangedSubview:self.category];
    [self.additionalInfoStackView addArrangedSubview:self.spacingView];
    [self.additionalInfoStackView addArrangedSubview:self.moreButton];
    [self.stackView addArrangedSubview:self.newsDescription];
    
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
        _stackView.spacing = kCellSpacing;
    }
    return _stackView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.numberOfLines = 0;
    }
    _title.text = [[ _feedItem.title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    return _title;
}

- (UILabel *)pubDate {
    if (!_pubDate) {
        _pubDate = [UILabel new];
        _pubDate.font = [UIFont systemFontOfSize:kFontSize];
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

- (void)buttonTapped {
    [self.delegate changeFlagAndRefreshTableView:self.index];
}

- (UIStackView *)additionalInfoStackView {
    if (!_additionalInfoStackView) {
        _additionalInfoStackView = [UIStackView new];
        _additionalInfoStackView.axis = UILayoutConstraintAxisHorizontal;
        _additionalInfoStackView.spacing = kAdditionalStackViewSpacing;
        
    }
    return _additionalInfoStackView;
}

- (UILabel *)newsDescription {
    if (!_newsDescription) {
        _newsDescription = [UILabel new];
        _newsDescription.numberOfLines = 0;
    }
    switch ([_isDescriptionShown intValue]) {
        case USCellStateShown:
            _newsDescription.hidden = NO;
            break;
        case USCellStateHidden:
            _newsDescription.hidden = YES;
    }
    _newsDescription.text = _feedItem.newsDescription;
    return _newsDescription;
}

- (UILabel *)category {
    if (!_category) {
        _category = [UILabel new];
        _category.numberOfLines = 0;
        _category.translatesAutoresizingMaskIntoConstraints = NO;
        _category.font = [UIFont boldSystemFontOfSize:kFontSize];
    }
    _category.text = self.feedItem.category;
    return _category;
}

- (UIView *)spacingView {
    if (!_spacingView) {
        _spacingView = [UIView new];
    }
    return _spacingView;
}

- (void)dealloc {
    [_title release];
    [_pubDate release];
    [_feedItem release];
    [_stackView release];
    [_newsDescription release];
    [_moreButton release];
    [_additionalInfoStackView release];
    [_category release];
    [_spacingView release];
    [super dealloc];
}

@end
