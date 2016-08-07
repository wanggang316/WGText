//
//  ZBJTextView.h
//  WGTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  特性：
 *  1. 最大长度字段 maxLength
 *  2. 默认值字段 placeholder
 *  3. 限制emoji表情
 */
typedef void(^ReturnCountBlock) (NSInteger);

@interface ZBJTextView : UITextView

/** 可输入的最大长度 */
@property (nonatomic, assign) NSInteger maxLength;
/** 是否限制emoji表情输入，默认为NO */
@property (nonatomic, assign) BOOL limitEmoji;

@property (nonatomic, strong) NSString  *placeholder;
@property (nonatomic, strong) UILabel   *placeholderLabel;
@property (nonatomic, copy)   ReturnCountBlock returnCountBlock;

@end
