//
//  Post.h
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//
//  NSScreencast Episode 116 "Mantle" serves as the basis for this code.
//

#import "Mantle.h"

@interface Post : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSURL *postURL;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titlePlain;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *lastModified;

@end
