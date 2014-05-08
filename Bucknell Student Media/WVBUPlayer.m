//
//  WVBUPlayer.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//

#import "WVBUPlayer.h"

static NSString *playerURL = @"http://stream.bucknell.edu:90/wvbu.m3u";

@implementation WVBUPlayer

+ (WVBUPlayer *)sharedPlayer {
    static WVBUPlayer *_sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlayer = [WVBUPlayer playerWithURL:[NSURL URLWithString:playerURL]];
    });
    return _sharedPlayer;
}

@end
