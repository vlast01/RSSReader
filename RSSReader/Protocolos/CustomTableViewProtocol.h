//
//  CustomTableViewProtocol.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 14.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomTableViewProtocol <NSObject>

- (void)changeFlagAndRefreshTableView:(int)index;

@end

NS_ASSUME_NONNULL_END
