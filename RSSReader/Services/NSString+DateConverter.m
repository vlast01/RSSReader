//
//  NSString+DateConverter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import "NSString+DateConverter.h"

@implementation NSString (DateConverter)

- (NSString *)parseDate:(NSString *)date {
    NSString *oldDateString = [[NSString alloc] initWithFormat:@"%@", date];
    NSDateFormatter *oldFormatter = [self setupOldFormatter];
    NSDate *oldDate = [oldFormatter dateFromString:oldDateString];
    NSDateFormatter *newFormatter = [self setupNewFormatter];
    NSString *newDateString = [newFormatter stringFromDate:oldDate];
    [oldDateString release];
    return newDateString;
}

- (NSDateFormatter *)setupOldFormatter {
    NSDateFormatter *oldFormatter = [NSDateFormatter new];
    [oldFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    return [oldFormatter autorelease];
}

- (NSDateFormatter *)setupNewFormatter {
    NSDateFormatter *newFormatter = [NSDateFormatter new];
    [newFormatter setDateFormat:@"yyyy/MM/dd"];
    return [newFormatter autorelease];
}



@end
