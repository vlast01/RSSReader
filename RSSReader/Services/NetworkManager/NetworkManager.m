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

int const kTimeoutInterval = 10;

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

- (void)loadFeed:(NSString *)url completion:(void (^)(NSData*, NSError*))completion {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:kTimeoutInterval];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data, error);
        });
    }];
    
    [dataTask resume];
  
}

- (NSString *)downloadHTML:(NSString *)url {
    NSURL *URL = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    if (!data) {
        return @"";
    }
    return [NSString stringWithUTF8String:[data bytes]];
}

- (void)dealloc {
    [_session release];
    [super dealloc];
}

@end
