//
//  UpdateInfoViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/26.
//

#import "UpdateInfoViewController.h"

@interface UpdateInfoViewController ()<UITextFieldDelegate>

@end

@implementation UpdateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem.tintColor = kTabbarColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.style) {
        self.textField.placeholder = @"请输入邮箱";
        self.title = @"邮箱";
    } else {
        self.textField.placeholder = @"请输入昵称";
        self.title = @"昵称";
    }
    if (self.content) {
        self.textField.text = self.content;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)saveInfo
{
    NSString * uploadStr = self.textField.text;
    if (self.content) {
        if ([uploadStr isEqualToString:self.content]) {
            [KKAlert showErrorHint:@"您未做任何改动"];
            return;
        }
    }
    if (self.style) {
        if (uploadStr.length == 0) {
            [KKAlert showErrorHint:@"请输入邮箱"];
            return;
        }
        if (![uploadStr isEmail]) {
            [KKAlert showErrorHint:@"邮箱格式不正确"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"邮箱上传中"];
        NSDictionary * parm = @{@"token":[UserDefaults token],@"email":uploadStr};
        [KKNetWork updateEmailWithParm:parm SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"邮箱上传成功"];
                [UserDefaults saveUserInfoUpdate:YES];
                self.content = uploadStr;
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"邮箱上传失败"];
        }];
    } else {
        NSDictionary * parm = @{@"token":[UserDefaults token],@"nickname":uploadStr};
        if (uploadStr.length == 0) {
            [KKAlert showErrorHint:@"请输入昵称"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"昵称上传中"];
        [KKNetWork updateNickNameWithParm:parm SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"昵称上传成功"];
                self.content = uploadStr;
                [UserDefaults saveUserInfoUpdate:YES];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"昵称上传失败"];
        }];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
