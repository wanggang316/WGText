//
//  ViewController.m
//  WGText
//
//  Created by 王刚 on 15/10/20.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import "ViewController.h"
#import "ZBJTextField.h"
#import "ZBJTextView.h"


// 过滤表情
static NSString * filterEmoji(NSString *text) {
    
    // @see http://www.cnblogs.com/heyonggang/p/3476885.html
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    
    //    regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\D]" options:NSRegularExpressionCaseInsensitive error:nil];
    //
    //    modifiedString = [regex stringByReplacingMatchesInString:text
    //                                                     options:0
    //                                                       range:NSMakeRange(0, [text length])
    //                                                withTemplate:@""];
    
    return modifiedString;
}

@interface ViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) ZBJTextField *textField;
@property (nonatomic, strong) ZBJTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - UITextFieldDelegate
- (void)textFieldDidChanged:(UITextField *)textField {
    NSLog(@"textField.text = %@", textField.text);
//    textField.text = filterEmoji(textField.text);

}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textView.text = %@", textView.text);
}

#pragma mark - getter
- (ZBJTextField *)textField {
    if (!_textField) {
        _textField = [[ZBJTextField alloc] initWithFrame:CGRectMake(20, 60, CGRectGetWidth(self.view.frame) - 40, 36)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.maxLength = 10;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate = self;
    }
    return _textField;
}

- (ZBJTextView *)textView {
    if (!_textView) {
        _textView = [[ZBJTextView alloc]initWithFrame:CGRectMake(20, 150, CGRectGetWidth(self.view.frame) - 40, 100)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.maxLength = 50;
        _textView.delegate = self;
        _textView.placeholder = @"请输入旅行介绍";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor colorWithRed:144.f/255.f green:145.f/255.f blue:145.f/255.f alpha:1.f];
    }
    return _textView;
}
@end
