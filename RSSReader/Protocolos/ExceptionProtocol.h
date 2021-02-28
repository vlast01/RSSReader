//
//  ExceptionProtocol.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 25.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExceptionProtocol <NSObject>

- (void)showException:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
