//
//  CacheManager.h
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (NSCache *)sharedInstance;

@end
