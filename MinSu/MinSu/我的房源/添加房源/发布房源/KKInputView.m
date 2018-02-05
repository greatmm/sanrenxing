//
//  KKInputView.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import "KKInputView.h"


@interface KKInputView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;

@end

@implementation KKInputView

+ (instancetype)shareInputView
{
    KKInputView * inputView = [[NSBundle mainBundle] loadNibNamed:@"KKInputView" owner:nil options:nil].firstObject;
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
- (IBAction)ensure:(id)sender {
    if (self.ensureBlock) {
        NSString * str = self.tf.text;
        self.ensureBlock(str);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self ensure:nil];
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
