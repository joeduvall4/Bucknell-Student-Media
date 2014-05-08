//
//  Post.m
//  Bucknell Student Media
//
//  Created by Joe Duvall on 5/8/14.
//  Copyright (c) 2014 Joseph Duvall. All rights reserved.
//
//  NSScreencast Episode 116 "Mantle" serves as the basis for this code.
//

#import "Post.h"

@implementation Post

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postID" : @"id",
             @"postURL" : @"url",
             @"titlePlain" : @"title_plain",
             @"lastModified" : @"modified"
             };
}

+ (NSValueTransformer *)postURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)lastModifiedJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        //2014-04-26 15:46:43
        dateFormatter.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
        return [dateFormatter dateFromString:dateString];
    }];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        //2014-04-26 15:46:43
        dateFormatter.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
        return [dateFormatter dateFromString:dateString];
    }];
}

@end
