//
//  TixianViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/23.
//

#import "TixianViewController.h"
#import "MyBankcardTableViewController.h"

@interface TixianViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *yinhangCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *tixianMoneyTf;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;//提示收取多少手续费
@property(nonatomic,strong) NSDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UILabel *powerMoneyLabel;//最低提现额度
@property(nonatomic,strong) NSString * bankId;
@property(nonatomic,strong) NSString * txbl;//手续费
@property(nonatomic,strong) NSString * txMoney;//最少多少钱可以提现
@end

@implementation TixianViewController
//全部提现
- (IBAction)quanbuTixian:(id)sender {
    self.tixianMoneyTf.text = self.yueLabel.text;
    [self.view endEditing:YES];
}
//确认提现
- (IBAction)ensureTixian:(id)sender {
    if (self.bankId == nil) {
        [KKAlert showErrorHint:@"请选择提现银行卡"];
        return;
    }
    NSString * m = self.tixianMoneyTf.text;
    if (m.length == 0) {
        [KKAlert showErrorHint:@"请输入提现金额"];
        return;
    }
    if (m.floatValue == 0) {
        [KKAlert showErrorHint:@"提现金额不能为0"];
        return;
    }
    if (self.txMoney) {
        if (self.txMoney.floatValue > m.floatValue) {
            [KKAlert showErrorHint:@"提现金额不能低于最低提现金额"];
            return;
        }
    }
    
    if (!self.txbl) {
        self.txbl = @"0";
    }
    NSDictionary * parm = @{@"bank_id":self.bankId,@"token":[UserDefaults token],@"tx_bl":self.txbl,@"price":m};
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork submitTixianWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"提现申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"moneyChange" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"提交数据失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getTixianInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBackCard:) name:@"newBankCard" object:nil];;
}
- (void)selectBackCard:(NSNotification *)noti
{
    NSDictionary * dict = noti.userInfo;
    NSDictionary * dic = dict[@"bankCard"];
    NSString * bankStr;
    if (dic[@"bank_name"] && dic[@"bank_code"]) {
        bankStr = [NSString stringWithFormat:@"%@%@",dic[@"bank_name"],dic[@"bank_code"]];
        self.yinhangCardLabel.text = bankStr;
    }
    self.bankId = dic[@"id"];
}
//选择银行卡
- (IBAction)selectYinhangCard:(id)sender {
    MyBankcardTableViewController * bankVC = [MyBankcardTableViewController new];
    [self.navigationController pushViewController:bankVC animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)getTixianInfo
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getFdTixianInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            NSDictionary * dict = dic[@"data"];
            self.dataDic = dict;
            self.yueLabel.text = dict[@"user_money"];
            NSString * bankStr;
            if (dict[@"bank_name"] && dict[@"bank_code"]) {
                bankStr = [NSString stringWithFormat:@"%@%@",dict[@"bank_name"],dict[@"bank_code"]];
                self.yinhangCardLabel.text = bankStr;
            }
            self.bankId = dict[@"id"];
            self.txbl = dict[@"tx_bl"];
            self.txMoney = dict[@"tx_money"];
            if (self.txMoney) {
                self.powerMoneyLabel.text = [NSString stringWithFormat:@"(最低提现金额为¥%@)",self.txMoney];
            }
            if (self.txbl) {
                self.hintLabel.text = [NSString stringWithFormat:@"每笔提现将收取提现 金额的%.f%%作为手续费",self.txbl.floatValue * 100];
            }
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newBankCard" object:nil];
}
@end
