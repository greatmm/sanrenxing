//
//  MyMoneyViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/23.
//

#import "MyMoneyViewController.h"
#import "TixianViewController.h"
#import "FDShouzhiViewController.h"
@interface MyMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MyMoneyViewController
//提现
- (IBAction)tixian:(id)sender {
    TixianViewController * tixianVC = [TixianViewController new];
    [self.navigationController pushViewController:tixianVC animated:YES];
}
//收支记录
- (IBAction)tixianJilu:(id)sender {
    FDShouzhiViewController * vc = [FDShouzhiViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的余额";
    [self getYue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getYue) name:@"moneyChange" object:nil];;
}
- (void)getYue
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getFdYueWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSString * yue = dic[@"data"];
            if (yue && [yue isKindOfClass:[NSString class]]) {
                self.moneyLabel.text = yue;
            }
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moneyChange" object:nil];
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
