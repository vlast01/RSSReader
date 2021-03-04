//
//  NSXMLParser+InitializationWithDelegate.m
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import "NSXMLParser+InitializationWithDelegate.h"

@implementation NSXMLParser (InitializationWithDelegate)

+ (instancetype)parserWithData:(NSData *)data
                      delegate:(id<NSXMLParserDelegate>)delegate {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = delegate;
    return [parser autorelease];
}

@end
