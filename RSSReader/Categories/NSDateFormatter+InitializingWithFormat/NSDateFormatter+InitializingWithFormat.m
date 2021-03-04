//
//  NSDateFormatter+InitializingWithFormat.m
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import "NSDateFormatter+InitializingWithFormat.h"

@implementation NSDateFormatter (InitializingWithFormat)

+ (instancetype)formatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter autorelease];
}

@end
