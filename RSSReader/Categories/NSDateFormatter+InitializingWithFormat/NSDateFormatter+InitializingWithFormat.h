//
//  NSDateFormatter+InitializingWithFormat.h
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (InitializingWithFormat)

+ (instancetype)formatterWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
