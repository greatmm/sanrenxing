//
//  LocationTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "LocationTableViewController.h"
#import "SearchCityView.h"
#import "CitySearchResultTableViewController.h"
@interface LocationTableViewController ()
@property(nonatomic,strong) NSMutableArray * titleArr;
@property(nonatomic,strong) NSMutableArray * cityArr;
@property(nonatomic,strong)SearchCityView * headerView;
@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityArr = [NSMutableArray new];
    self.tableView.sectionIndexColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    self.titleArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"W",@"X",@"Y",@"Z"].mutableCopy;
    for (int i = 0; i < 26; i ++) {
        NSMutableArray * arr = [NSMutableArray new];
        [self.cityArr addObject:arr];
    }
    self.tableView.tableFooterView = [UIView new];
    SearchCityView * searchView  = [[NSBundle mainBundle] loadNibNamed:@"SearchCityView" owner:nil options:nil].firstObject;
    kkWeakSelf
    searchView.clickBtnBlock = ^(NSDictionary *dic) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (weakSelf.backBlock) {
            weakSelf.backBlock(dic);
        }
    };
    searchView.cityLabel.text = self.city;
    self.headerView = searchView;
    searchView.frame = CGRectMake(0, 0, ScreenWidth, 110);
    self.tableView.tableHeaderView = searchView;
    [self getCityList];
    UIButton *  btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, self.navigationController.navigationBar.bounds.size.height - 37, ScreenWidth - 100, 30);
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"    输入搜索城市名" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:204/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
}
- (void)searchCity
{
    CitySearchResultTableViewController * citySearchVC = [CitySearchResultTableViewController new];
    kkWeakSelf
    citySearchVC.finishedSearchBlock = ^(NSDictionary *dict) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (weakSelf.backBlock) {
            weakSelf.backBlock(dict);
        }
    };
    [self.navigationController pushViewController:citySearchVC animated:YES];
}
- (void)getCityList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getCityListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * cityArr = dic[@"data1"];
            for (NSDictionary * dict in cityArr) {
                NSString * key = dict[@"zimu"];
                if ([self.titleArr containsObject:key]) {
                    NSInteger flag = [self.titleArr indexOfObject:key];
                    NSMutableArray * arr = self.cityArr[flag];
                    [arr addObject:dict];
                }
            }
            NSArray * hotCityArr = dic[@"data2"];
            self.headerView.hotCityArr = hotCityArr;
            NSArray * historyCityArr = dic[@"data3"];
         self.headerView.historyCityArr = historyCityArr;
         [self.tableView reloadData];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * arr = self.cityArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    NSArray * arr = self.cityArr[indexPath.section];
    NSDictionary * dict = arr[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleArr;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArr[section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * cityArr = self.cityArr[indexPath.section];
    NSDictionary * dict = cityArr[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backBlock) {
        self.backBlock(dict);
    }
}
@end
