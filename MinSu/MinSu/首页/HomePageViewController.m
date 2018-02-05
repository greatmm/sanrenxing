//
//  HomePageViewController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "HomePageViewController.h"
#import "KKHouseShowTableViewCell.h"
#import "KKFlowLayout.h"
#import "KKPictureCollectionViewCell.h"
#import "KKStoryCollectionViewCell.h"
#import "SignInViewController.h"
#import "HouseDetailViewController.h"
#import "LocationTableViewController.h"
#import "SearchHouseViewController.h"
#import "KKLocationTool.h"
#import <SafariServices/SafariServices.h>
@interface HomePageViewController ()<SDCycleScrollViewDelegate>
//@property (nonatomic,strong) UICollectionView * pictureCV;//顶部图片
@property(nonatomic,strong) SDCycleScrollView * picView;
@property (nonatomic,strong) UIView * headerView;
@property(nonatomic,strong) KKLocationTool * locTool;
@property(nonatomic,strong) NSMutableArray * imageArr;
@property(nonatomic,strong) NSMutableArray *linkArr;
@property(nonatomic,assign) BOOL finished;
@property(nonatomic,strong) NSArray * houseArr;
@property(nonatomic,strong) NSString * localCity;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finished = YES;
    self.imageArr = [NSMutableArray new];
    self.linkArr = [NSMutableArray new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIButton *  btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, self.navigationController.navigationBar.bounds.size.height - 37, ScreenWidth - 100, 30);
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"    输入搜索关键词" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:204/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchHouse) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"signin"] style:UIBarButtonItemStylePlain target:self action:@selector(clickSignIn)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_black"] style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.locTool = [KKLocationTool new];
    [self.locTool startLocation];
    kkWeakSelf
    self.locTool.getCityBlock = ^{
        if (weakSelf.finished && weakSelf.imageArr.count == 0) {
            weakSelf.localCity = [UserDefaults cityName];
            [weakSelf getHomepageData];
        }
    };
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserDefaults collectUpdate]) {
        [self getHomepageData];
        [UserDefaults saveCollectUpdate:NO];
    }
}
- (void)getHomepageData
{
    NSString * token = [UserDefaults token];
    self.finished = NO;
    [KKAlert showAnimateWithStauts:@"数据请求中"];
    NSDictionary * parmDic;
    if (token) {
        parmDic = @{@"city_name":self.localCity,@"token":token};
    } else {
        parmDic = @{@"city_name":self.localCity};
    }
    [KKNetWork getHouseListWithParm:parmDic SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        self.finished = YES;
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * data1 = dic[@"data1"];//房屋数据
            self.houseArr = data1;
            [self.tableView reloadData];
            if (self.imageArr.count) {
                return;
            }
            NSArray * data2  = dic[@"data2"];//轮播图数据
            for (NSDictionary * dict in data2) {
                NSString * imageUrl = [NSString stringWithFormat:@"%@%@",baseUrl,dict[@"ad_code"]];
                [self.imageArr addObject:imageUrl];
                NSString * linkUrl = dict[@"ad_link"];
                if ([linkUrl containsString:@"http"]) {
                    [self.linkArr addObject:linkUrl];
                } else {
                    linkUrl =  [NSString stringWithFormat:@"http://%@",linkUrl];
                    [self.linkArr addObject:linkUrl];
                }
            }
            self.picView.imageURLStringsGroup = self.imageArr;
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        self.finished = YES;
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
}
- (void)searchHouse
{
    SearchHouseViewController * searchVC = [SearchHouseViewController new];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - buttonClick
- (void)selectCity
{
    LocationTableViewController * locationVC = [LocationTableViewController new];
    locationVC.city = self.localCity;
    kkWeakSelf
    locationVC.backBlock = ^(NSDictionary * dict) {
        NSString * cityName = dict[@"name"];
        if (cityName == nil || [cityName isEqualToString:weakSelf.localCity]) {
            return;
        }
        weakSelf.localCity = cityName;
        [weakSelf getHomepageData];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}
- (void)clickSignIn
{
    SignInViewController * vc = [SignInViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - collectionView
- (SDCycleScrollView *)picView
{
    if (_picView) {
        return _picView;
    }
    _picView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) delegate:self placeholderImage:nil];
    return _picView;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString * url = self.linkArr[index];
    SFSafariViewController * sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController presentViewController:sfVC animated:YES completion:nil];
}
/*
-(UICollectionView *)pictureCV
{
    if (_pictureCV) {
        return _pictureCV;
    }
    // 创建流水布局
    KKFlowLayout *flowLayout = [[KKFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 60, 170);
    
    CGFloat margin = 30;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 170) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"KKPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KKPictureCollectionViewCell"];
    collectionView.showsHorizontalScrollIndicator = NO;
    _pictureCV = collectionView;
    _pictureCV.backgroundColor = [UIColor whiteColor];
    return _pictureCV;
}
*/
//- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    KKPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKPictureCollectionViewCell" forIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",indexPath.row%5]];
//    return cell;
//}
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 50;
//}
#pragma mark - tableView
- (UIView *)headerView
{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [UIView new];
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 245);
    [_headerView addSubview:self.picView];
    UIView * black_lineView = [[NSBundle mainBundle] loadNibNamed:@"black_line_header" owner:nil options:nil][0];
    black_lineView.frame = CGRectMake(0, CGRectGetMaxY(self.picView.frame) + 20, CGRectGetWidth(self.view.bounds), 30);
    [_headerView addSubview:black_lineView];
    return _headerView;
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.houseArr) {
        return self.houseArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKHouseShowTableViewCell * cell = [KKHouseShowTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.houseArr[indexPath.row];
    kkWeakSelf
    cell.collectBlock = ^{
        NSNumber * collect = dic[@"collect"];
        if (collect == nil) {
            return;
        }
        if (collect.integerValue == 1) {
            NSDictionary * parm = @{@"token":[UserDefaults token],@"house_id":dic[@"house_id"]};
            [weakSelf delCollectWithParm:parm];
        } else {
            NSDictionary * parm = @{@"token":[UserDefaults token],@"house_id":dic[@"house_id"]};
            [weakSelf addCollectWithParm:parm];
        }
    };
    [cell assignWithDic:dic];
    return cell;
}
- (void)addCollectWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"收藏中"];
    [KKNetWork addCollectWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getHomepageData];
            });
        } else {
            NSString * msg = dic[@"msg"];
            [KKAlert showErrorHint:msg];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"收藏失败"];
    }];
}
- (void)delCollectWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"取消收藏中"];
    [KKNetWork delCollectWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"取消收藏成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getHomepageData];
            });
        } else {
            NSString * msg = dic[@"msg"];
            [KKAlert showErrorHint:msg];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"取消收藏失败"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 245;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseDetailViewController * vc = [HouseDetailViewController new];
    NSDictionary * dic = self.houseArr[indexPath.row];
    vc.house_id = dic[@"house_id"];
//    HouseDetailTableViewController * vc = [HouseDetailTableViewController new];
//    NSDictionary * dic = self.houseArr[indexPath.row];
//    vc.house_id = dic[@"house_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
