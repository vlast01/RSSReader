//
//  NetworkManager.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property (nonatomic, retain) NSURLSession *session;

@end

NSString * const url = @"http://news.tut.by/rss/index.rss";

@implementation NetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static NetworkManager *uniqueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[NetworkManager alloc] init];
    });
    return uniqueInstance;
}

- (void)loadFeedWithCompletion:(void (^)(NSData*, NSError*))completion {
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", error);
        if (error) {
            completion(nil, error);
        } else {
            completion(data, nil);
        }
    });
}

- (void)dealloc {
    [_session release];
    [super dealloc];
}

@end
