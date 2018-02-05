//
//  CitySearchResultTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/15.
//

#import "CitySearchResultTableViewController.h"

@interface CitySearchResultTableViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField * searchTf;
@property(nonatomic,strong) NSArray * dataArr;
@end

@implementation CitySearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.titleView = self.searchTf;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchTf becomeFirstResponder];
}
- (UITextField *)searchTf
{
    if (_searchTf == nil) {
        _searchTf = [UITextField new];
        _searchTf.frame = CGRectMake(50, self.navigationController.navigationBar.bounds.size.height - 37, ScreenWidth - 100, 30);
        _searchTf.textAlignment = NSTextAlignmentCenter;
        _searchTf.placeholder = @"输入搜索城市名";
        _searchTf.textColor = k153Color;
        _searchTf.font = [UIFont systemFontOfSize:14];
        _searchTf.layer.cornerRadius = 15;
        _searchTf.layer.masksToBounds = YES;
        _searchTf.layer.borderWidth = 0.5;
        _searchTf.layer.borderColor = k153Color.CGColor;
        _searchTf.delegate = self;
        _searchTf.returnKeyType = UIReturnKeySearch;
    }
    return _searchTf;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchCity];
    return YES;
}
- (void)searchCity
{
    [KKAlert showAnimateWithStauts:@"搜索中..."];
    [KKNetWork searchCityWithParm:@{@"city":self.searchTf.text} SuccessBlock:^(NSDictionary *dic) {
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
        [KKAlert showErrorHint:@"搜索失败"];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr == nil?0:self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    NSDictionary * dict = self.dataArr[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    /*
     {
     id = 45471;
     name = "\U6d77\U5317\U5dde";
     "parent_id" = 45286;
     }
     */
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = self.dataArr[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.finishedSearchBlock) {
        self.finishedSearchBlock(dict);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
