//
//  FDZhiTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/24.
//

#import "FDZhiTableViewController.h"
#import "ShouzhiTableViewCell.h"

@interface FDZhiTableViewController ()
@property(nonatomic,strong)NSArray * dataArr;
@end

@implementation FDZhiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self getData];
}
- (void)getData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getFDShouzhiWithParm:@{@"token":[UserDefaults token],@"log_type":@"支出"} SuccessBlock:^(NSDictionary *dic) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSNumber * type = dict[@"tx_type"];
    NSInteger t = type.integerValue;
    NSString * typeS = @"";
    if (t == 0) {
        typeS = @"(审核中)";
    } else if (t == 1) {
        typeS = @"(已到账)";
    } else if(t == 2)  {
        typeS = @"(未通过审核)";
    }
    cell.stateLabel.text = @"支出";
    cell.moneyLabel.text = [NSString stringWithFormat:@"-%@%@",dict[@"price"],typeS];
    cell.timeLabel.text = dict[@"add_time"];
    return cell;
}

@end
