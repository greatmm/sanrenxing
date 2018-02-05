//
//  OrderlistTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/17.
//

#import "OrderlistTableViewController.h"
#import "MyOrderTableViewCell.h"

@interface OrderlistTableViewController ()
@property(nonatomic,strong)NSArray * orderArr;
@end

@implementation OrderlistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)setOrderArr:(NSArray *)orderArr
{
    _orderArr = orderArr;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyOrderTableViewCell * cell = [MyOrderTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.orderArr[indexPath.row];
    cell.dataDic = dic;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderArr) {
        return self.orderArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

@end
