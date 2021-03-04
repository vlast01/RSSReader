//
//  NSString+DateConverter.h
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DateConverter)

- (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)initialFormat toFormat:(NSString *)desiredFormat;

@end

NS_ASSUME_NONNULL_END
