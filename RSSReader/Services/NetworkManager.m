//
//  NetworkManager.m
//  RSSReader
//
//  Created by Владислав Станкевич on 19.11.20.
//

#import "NetworkManager.h"
#import "FeedItem.h"

@implementation NetworkManager

- (void)loadFeedWithCompliteon:(void (^)(NSData*))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://news.tut.by/rss/index.rss"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"loading error");
        } else {
            //    NSError *e = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data);
            });
        }
    }];
    
    [dataTask resume];
}

@end
