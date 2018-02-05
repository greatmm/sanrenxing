//
//  FeedbackViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/26.
//

#import "FeedbackViewController.h"
#import "CMInputView.h"

@interface FeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet CMInputView *inputView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.inputView.placeholder = @"请输入...";
    self.inputView.maxNumberOfLines = 5;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithWhite:102/255.0 alpha:1];
}
- (void)upload
{
    NSString * content = self.inputView.text;
    if (content.length == 0) {
        [KKAlert showErrorHint:@"请输入反馈内容"];
        return;
    }
    NSString * mobile = self.phoneTf.text;
    if (mobile.length && ![mobile isPhoneNumber]) {
        [KKAlert showErrorHint:@"您输入的电话号码不正确"];
        return;
    }
    NSString  * email = self.emailTf.text;
    if (email.length && ![email isEmail]) {
        [KKAlert showErrorHint:@"您输入的邮箱不正确"];
        return;
    }
    NSDictionary * parm = @{@"token":[UserDefaults token],@"content":content,@"mobile":mobile,@"email":email};
    [KKAlert showAnimateWithStauts:@"反馈提交中"];
    [KKNetWork feedBackWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        NSString * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue  == 200) {
            [KKAlert showSuccessHint:@"反馈提交成功"];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"反馈提交失败"];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
