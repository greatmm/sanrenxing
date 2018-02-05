//
//  LKTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "LKTableViewController.h"
#import "LKTableViewCell.h"
#import "AddLKViewController.h"
@interface LKTableViewController ()
@property(nonatomic,strong)NSArray * dataArr;
@end

@implementation LKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用旅客信息";
    UIControl * footer = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    UILabel * label = [UILabel new];
    label.frame = footer.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"新增常用旅客";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = kYellowColor;
    [footer addSubview:label];
    [footer addTarget:self action:@selector(addLK) forControlEvents:UIControlEventTouchUpInside];
    footer.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footer;
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
    [self getLKList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserDefaults isLK]) {
        [self getLKList];
        [UserDefaults saveAddLK:NO];
    }
}
- (void)getLKList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getLkListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.dataArr = dic[@"data"];
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)addLK
{
    AddLKViewController * addVC = [AddLKViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
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
    LKTableViewCell *cell = [LKTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    /*
     {
     id = 3;
     "lk_type" = "\U6210\U4eba";
     name = "\U53d1\U53d1";
     "zj_code" = 410425198910296536;
     "zj_type" = "\U8eab\U4efd\U8bc1";
     }
     */
    NSDictionary * dict = self.dataArr[indexPath.row];
    [cell assignWithDic:dict];
    kkWeakSelf
    cell.editBlock = ^{
        AddLKViewController * addVC = [AddLKViewController new];
        addVC.dict = dict;
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    };
    cell.delBlock = ^{
        [weakSelf delWithDic:dict];
    };
    return cell;
}
- (void)delWithDic:(NSDictionary *)dic
{
    [KKAlert showAnimateWithStauts:@"旅客删除中"];
    [KKNetWork delLKWithWithParm:@{@"token":[UserDefaults token],@"id":dic[@"id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self getLKList];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"删除旅客失败"];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
