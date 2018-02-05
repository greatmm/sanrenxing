//
//  AddLKViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "AddLKViewController.h"

@interface AddLKViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTf;
@property (weak, nonatomic) IBOutlet UILabel *zhengjianLabel;
@property (weak, nonatomic) IBOutlet UILabel *leixingLabel;
@property (nonatomic,strong)NSString * lkStyle;
@end

@implementation AddLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增常用旅客";
    if (self.dict) {
        self.title = @"常用旅客修改";
        self.nameTf.text = _dict[@"name"];
        self.lkStyle = _dict[@"lk_type"];
        self.leixingLabel.text = _dict[@"lk_type"];
        self.idNumberTf.text = _dict[@"zj_code"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ensure:(id)sender {
    [self.view endEditing:YES];
    NSString * name = self.nameTf.text;
    if (name.length == 0) {
        [KKAlert showErrorHint:@"请输入姓名"];
        return;
    }
    NSString * idNumber  = self.idNumberTf.text;
    if (![idNumber isIdNumber]) {
        [KKAlert showErrorHint:@"身份证号码格式不正确"];
        return;
    }
    if (self.lkStyle == nil) {
        [KKAlert showErrorHint:@"请选择旅客类型"];
        return;
    }
    if (self.dict) {
        NSDictionary * parm = @{@"token":[UserDefaults token],@"name":name,@"zj_type":@"身份证",@"zj_code":idNumber,@"lk_type":self.lkStyle,@"id":_dict[@"id"]};
        [KKAlert showAnimateWithStauts:@"数据提交中"];
        [KKNetWork editLKWithParm:parm SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"修改成功"];
                [UserDefaults saveAddLK:YES];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"数据提交失败"];
        }];
    } else {
         NSDictionary * parm = @{@"token":[UserDefaults token],@"name":name,@"zj_type":@"身份证",@"zj_code":idNumber,@"lk_type":self.lkStyle};
        [KKAlert showAnimateWithStauts:@"旅客添加中"];
        [KKNetWork addLKWithParm:parm SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"添加成功"];
                [UserDefaults saveAddLK:YES];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"添加失败"];
        }];
    }
}
- (IBAction)selectZhengjian:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)selectLeixing:(id)sender {
    [self.view endEditing:YES];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"选择旅客类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * chengRenAction = [UIAlertAction actionWithTitle:@"成人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.lkStyle = @"成人";
        self.leixingLabel.text = @"成人";
    }];
    UIAlertAction * erTongAction = [UIAlertAction actionWithTitle:@"儿童" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.lkStyle = @"儿童";
        self.leixingLabel.text = @"儿童";
    }];
    [alertVC addAction:chengRenAction];
    [alertVC addAction:erTongAction];
    [alertVC addAction:cancel];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
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
