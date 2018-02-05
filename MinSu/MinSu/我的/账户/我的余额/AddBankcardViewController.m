//
//  AddBankcardViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/24.
//

#import "AddBankcardViewController.h"

@interface AddBankcardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankCardTf;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *shenfenzhengTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTf;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTf;

@end

@implementation AddBankcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
//发送验证码
- (IBAction)sendAuthCode:(UIButton *)sender {
    NSString * phoneNumber = self.phoneNoTf.text;
    if (![phoneNumber isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码格式不正确"];
        return;
    }
    [KKNetWork sendVerifyWithParm:@{@"phone":phoneNumber,@"type":@"3"} SuccessBlock:^(NSDictionary *dic) {
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
    [KKTool downCount:sender];
}
//添加银行卡
- (IBAction)addBankCard:(id)sender {
    NSString * bankCard = self.bankCardTf.text;
    if (bankCard.length == 0) {
        [KKAlert showErrorHint:@"请输入银行卡号"];
        return;
    }
    NSString * bankName = self.bankNameTf.text;
    if (bankName.length == 0) {
        [KKAlert showErrorHint:@"请输入银行名称"];
        return;
    }
    NSString * name = self.nameTf.text;
    if (name.length  == 0) {
        [KKAlert showErrorHint:@"请输入姓名"];
        return;
    }
    NSString * idCard = self.shenfenzhengTf.text;
    if (idCard.length == 0) {
        [KKAlert showErrorHint:@"请输入身份证号"];
        return;
    }
    if (![idCard isIdNumber]) {
        [KKAlert showErrorHint:@"身份证号码格式不正确"];
        return;
    }
    NSString * phoneNo = self.phoneNoTf.text;
    if (phoneNo.length == 0) {
        [KKAlert showErrorHint:@"请输入手机号"];
        return;
    }
    if (![phoneNo isPhoneNumber]) {
        [KKAlert showErrorHint:@"手机号码格式不正确"];
        return;
    }
    NSString * authCode = self.yanzhengmaTf.text;
    if (authCode.length == 0) {
        [KKAlert showErrorHint:@"请输入验证码"];
        return;
    }
    if (![authCode isAuthCode]) {
        [KKAlert showErrorHint:@"验证码格式不正确"];
        return;
    }
    NSDictionary * parm = @{@"token":[UserDefaults token],@"verify":authCode,@"bank_code":bankCard,@"bank_name":bankName,@"name":name,@"name_code":idCard,@"phone":phoneNo};
    [KKAlert showAnimateWithStauts:@"添加中"];
    [KKNetWork addBankCardWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addBankCard" object:nil];;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"添加失败"];
    }];
}

@end
