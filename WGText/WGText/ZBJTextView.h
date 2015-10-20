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
 */

@interface ZBJTextView : UITextView

@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UILabel *placeholderLabel;

@end
