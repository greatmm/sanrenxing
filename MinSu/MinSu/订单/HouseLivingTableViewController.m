//
//  HouseLivingTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/19.
//

#import "HouseLivingTableViewController.h"
#import "MyOrderTableViewCell.h"

@interface HouseLivingTableViewController ()
@property(nonatomic,strong)NSArray * orderArr;

@end

@implementation HouseLivingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)setOrderArr:(NSArray *)orderArr
{
    _orderArr = orderArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderArr) {
        return self.orderArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell * cell = [MyOrderTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.orderArr[indexPath.row];
    cell.dataDic = dic;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}
@end
