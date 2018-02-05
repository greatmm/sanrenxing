//
//  FDShouTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/24.
//

#import "FDShouTableViewController.h"
#import "ShouzhiTableViewCell.h"
@interface FDShouTableViewController ()
@property(nonatomic,strong)NSArray * dataArr;
@end

@implementation FDShouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getFDShouzhiWithParm:@{@"token":[UserDefaults token],@"log_type":@"收入"} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * data = dic[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                self.dataArr = data;
                [self.tableView reloadData];
            }
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShouzhiTableViewCell * cell = [ShouzhiTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dict = self.dataArr[indexPath.row];
    cell.stateLabel.text = @"收入";
    cell.moneyLabel.text = [NSString stringWithFormat:@"+%@",dict[@"price"]];
    cell.timeLabel.text = dict[@"add_time"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
