//
//  iTunesClient.h
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/6/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface iTunesClient : AFHTTPSessionManager

+ (iTunesClient *)sharedClient;

- (NSURLSessionDataTask *)searchForTerm:(NSString *)term completion:( void (^)(NSArray *results, NSError *error) )completion;

@end
