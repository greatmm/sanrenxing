//
//  SettingTableViewController.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "SettingTableViewController.h"
#import "KKNavigationController.h"
#import "LoginViewController.h"

static NSString * iden = @"identify";

@interface SettingTableViewController ()
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"修改密码",@"功能反馈",@"关于"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:iden];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:247/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:247/255.0 alpha:1];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"设置";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    ;
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footer = [UIView new];
    footer.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:247/255.0 alpha:1];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 115, CGRectGetWidth(self.view.bounds), 44);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 160;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = @[@"EditPwdViewController",@"FeedbackViewController",@"AboutUsViewController"];
    NSString * str = arr[indexPath.row];
    Class clss =  NSClassFromString(str);
    [self.navigationController pushViewController:[clss new] animated:YES];
}
- (void)loginOut
{
    [UserDefaults clearCache];
    KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}
@end
