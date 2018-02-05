//
//  MyCouponTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/9.
//

#import "MyCouponTableViewController.h"
#import "CouponTableViewCell.h"
@interface MyCouponTableViewController ()
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation MyCouponTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"我的优惠券";
    self.dataArr = [NSMutableArray new];
    [self getMyCoupons];
}
- (void)getMyCoupons
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getMyCouponWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell * cell = [CouponTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSString * imageName = indexPath.row%2?@"coupon_green":@"coupon_brown";
    cell.backImageView.image = [UIImage imageNamed:imageName];
    cell.isMine = YES;
    NSDictionary * dic = self.dataArr[indexPath.row];
    [cell assignWithDic:dic];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isUse == NO) {
        return;
    }
    NSDictionary * dic = self.dataArr[indexPath.row];
    NSString * is_use = dic[@"is_use"];
    if (is_use.integerValue == 1) {
        [KKAlert showErrorHint:@"该优惠券已使用"];
        return;
    }
    NSString * is_type = dic[@"is_type"];
    if (is_type.integerValue == 1) {
        [KKAlert showErrorHint:@"该优惠券已过期"];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectYouhuiQuan" object:nil userInfo:@{@"data":dic}];
    [self.navigationController popViewControllerAnimated:YES];
    /*{
        "end_time" = "2018-01-28";
        id = 9;
        info = "10\U5143\U62b5\U7528\U5238\Uff01";
        "is_type" = 0;
        "is_use" = 0;
        price = 11;
        "start_time" = "2017-12-28";
    }*/
}
@end
