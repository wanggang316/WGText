//
//  NSString+ZBJSubstring.m
//  WGText
//
//  Created by wanggang on 8/7/16.
//  Copyright © 2016 王刚. All rights reserved.
//

#import "NSString+ZBJSubstring.h"

@implementation NSString (ZBJSubstring)




- (NSString *)substringWithLength:(NSUInteger)length {
    
    NSMutableArray *charLenghs = [NSMutableArray new];
    NSRange fullRange = NSMakeRange(0, [self length]);
    [self enumerateSubstringsInRange:fullRange
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         [charLenghs addObject:@(substringRange.length)];
     }];
    
    NSInteger originLength = self.length;
    
    while (charLenghs.count > 0) {
        NSInteger lastLength = [charLenghs.lastObject integerValue];
        if (originLength - lastLength > length) {
            originLength -= lastLength;
            [charLenghs removeLastObject];
            continue;
        }
        originLength -= lastLength;
        [charLenghs removeLastObject];
        break;
    }
    
    NSInteger newLength = 0;
    for (NSNumber *len in charLenghs) {
        newLength += len.integerValue;
    }
    
    return [self substringToIndex:newLength];
}


- (NSInteger)lengthOfAppendString:(NSString *)newString maxLength:(NSInteger)maxLength {
    NSMutableArray *charLenghs = [NSMutableArray new];
    NSRange fullRange = NSMakeRange(0, [newString length]);
    [newString enumerateSubstringsInRange:fullRange
                                  options:NSStringEnumerationByComposedCharacterSequences
                               usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         NSLog(@"%@ %@", substring, NSStringFromRange(substringRange));
         [charLenghs addObject:@(substringRange.length)];
     }];
    
    NSInteger originLength = self.length + newString.length;
    
    while (charLenghs.count > 0) {
        NSInteger lastLength = [charLenghs.lastObject integerValue];
        if (originLength - lastLength > maxLength) {
            originLength -= lastLength;
            [charLenghs removeLastObject];
            continue;
        }
        originLength -= lastLength;
        [charLenghs removeLastObject];
        break;
    }
    
    NSInteger newLength = 0;
    for (NSNumber *len in charLenghs) {
        newLength += len.integerValue;
    }
    
    return newLength;
}



@end
