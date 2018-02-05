//
//  EditPwdViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/11.
//

#import "EditPwdViewController.h"

@interface EditPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdTf;
@property (weak, nonatomic) IBOutlet UITextField *editPwdTf;

@end

@implementation EditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)submit:(id)sender {
    NSString * pwd = self.pwdTf.text;
    if (![pwd isPwd]) {
        [KKAlert showErrorHint:@"原密码格式不正确"];
        return;
    }
    NSString * editPwd = self.editPwdTf.text;
    if (![editPwd isPwd]) {
        [KKAlert showErrorHint:@"新密码格式不正确"];
        return;
    }
    if ([pwd isEqualToString:editPwd]) {
        [KKAlert showErrorHint:@"新旧密码一样"];
        return;
    }
    [KKAlert showAnimateWithStauts:@"密码修改中..."];
    NSDictionary * parm = @{@"token":[UserDefaults token],@"pwd_old":pwd,@"pwd_new":editPwd};
    [KKNetWork editPwdWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
