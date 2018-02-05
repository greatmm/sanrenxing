//
//  AddressViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "EditAddressViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * addressListArr;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"送货地址";
    [self getAddressList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserDefaults addressUpdate]) {
        [self getAddressList];
        [UserDefaults saveAddressUpdate:NO];
    }
}
- (void)getAddressList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getAddressListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self.addressListArr removeAllObjects];
            NSArray * dataArr = [dic objectForKey:@"data"];
            [self.addressListArr addObjectsFromArray:dataArr];
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
}
- (NSMutableArray *)addressListArr
{
    if (_addressListArr) {
        return _addressListArr;
    }
    _addressListArr = [NSMutableArray new];
    return _addressListArr;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.addressListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [AddressTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    kkWeakSelf
    NSDictionary * dic = self.addressListArr[indexPath.section];
    cell.editBlock = ^{
        EditAddressViewController * editVC = [EditAddressViewController new];
        editVC.addressDic = dic;
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    };
    cell.delBlock = ^{
        [weakSelf delAddressWithAddressId:dic[@"address_id"]];
    };
    cell.morenBlock = ^{
        [weakSelf setDefaultAddressWithAddressId:dic[@"address_id"]];
    };
    [cell assignWithDic:dic];
    return cell;
}
//删除收货地址
- (void)delAddressWithAddressId:(NSString *)addressId
{
    [KKAlert showAnimateWithStauts:@"删除中"];
    [KKNetWork deleteAddressWithParm:@{@"token":[UserDefaults token],@"address_id":addressId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"删除成功"];
            [self getAddressList];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"删除失败"];
    }];
}
//设为默认
- (void)setDefaultAddressWithAddressId:(NSString *)addressId
{
    [KKAlert showAnimateWithStauts:@"设置中"];
    [KKNetWork setDefaultAddressWithParm:@{@"token":[UserDefaults token],@"address_id":addressId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"设置成功"];
            [self getAddressList];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"设置失败"];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (IBAction)addNewAddress:(id)sender {
    EditAddressViewController * editVC = [EditAddressViewController new];
    [self.navigationController pushViewController:editVC animated:YES];
}


@end
