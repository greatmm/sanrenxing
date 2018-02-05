//
//  MyBankcardTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/23.
//

#import "MyBankcardTableViewController.h"
#import "BankCardTableViewCell.h"
#import "AddBankcardViewController.h"
@interface MyBankcardTableViewController ()
@property(nonatomic,strong) NSArray * bankList;
@end

@implementation MyBankcardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"银行卡";
    UIView * footer = [UIView new];
    footer.frame = CGRectMake(0, 0, ScreenWidth, 100);
    UIControl * control = [UIControl new];
    control.frame = CGRectMake(0, 30, ScreenWidth, 40);
    [control addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:control];
    UIImageView * imageView = [UIImageView  new];
    imageView.frame = CGRectMake(30, 11, 18, 18);
    imageView.image = [UIImage imageNamed:@"bank_add"];
    [control addSubview:imageView];
    UILabel * label = [UILabel new];
    label.text = @"添加银行卡";
    label.textColor = k102Color;
    label.frame = CGRectMake(58, 5, ScreenWidth - 68, 30);
    label.font = [UIFont systemFontOfSize:16];
    [control addSubview:label];
    self.tableView.tableFooterView = footer;
    [self getCardData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardData) name:@"addBankCard" object:nil];;
}
- (void)getCardData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getBankcardListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.bankList = dic[@"data"];
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败 "];
    }];
}
- (void)addBankCard
{
    AddBankcardViewController * addVC = [AddBankcardViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bankList) {
        return self.bankList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardTableViewCell * cell = [BankCardTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSArray * imageNames = @[@"bank_blue",@"bank_green",@"bank_purple",@"bank_red"];
    cell.backImageView.image = [UIImage imageNamed:imageNames[indexPath.row%4]];
    NSDictionary * dict = self.bankList[indexPath.row];
    cell.bankNameLabel.text = dict[@"bank_name"];
    cell.bankCardLabel.text = [NSString stringWithFormat:@"****  ****  ****  %@",dict[@"bank_code"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.bankList[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newBankCard" object:nil userInfo:@{@"bankCard":dict}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth - 30)*112.0/352 + 20;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addBankCard" object:nil];
}
@end
