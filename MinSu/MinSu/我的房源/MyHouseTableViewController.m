//
//  MyHouseTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "MyHouseTableViewController.h"
#import "KKHouseShowTableViewCell.h"
#import "AddHouseViewController.h"
#import "BrowseHouseViewController.h"
@interface MyHouseTableViewController ()
@property (nonatomic,strong) NSMutableArray * houseArr;
@end

@implementation MyHouseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.houseArr = [NSMutableArray new];
    self.title = @"我的房源";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithName:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    [self getHouseList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.changed) {
        [self getHouseList];
        self.changed = NO;
    }
}
- (void)getHouseList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getFdHouseListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            [self.houseArr removeAllObjects];
            NSArray * data = dic[@"data"];
            [self.houseArr addObjectsFromArray:data];
            [self.tableView reloadData];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)add
{
    AddHouseViewController * vc = [AddHouseViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKHouseShowTableViewCell * cell = [KKHouseShowTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dict = self.houseArr[indexPath.row];
    [cell assignWithDic:dict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.houseArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowseHouseViewController * browseVC = [BrowseHouseViewController new];
    NSDictionary * dict = self.houseArr[indexPath.row];
    browseVC.house_id = dict[@"house_id"];
    [self.navigationController pushViewController:browseVC animated:YES];
}
@end
