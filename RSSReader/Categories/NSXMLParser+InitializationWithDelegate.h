//
//  NSXMLParser+InitializationWithDelegate.h
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSXMLParser (InitializationWithDelegate)

+ (instancetype)parserWithData:(NSData *)data
                      delegate:(id<NSXMLParserDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
