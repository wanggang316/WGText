//
//  NSString+ZBJEmoji.h
//  WGText
//
//  Created by wanggang on 8/7/16.
//  Copyright © 2016 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZBJEmoji)

- (BOOL)isIncludingEmoji;

- (instancetype)stringByRemovingEmoji;

@end
