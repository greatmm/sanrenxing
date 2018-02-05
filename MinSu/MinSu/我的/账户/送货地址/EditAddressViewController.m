//
//  EditAddressViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/26.
//

#import "EditAddressViewController.h"

@interface EditAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];
    self.title = @"添加收货地址";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.addressDic) {
        self.title = @"编辑收货地址";
        self.phoneTf.text = self.addressDic[@"mobile"];
        self.nameTf.text = self.addressDic[@"name"];
        self.addressTf.text = self.addressDic[@"address"];
    } else {
       self.title = @"添加收货地址";
    }
}
- (IBAction)ensure:(id)sender {
    NSString * name = self.nameTf.text;
    if (name.length == 0) {
        [KKAlert showErrorHint:@"请输入姓名"];
        return;
    }
    NSString * phone = self.phoneTf.text;
    if (phone.length == 0) {
        [KKAlert showErrorHint:@"请输入电话号"];
        return;
    }
    if (![phone isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码不正确"];
        return;
    }
    NSString * address  = self.addressTf.text;
    if (address.length == 0) {
        [KKAlert showErrorHint:@"请输入地址"];
        return;
    }
    if (self.addressDic) {
        NSDictionary * parm = @{@"token":[UserDefaults token],@"address_id":self.addressDic[@"address_id"],@"name":name,@"mobile":phone,@"address":address};
        [self editAddressWithDic:parm];
    } else {
       NSDictionary * parm = @{@"token":[UserDefaults token],@"name":name,@"mobile":phone,@"address":address};
       [self addAddressWithDic:parm];
    }
}
- (void)editAddressWithDic:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"地址上传中"];
    [KKNetWork editAddressWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"地址修改成功"];
            [UserDefaults saveAddressUpdate:YES];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"地址修改失败"];
    }];
}
- (void)addAddressWithDic:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"地址上传中"];
    [KKNetWork addAddressWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"地址添加成功"];
            [UserDefaults saveAddressUpdate:YES];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"地址添加失败"];
    }];
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

@end
