//
//  AddEvaluateViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/22.
//

#import "AddEvaluateViewController.h"
#import "CMInputView.h"
@interface AddEvaluateViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet CMInputView *inputView;

@end

@implementation AddEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.inputView.placeholder = @"内容...";
    self.inputView.maxNumberOfLines = 5;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithWhite:102/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputView becomeFirstResponder];
}
- (void)upload
{
    NSString * content = self.inputView.text;
    if (content.length == 0) {
        [KKAlert showErrorHint:@"请输入评价内容"];
        return;
    }
    [KKAlert showAnimateWithStauts:@"评价提交中"];
    [KKNetWork pingjiaHouseWithParm:@{@"token":[UserDefaults token],@"house_id":self.hosue_id,@"content":content} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"评价成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"评价失败"];
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"/n"]) {
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
