//
//  HelpTableViewController.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "HelpTableViewController.h"

@interface HelpTableViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITextField *searchTf;//搜索框
@end

@implementation HelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    UIView * header = [UIView new];
    header.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 58);
    [header addSubview:self.searchTf];
    self.tableView.tableHeaderView = header;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"帮助";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UITextField *)searchTf
{
    if (nil == _searchTf) {
        _searchTf = [UITextField new];
        _searchTf.frame = CGRectMake(20, 15, CGRectGetWidth(self.view.bounds) - 40, 28);
        _searchTf.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
        _searchTf.layer.cornerRadius = 14;
        _searchTf.layer.masksToBounds = YES;
        _searchTf.placeholder = @"🔍 输入搜索关键词";
        _searchTf.font = [UIFont systemFontOfSize:12];
        _searchTf.textAlignment = NSTextAlignmentCenter;
        _searchTf.delegate = self;
        _searchTf.returnKeyType = UIReturnKeySearch;
    }
    return _searchTf;
}
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
        [_dataArr addObject:@"帮助的内容标题"];
    }
    return _dataArr;
}
#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * iden = @"iden";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        ;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString * str = textField.text;
    NSLog(@"搜索%@",str);
    textField.text = @"";
    return YES;
}
@end
