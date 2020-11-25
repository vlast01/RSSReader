//
//  NetworkManager.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "NetworkManager.h"
#import "FeedItem.h"

@interface NetworkManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation NetworkManager

- (instancetype)initPrivate {
    self = [super init];
    _session = [NSURLSession sharedSession];
    return self;
}

+ (instancetype)sharedInstance {
    static NetworkManager *uniqueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[NetworkManager alloc] initPrivate];
    });
    return uniqueInstance;
}

- (void)loadFeedWithCompliteon:(void (^)(NSData*, NSError*))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://news.tut.by/rss/index.rss"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil, error);
            } else {
                completion(data, nil);
            }
        });
    }];
    
    [dataTask resume];
}

- (void)dealloc {
    [_session release];
    [super dealloc];
}

@end
