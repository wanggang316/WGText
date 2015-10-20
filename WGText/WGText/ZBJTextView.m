//
//  ZBJTextView.m
//  WGTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import "ZBJTextView.h"

@interface ZBJTextViewSupport : NSObject <UITextViewDelegate>

@property (nonatomic, retain) id<UITextViewDelegate> delegate;

@end
@implementation ZBJTextViewSupport

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    ZBJTextView *t = (ZBJTextView *)textView;
    [t.placeholderLabel removeFromSuperview];
    
    if([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
        return [self.delegate textViewShouldBeginEditing:textView];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)])
        return [self.delegate textViewShouldEndEditing:textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [self.delegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [self.delegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger maxLength = ((ZBJTextView *)textView).maxLength;
    if (maxLength > 0) {
        //增加文字
        if (text.length > 0) {
            if (range.location >= maxLength || textView.text.length >= maxLength) {
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

- (void)textViewDidChange:(UITextView *)textView {
    
    ZBJTextView *t = (ZBJTextView *)textView;
    NSInteger maxLength = t.maxLength;

    if (maxLength > 0) {
        if (t.markedTextRange == nil && maxLength > 0 && t.text.length > maxLength) {
            t.text = [t.text substringToIndex:maxLength];
        }
    }
    
    if (t.text.length == 0) {
        [t addSubview:t.placeholderLabel];
    } else {
        [t.placeholderLabel removeFromSuperview];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:t];
    }

}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)])
        [self.delegate textViewDidChangeSelection:textView];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)])
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)])
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    return YES;
}


-(void)setDelegate:(id<UITextViewDelegate>)dele{
    _delegate = dele;
}

@end


@interface ZBJTextView()

@property (nonatomic, strong) ZBJTextViewSupport *textViewSupport;


@end

@implementation ZBJTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textViewSupport = [[ZBJTextViewSupport alloc] init];
        [self addSubview:self.placeholderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = CGRectMake(8, 10, CGRectGetWidth(self.frame) - 16, 15);
}


#pragma mark - setter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor colorWithRed:227.f/255.f green:230.f/255.f blue:230.f/255.f alpha:1.f];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = _placeholder;
}

-(void)setDelegate:(id<UITextViewDelegate>)deleg{
    _textViewSupport.delegate = deleg;
    super.delegate = _textViewSupport;
}

@end