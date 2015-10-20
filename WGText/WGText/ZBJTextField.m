//
//  ZBJTextField.m
//  WGTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import "ZBJTextField.h"



@interface ZBJTextFieldSupport : NSObject <UITextFieldDelegate>

@property (nonatomic,retain) id<UITextFieldDelegate> delegate;

@end

@implementation ZBJTextFieldSupport


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
        return [self.delegate textFieldShouldBeginEditing:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
        [self.delegate textFieldDidBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
        return [self.delegate textFieldShouldEndEditing:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)])
        [self.delegate textFieldDidEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger maxLength = ((ZBJTextField *)textField).maxLength;
    if (maxLength > 0) {
        //增加文字
        if (string.length > 0) {
            if (range.location >= maxLength || textField.text.length >= maxLength) {
                return NO;
            } else {
                return YES;
            }
        } else { //减少文字
            return YES;
        }
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldShouldClear:)])
        return [self.delegate textFieldShouldClear:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)])
        return [self.delegate textFieldShouldReturn:textField];
    return YES;
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if([self.delegate respondsToSelector:@selector(textFieldDidChanged:)])
        [self.delegate performSelector:@selector(textFieldDidChanged:) withObject:textField];
}

-(void)setDelegate:(id<UITextFieldDelegate>)dele{
    _delegate = dele;
}

@end



@interface ZBJTextField()

@property (nonatomic, strong) ZBJTextFieldSupport *textFieldSupport;

@end

@implementation ZBJTextField


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        _textFieldSupport=[[ZBJTextFieldSupport alloc] init];
    }
    return self;
}

-(void)setDelegate:(id<UITextFieldDelegate>)deleg{
    _textFieldSupport.delegate = deleg;
    super.delegate = _textFieldSupport;
}


#pragma mark -
- (void) textFieldDidChanged:(NSNotification *)notification {
    
    if (self.maxLength > 0) {
        if (self.markedTextRange == nil && self.maxLength > 0 &&self.text.length > self.maxLength) {
            self.text = [self.text substringToIndex:self.maxLength];
        }
    }
    
    if (self.textFieldSupport && [self.textFieldSupport respondsToSelector:@selector(textFieldDidChanged:)]) {
        [self.textFieldSupport textFieldDidChanged:self];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


