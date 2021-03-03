//
//  AlertProtocol.h
//  RSSReader
//
//  Created by Uladzislau Stankevich on 3.03.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AlertProtocol <NSObject>

- (void)showAlert:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
