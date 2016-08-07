//
//  NSString+ZBJSubstring.h
//  WGText
//
//  Created by wanggang on 8/7/16.
//  Copyright © 2016 王刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZBJSubstring)


/**
 *  根据长度截取字符串
 *  该方法是为了防止出现表情被截取一半的情况
 *
 *  @param length 最大长度
 *
 *  @return 截取后的字符串
 */
- (NSString *)substringWithLength:(NSUInteger)maxLength;

/**
 *  根据最大长度截取新追加的字符串
 *  该方法是为了防止出现表情被截取一半的情况
 *
 *  @param newString 追加字符串
 *  @param maxLength 最大长度
 *
 *  @return 追加字符串截取后的长度
 */
- (NSInteger)lengthOfAppendString:(NSString *)newString maxLength:(NSInteger)maxLength;



@end
