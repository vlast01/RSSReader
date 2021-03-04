//
//  NSString+DateConverter.m
//  RSSReader
//
//  Created by Владислав Станкевич on 25.11.20.
//

#import "NSString+DateConverter.h"
#import "NSDateFormatter+InitializingWithFormat.h"

@implementation NSString (DateConverter)

- (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)initialFormat toFormat:(NSString *)desiredFormat {
    NSString *oldDateString = [NSString stringWithFormat:@"%@", date];
    NSDateFormatter *oldFormatter = [NSDateFormatter formatterWithFormat:initialFormat];
    NSDate *oldDate = [oldFormatter dateFromString:oldDateString];
    NSDateFormatter *newFormatter = [NSDateFormatter formatterWithFormat:desiredFormat];
    NSString *newDateString = [newFormatter stringFromDate:oldDate];
    return newDateString;
}

@end
