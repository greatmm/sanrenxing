//
//  MyCollectionTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "MyCollectionTableViewController.h"
#import "KKHouseShowTableViewCell.h"

@interface MyCollectionTableViewController ()
@property(nonatomic,strong)NSArray * collectArr;
@end

@implementation MyCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.navigationController.navigationBar.hidden = NO;
    [self getCollectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.collectArr) {
        return self.collectArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHouseShowTableViewCell * cell = [KKHouseShowTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.collectArr[indexPath.row];
    [cell assignWithDic:dic];
//    cell.isLike = YES;
//    kkWeakSelf
//    cell.collectBlock = ^{
//        
//    };
    return cell;
}
- (void)getCollectList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getCollectListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * data = dic[@"data"];
            self.collectArr = data;
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
@end
