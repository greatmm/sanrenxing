//
//  KKTextInputView.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import "KKTextInputView.h"


@interface KKTextInputView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@end
@implementation KKTextInputView

+ (instancetype)shareTextInputView
{
    KKTextInputView * inputView = [[NSBundle mainBundle] loadNibNamed:@"KKTextInputView" owner:nil options:nil].firstObject;
    return inputView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    self.bottomCons.constant = keyboardHeight;
    [self layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.bottomCons.constant = 0;
    [self layoutIfNeeded];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self ensure:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self ensure:nil];
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)ensure:(id)sender {
    if (self.ensureBlock) {
        NSString * str = self.textView.text;
        self.ensureBlock(str);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
