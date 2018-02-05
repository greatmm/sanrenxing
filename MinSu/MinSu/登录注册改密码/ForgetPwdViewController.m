//
//  ForgetPwdViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/11.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;

@end

@implementation ForgetPwdViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"忘记密码";
}
- (IBAction)submit:(id)sender {
    NSString * phoneNumber = self.phoneTf.text;
    if (![phoneNumber isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码格式不正确"];
        return;
    }
    NSString * pwd = self.pwdTf.text;
    if (![pwd isPwd]) {
        [KKAlert showErrorHint:@"密码格式不正确"];
        return;
    }
    NSString * authCode = self.authCodeTf.text;
    if (![authCode isAuthCode]) {
        [KKAlert showErrorHint:@"验证码格式不正确"];
        return;
    }
    NSDictionary * parm = @{@"mobile":phoneNumber,@"verify":authCode,@"password":pwd};
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork newPwdWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"密码修改成功"];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"密码修改失败"];
    }];
}
- (IBAction)sendAuthCode:(id)sender {
    NSString * phoneNumber = self.phoneTf.text;
    if (![phoneNumber isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码格式不正确"];
        return;
    }
    [KKNetWork sendVerifyWithParm:@{@"phone":phoneNumber,@"type":@"2"} SuccessBlock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"验证码发送成功"];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert showErrorHint:@"验证码发送失败"];
    }];
    [KKTool downCount:self.authCodeBtn];
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
