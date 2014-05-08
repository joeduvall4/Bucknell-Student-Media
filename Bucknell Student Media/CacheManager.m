//
//  CacheManager.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager ()

@property (nonatomic, retain) NSCache *sharedCache;

@end

@implementation CacheManager

+ (NSCache *)sharedInstance {
    static NSCache *sharedInstance = nil;
    if (sharedInstance == nil) {
        
    }
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[NSCache alloc] init];
    });
    return sharedInstance;
}

@end
