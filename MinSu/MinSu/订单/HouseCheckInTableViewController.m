//
//  HouseCheckInTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/19.
//

#import "HouseCheckInTableViewController.h"
#import "MyOrderTableViewCell.h"

@interface HouseCheckInTableViewController ()
@property(nonatomic,copy)NSArray * orderArr;
@end

@implementation HouseCheckInTableViewController

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
        KKLog(@"%@共有%ld个",[self class],self.orderArr.count);

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
