//
//  HousePingjiaTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/22.
//

#import "HousePingjiaTableViewController.h"
#import "HousePingjiaTableViewCell.h"
#import "PingjiaHuifuViewController.h"
@interface HousePingjiaTableViewController ()
@property(nonatomic,strong)NSArray * dataArr;
@end

@implementation HousePingjiaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPingjiaList];
    self.title = @"评价一览";
    self.tableView.tableFooterView = [UIView new];
}
- (void)getPingjiaList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getHousePingjiaListWithParm:@{@"token":[UserDefaults token],@"house_id":self.house_id} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * arr = dic[@"data"];
            if ([arr isKindOfClass:[NSArray class]]) {
                self.dataArr = arr;
                [self.tableView reloadData];
            }
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
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
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HousePingjiaTableViewCell * cell = [HousePingjiaTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    /*
     {
     "add_time" = "2018-01-22 17:02:56";
     "c_count" = 0;
     "comment_id" = 331;
     content = "\U771f\U7684\U5f88\U4e0d\U9519";
     "head_pic" = "https://q.qlogo.cn/qqapp/101456656/366A0453A752EB8A483F5FE0A03FF357/100";
     "hf_count" = 0;
     nickname = "\U53ef\U53ef";
     "u_coll" = 0;
     "user_id" = 50;
     }
     */
    NSDictionary * dict = self.dataArr[indexPath.row];
    [cell assignWithDic:dict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.dataArr[indexPath.row];
    NSString * content = @"  ";
    if (dict[@"content"]) {
        content = dict[@"content"];
    }
    CGFloat h = [content getHeightWithWidth:ScreenWidth - 90 fontSize:14];
    return 70 + h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PingjiaHuifuViewController * pingVC = [PingjiaHuifuViewController new];
    NSDictionary * dict = self.dataArr[indexPath.row];
    pingVC.comment_id = dict[@"comment_id"];
    [self.navigationController pushViewController:pingVC animated:YES];
}
@end
