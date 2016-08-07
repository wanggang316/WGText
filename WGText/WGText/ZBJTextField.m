//
//  ZBJTextField.m
//  WGTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import "ZBJTextField.h"
#import "NSString+ZBJEmoji.h"
#import "NSString+ZBJSubstring.h"

@interface ZBJTextFieldSupport : NSObject <UITextFieldDelegate>

@property (nonatomic,weak) id<UITextFieldDelegate> delegate;

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
    
    BOOL limitEmoji = ((ZBJTextField *)textField).limitEmoji;
    if (limitEmoji && [string isIncludingEmoji]) {
        return NO;
    }
    
    NSInteger maxLength = ((ZBJTextField *)textField).maxLength;
    if (maxLength > 0) {
        //增加文字
        if (string.length > 0) {
            if (textField.text.length + string.length > maxLength) {
                NSInteger newStringLength = [textField.text lengthOfAppendString:string maxLength:maxLength];
                if (newStringLength > 0) {
                    textField.text = [NSString stringWithFormat:@"%@%@", textField.text, [string substringToIndex:newStringLength]];
                }
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
@property (nonatomic, strong) UIView *editRightView;
@property (nonatomic, strong) UIButton *eyeButton;

@end

@implementation ZBJTextField


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        _textFieldSupport = [[ZBJTextFieldSupport alloc] init];
        
    }
    return self;
}

-(void)setDelegate:(id<UITextFieldDelegate>)deleg{
    _textFieldSupport.delegate = deleg;
    super.delegate = _textFieldSupport;
}

#pragma mark -
// 联想词只走这里
- (void)textFieldDidChanged:(NSNotification *)notification {
    
    if (self.limitEmoji && [self.text isIncludingEmoji]) {
        self.text = [self.text stringByRemovingEmoji];
    }
    
    if (self.maxLength > 0) {
        if (!self.markedTextRange && self.text.length > self.maxLength) {
            NSString *newString = [self.text substringWithLength:self.maxLength];
            if (newString.length != self.text.length) {
                self.text = newString;
            }
        }
    }
    
    if (self.textFieldSupport && [self.textFieldSupport respondsToSelector:@selector(textFieldDidChanged:)]) {
        [self.textFieldSupport textFieldDidChanged:self];
    }
    
    if ([notification.object isKindOfClass:[ZBJTextField class]]) {
        
        ZBJTextField *textField = notification.object;
        if (textField.showEditView) {
            if(textField.text.length > 0) {
                textField.editRightView.hidden = NO;
            }else {
                textField.editRightView.hidden = YES;
            }
        }
    }
}


- (void)showPassword {
    self.secureTextEntry = !self.secureTextEntry;
    NSString *text = self.text;
    self.text = @"";
    self.text = text;
    self.keyboardType = UIKeyboardTypeASCIICapable;
    // button 图标
    if (self.secureTextEntry) {
        [self.eyeButton setImage:[UIImage imageNamed:@"password_disAvailable"] forState:(UIControlStateNormal)];
    }else {
        [self.eyeButton setImage:[UIImage imageNamed:@"password_available"] forState:(UIControlStateNormal)];
    }
}

- (void)clearAllText {
    self.text = @"";
    self.editRightView.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setShowEditView:(BOOL)showEditView {
    _showEditView = showEditView;
    if (showEditView) {
        self.editRightView.frame = CGRectMake(0, 0, 57.5, self.frame.size.height);
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        self.editRightView.hidden = YES;
        if (self.superview) {
            [self.superview addSubview:self.eyeButton];
            self.eyeButton.frame = CGRectMake(CGRectGetMaxX(self.frame) - 60 + 30 - 3, self.frame.origin.y + 0.5, self.eyeButton.frame.size.width, self.eyeButton.frame.size.height);
        }
    }else {
        self.rightViewMode = UITextFieldViewModeNever;
    }
}

- (UIButton *)eyeButton {
    if (!_eyeButton) {
         _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeButton setImage:[UIImage imageNamed:@"password_disAvailable"] forState:(UIControlStateNormal)];
        
        _eyeButton.frame = CGRectMake(self.frame.size.width - _eyeButton.frame.size.width - 4, _editRightView.frame.size.height/2 - 1 - (_editRightView.frame.size.height - 2) * 0.5, 18.5 + 10, _editRightView.frame.size.height - 2);
        
        [_eyeButton addTarget:self action:@selector(showPassword) forControlEvents:(UIControlEventTouchUpInside)];
        _eyeButton.backgroundColor = [UIColor whiteColor];
    }
    return _eyeButton;
}

- (UIView *)editRightView {
    if (!_editRightView) {
        _editRightView = [[UIView alloc] init];
        _editRightView.frame = CGRectMake(0, 0, 50, self.frame.size.height);
        _editRightView.contentMode = UIViewContentModeScaleAspectFit;

        self.rightViewMode = UITextFieldViewModeWhileEditing;
        self.rightView = _editRightView;
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"login_txt_del"] forState:(UIControlStateNormal)];
        [deleteButton addTarget:self action:@selector(clearAllText) forControlEvents:(UIControlEventTouchUpInside)];

        deleteButton.frame = CGRectMake(0, 0, 28, CGRectGetHeight(_editRightView.frame));
        
        [deleteButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -12.5, 0.0, 0.0)];

        [_editRightView addSubview:deleteButton];
        _editRightView.backgroundColor = [UIColor clearColor];
        
        _editRightView.frame = CGRectMake(0, 0, 28, self.frame.size.height);
    }
    return _editRightView;
}


@end


