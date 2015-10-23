//
//  NSString+Length.h
//  zbj-iPhone
//
//  Created by 王刚 on 15/10/22.
//  Copyright © 2015年 ZhuBaiJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Length)

- (NSInteger)zlength;

- (NSString *)composedSubstringWithRange:(NSRange)range;
- (NSRange)composedRangeWithRange:(NSRange)range;
@end
