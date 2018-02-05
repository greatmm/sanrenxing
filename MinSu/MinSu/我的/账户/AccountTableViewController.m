//
//  AccountTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "AccountTableViewController.h"

@interface AccountTableViewController ()

@property (nonatomic,strong) NSArray * dataArr;

@end

@implementation AccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UserDefaults isHouse] == NO) {
        self.dataArr = @[@"个人资料",@"送货地址",@"常用旅客"];
    } else {
        self.dataArr = @[@"个人资料",@"送货地址",@"常用旅客",@"我的余额"];
    }
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"账户";
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIView new];
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
    static NSString * reuse = @"reuse";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = @[@"PersonInfoTableViewController",@"AddressViewController",@"LKTableViewController",@"MyMoneyViewController"];
    Class class = NSClassFromString(arr[indexPath.row]);
    [self.navigationController pushViewController:[class new] animated:YES];
}
@end
