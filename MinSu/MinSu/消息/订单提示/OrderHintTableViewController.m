//
//  OrderHintTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "OrderHintTableViewController.h"
#import "OrderHIntTableViewCell.h"
#import "OrderHintItem.h"
@interface OrderHintTableViewController ()
@property(nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation OrderHintTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getOrderMsg];
}
- (void)getOrderMsg
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getOrderMsgWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self.dataArr removeAllObjects];
            NSArray * arr = dic[@"data"];
            for (NSDictionary * dict in arr) {
                OrderHintItem * item = [OrderHintItem itemWithDic:dict];
                [self.dataArr addObject:item];
            }
            [self.tableView reloadData];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     OrderHIntTableViewCell *cell = [OrderHIntTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    OrderHintItem * item = self.dataArr[indexPath.row];
    cell.timeLabel.text = item.timeStr;
    cell.dateLabel.text = item.dateStr;
    cell.desLabel.text = item.contentStr;
    cell.titleLabel.text = item.hintTitle;
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHintItem * item = self.dataArr[indexPath.row];
    CGFloat h = [item.contentStr getHeightWithWidth:(ScreenWidth - 30) fontSize:14];
    return 150 + h;
}
@end
