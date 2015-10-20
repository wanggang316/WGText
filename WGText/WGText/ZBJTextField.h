//
//  ZBJTextField.h
//  WGTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  特性：
 *  1. 最大长度字段 maxLength
 *  2. TextFiled变化的代理方法
 *      - (void)textFieldDidChanged:(UITextField *)textField;
 */
@protocol ZBJTextFieldDelegate;

@interface ZBJTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger maxLength;

@end
