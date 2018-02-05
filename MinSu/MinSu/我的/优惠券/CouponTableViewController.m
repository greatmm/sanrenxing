//
//  CouponTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "CouponTableViewController.h"
#import "CouponTableViewCell.h"
#import "MyCouponTableViewController.h"

@interface CouponTableViewController ()
@property(nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation CouponTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(myCoupon)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"优惠券";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getCouponList];
}
- (void)myCoupon
{
    MyCouponTableViewController * vc = [MyCouponTableViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getCouponList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getCouponListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:dic[@"data"]];
            [self.tableView reloadData];
        } else {
            NSString * msg = dic[@"msg"];
            [KKAlert showErrorHint:msg];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (NSMutableArray *)dataArr
{
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [NSMutableArray new];
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell * cell = [CouponTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSString * imageName = indexPath.row%2?@"coupon_green":@"coupon_brown";
    cell.backImageView.image = [UIImage imageNamed:imageName];
    NSDictionary * dic = self.dataArr[indexPath.row];
    [cell assignWithDic:dic];
    kkWeakSelf
    cell.getBlock = ^{
        [weakSelf getCouponWithParm:@{@"token":[UserDefaults token],@"quan_id":dic[@"quan_id"]}];
    };
    return cell;
}
- (void)getCouponWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"优惠券领取中"];
    [KKNetWork getCouponWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"领取成功"];
            [self getCouponList];
        } else {
            NSString * msg = dic[@"msg"];
            [KKAlert showErrorHint:msg];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"领取失败"];
    }];
}
@end
