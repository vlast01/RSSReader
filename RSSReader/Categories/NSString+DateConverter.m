//
//  NSString+DateConverter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import "NSString+DateConverter.h"
#import "NSDateFormatter+InitializingWithFormat.h"

@implementation NSString (DateConverter)

- (NSString *)parseDate:(NSString *)date {
    NSString *oldDateString = [[NSString alloc] initWithFormat:@"%@", date];
    NSDateFormatter *oldFormatter = [NSDateFormatter formatterWithFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *oldDate = [oldFormatter dateFromString:oldDateString];
    NSDateFormatter *newFormatter = [NSDateFormatter formatterWithFormat:@"yyyy/MM/dd"];
    NSString *newDateString = [newFormatter stringFromDate:oldDate];
    [oldDateString release];
    return newDateString;
}

@end
