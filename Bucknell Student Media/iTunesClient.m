//
//  iTunesClient.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/6/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//
//  NSScreencast Episode 91 "AFNetworking 2.0" serves as the basis for this code.
//

#import "iTunesClient.h"

static NSString *iTunesAPIBaseURL = @"https://itunes.apple.com/";
static NSString *iTunesRelativeSearchURL = @"/search";
static NSString *iTunesCountryCode = @"US";
static NSString *userAgent = @"Bucknell Student Media iOS v0.5";
static NSUInteger cacheMemoryCapacity = 10 * 1024 * 1024;
static NSUInteger cacheDiskCapacity = 50 * 1024 * 1024;

@implementation iTunesClient

+ (iTunesClient *)sharedClient {
    static iTunesClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:iTunesAPIBaseURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : userAgent }];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:cacheMemoryCapacity
                                                          diskCapacity:cacheDiskCapacity
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        NSLog(@"baseURL: %@", baseURL);
        _sharedClient = [[iTunesClient alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)searchForTerm:(NSString *)term completion:( void (^)(NSArray *results, NSError *error) )completion {
    NSURLSessionDataTask *task = [self GET:iTunesRelativeSearchURL
                                parameters:@{ @"country" : iTunesCountryCode,
                                              @"term" : term }
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject[@"results"], nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                       }
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    return task;
}
@end
