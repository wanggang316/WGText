//
//  NSString+Length.m
//  zbj-iPhone
//
//  Created by 王刚 on 15/10/22.
//  Copyright © 2015年 ZhuBaiJia. All rights reserved.
//

#import "NSString+Length.h"

@implementation NSString (Length)

/**
 * @see  http://stackoverflow.com/questions/10461781/nsstring-length-special-characters
 */

- (NSInteger)zlength {
    __block NSInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                          options:NSStringEnumerationByComposedCharacterSequences
                       usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                           length++;
                       }];
    
    return length;
}


/**
 *  @see http://blog.soff.es/dealing-with-emoji
 */

- (NSString *)composedSubstringWithRange:(NSRange)range {
    // Return a substring using a composed range so surrogate unicode pairs (composed characters) count as 1 in the
    // range instead of however many unichars they actually are.
    return [self substringWithRange:[self composedRangeWithRange:range]];
}


- (NSRange)composedRangeWithRange:(NSRange)range {
    // We're going to make a new range that takes into account surrogate unicode pairs (composed characters)
    __block NSRange adjustedRange = range;
    
    // Adjust the location
    [self enumerateSubstringsInRange:NSMakeRange(0, range.location + 1) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range location.
        // This means that there is a composed character before where the range starts who's length is greater than 1.
        adjustedRange.location += substring.length - 1;
    }];
    
    // Adjust the length
    NSInteger length = self.length;
    
    // Count how many times we iterate so we only iterate over what we care about.
    __block NSInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(adjustedRange.location, length - adjustedRange.location) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // If they string the iterator found is greater than 1 in length, add that to range length.
        // This means that there is a composed character inside of the range starts who's length is greater than 1.
        adjustedRange.length += substring.length - 1;
        
        // Add one to the count
        count++;
        
        // If we have iterated as many times as the original length, stop.
        if (range.length == count) {
            *stop = YES;
        }
    }];
    
    // Make sure we don't make an invalid range. This should never happen, but let's play it safe anyway.
    if (adjustedRange.location + adjustedRange.length > length) {
        adjustedRange.length = length - adjustedRange.location - 1;
    }
    
    // Return the adjusted range
    return adjustedRange;
}


@end
