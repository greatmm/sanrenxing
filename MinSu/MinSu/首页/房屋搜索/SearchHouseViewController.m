//
//  SearchHouseViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/13.
//

#import "SearchHouseViewController.h"
#import "KKHouseShowTableViewCell.h"
#import "DrogDownControl.h"
#import "LocationTableViewController.h"
#import "SelectTypeTableViewCell.h"

@interface SearchHouseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;//显示下拉选项的tableView
@property (strong,nonatomic) NSString * searchCity;//搜索的城市名
@property (strong,nonatomic) NSMutableArray * quArr;//区域数组
@property (strong,nonatomic) NSArray * conditionArr;//筛选条件数组
@property (strong,nonatomic) NSString * priceCondition;//排序条件
@property (strong,nonatomic) NSDictionary * quDic;//选中的区域

@property (strong,nonatomic) NSDictionary * conditionDic;//选中的筛选条件
@property (strong,nonatomic) NSArray * priceArr;
@property (strong,nonatomic) NSDictionary * priceDic;
@property (strong,nonatomic) NSMutableArray<DrogDownControl *>* controlArr;
@property (assign,nonatomic) NSInteger selectFlag;//点击的哪个下拉框
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) NSArray * houseArr;
@property (nonatomic,strong) UITextField * searchTf;
@end

@implementation SearchHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchTf;
    self.searchCity = [UserDefaults cityName];
    self.tableView.tableFooterView = [UIView new];
    self.resultTableView.tableFooterView = [UIView new];
    self.resultTableView.backgroundView = [UIView new];
    self.resultTableView.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.quArr = [NSMutableArray new];
    self.priceArr = @[@{@"id":@"price_asc",@"name":@"价格升序"},@{@"id":@"price_desc",@"name":@"价格降序"}];
    self.controlArr = [NSMutableArray new];
    NSArray * arr = @[@"全部",@"区域",@"排序",@"筛选"];
    for (int i = 0; i < 4; i ++) {
        DrogDownControl * drogView = [[NSBundle mainBundle] loadNibNamed:@"DrogDownControl" owner:nil options:nil].firstObject;
        drogView.tag = i;
        if (i == 0) {
            drogView.imageView.hidden = YES;
        }
        drogView.titleLabel.text = arr[i];
        UIView * aView = self.topView.subviews[i];
        drogView.frame = aView.bounds;
        [drogView addTarget:self action:@selector(clickDrogView:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:drogView];
        [self.controlArr addObject:drogView];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location_black"] style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    [self getHouseData];
}
- (UITextField *)searchTf
{
    if (_searchTf  ==  nil) {
        _searchTf = [UITextField new];
        _searchTf.frame = CGRectMake(50, self.navigationController.navigationBar.bounds.size.height - 37, ScreenWidth - 100, 30);
        _searchTf.textAlignment = NSTextAlignmentCenter;
        _searchTf.placeholder = @"输入搜索关键词";
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.selectFlag) {
        DrogDownControl * control  =self.controlArr[_selectFlag];
        if (control.selected) {
            [self clickDrogView:control];
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchHouse];
    return YES;
}
- (void)searchHouse
{
    NSMutableDictionary * parmDic = [NSMutableDictionary new];
    parmDic[@"token"] = [UserDefaults token];
    parmDic[@"city"] = self.searchCity;
    if (self.priceDic) {
        parmDic[self.priceDic[@"id"]] = @"1";
    }
    if (self.conditionDic) {
        parmDic[@"house_type_id"] = self.conditionDic[@"id"];
    }
    if (self.quDic) {
        parmDic[@"qy_id"] = self.quDic[@"id"];
    }
    parmDic[@"title"] = self.searchTf.text;
    NSLog(@"参数%@",parmDic);
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getSearchHouseListWithParm:parmDic SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.houseArr = dic[@"data1"];
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)getHouseData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getSearchHouseListWithParm:@{@"token":[UserDefaults token],@"city":self.searchCity} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.houseArr = dic[@"data1"];
            [self.quArr removeAllObjects];
            NSArray * data2 = dic[@"data2"];
            [self.quArr addObjectsFromArray:data2];
            self.conditionArr = dic[@"data3"];
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败   "];
    }];
}
- (void)selectCity
{
    LocationTableViewController * locationVC = [LocationTableViewController new];
    if (self.selectFlag) {
        DrogDownControl * control  =self.controlArr[_selectFlag];
        if (control.selected) {
            [self clickDrogView:control];
        }
    }
    locationVC.city = self.searchCity;
    kkWeakSelf
    locationVC.backBlock = ^(NSDictionary *dict) {
        NSString * city = dict[@"name"];
        if (city == nil || city.length == 0) {
            return;
        }
        if ([city isEqualToString:self.searchCity]) {
            return;
        }
        //清空所有搜索条件
        if (weakSelf.searchTf.text.length) {
            weakSelf.searchTf.text = @"";
        }
        
        if (weakSelf.quDic) {
            weakSelf.quDic = nil;
            DrogDownControl * control = weakSelf.controlArr[1];
            control.titleLabel.text = @"区域";
        }
        if (weakSelf.priceDic) {
            weakSelf.priceDic = nil;
            DrogDownControl * control = weakSelf.controlArr[2];
            control.titleLabel.text = @"排序";
        }
        if (weakSelf.conditionDic) {
            weakSelf.conditionDic = nil;
            DrogDownControl * control = self.controlArr[3];
            control.titleLabel.text = @"筛选";
        }
        weakSelf.resultTableView.hidden = YES;
        weakSelf.searchCity =  city;
        [weakSelf getHouseData];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}
- (void)clickDrogView:(DrogDownControl *)dragView
{
    [self.searchTf resignFirstResponder];
    if (dragView.tag == 0) {
        if (self.searchTf.text.length == 0 && self.priceDic == nil && self.quDic == nil && self.conditionDic == nil) {
            if (_selectFlag) {
                DrogDownControl * control = self.controlArr[_selectFlag];
                control.imageView.transform = CGAffineTransformIdentity;
                control.selected = NO;
                self.resultTableView.hidden = YES;
            }
            self.selectFlag = 0;
            return;
        }
    }
    if (dragView.tag != _selectFlag) {
        //把之前打开的关闭
        DrogDownControl * control = self.controlArr[_selectFlag];
        control.imageView.transform = CGAffineTransformIdentity;
        _selectFlag = dragView.tag;
    }
    if (dragView.tag == 0) {
        //清空所有搜索条件
        if (self.searchTf.text.length) {
            self.searchTf.text = @"";
        }
        
        if (self.quDic) {
            self.quDic = nil;
            DrogDownControl * control = self.controlArr[1];
            control.titleLabel.text = @"区域";
        }
        if (self.priceDic) {
            self.priceDic = nil;
            DrogDownControl * control = self.controlArr[2];
            control.titleLabel.text = @"排序";
        }
        if (self.conditionDic) {
            self.conditionDic = nil;
            DrogDownControl * control = self.controlArr[3];
            control.titleLabel.text = @"筛选";
        }
        self.resultTableView.hidden = YES;
        [self searchHouse];
        return;
    }
    dragView.selected = !dragView.selected;
    switch (_selectFlag) {
        case 0:
            self.dataArr = nil;
            break;
        case 1:
            self.dataArr = self.quArr;
            break;
        case 2:
            self.dataArr = self.priceArr;
            break;
        default:
            self.dataArr = self.conditionArr;
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (dragView.selected) {
            dragView.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            [self.resultTableView reloadData];
            self.resultTableView.hidden = NO;
        } else {
            dragView.imageView.transform = CGAffineTransformIdentity;
            self.resultTableView.hidden = YES;
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _resultTableView) {
        if (self.dataArr) {
            return self.dataArr.count;
        }
        return 0;
    }
    if (self.houseArr) {
        return self.houseArr.count;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.resultTableView) {
        DrogDownControl * control = self.controlArr[_selectFlag];
        switch (_selectFlag) {
            case 0:
            {
               
            }
                break;
             case 1:
            {
                NSDictionary * dict = self.dataArr[indexPath.row];
                if (self.quDic == dict) {
                    return;
                }
                self.quDic = dict;
                control.titleLabel.text = self.quDic[@"name"];
                control.imageView.transform = CGAffineTransformIdentity;
                control.selected = NO;
                self.resultTableView.hidden = YES;
                [self searchHouse];
            }
                break;
                case 2:
            {
                NSDictionary * dict = self.dataArr[indexPath.row];
                if (self.priceDic == dict) {
                    return;
                }
                self.priceDic = dict;
                control.titleLabel.text = self.priceDic[@"name"];
                control.imageView.transform = CGAffineTransformIdentity;
                control.selected = NO;
                self.resultTableView.hidden = YES;
                [self searchHouse];
            }
                break;
                case 3:
            {
                NSDictionary * dict = self.dataArr[indexPath.row];
                if (self.conditionDic == dict) {
                    return;
                }
                self.conditionDic = dict;
                control.titleLabel.text = self.conditionDic[@"name"];
                control.imageView.transform = CGAffineTransformIdentity;
                control.selected = NO;
                self.resultTableView.hidden = YES;
                [self searchHouse];
            }
                break;
            default:
                break;
        }
    } else {
        
    }
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (tableView == _resultTableView) {
//        return 1;
//    }
//    return 5;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _resultTableView) {
        SelectTypeTableViewCell * cell = [SelectTypeTableViewCell cellWithTableView:tableView indexPatch:indexPath];
        NSDictionary * dic = self.dataArr[indexPath.row];
        cell.selectLabel.text = dic[@"name"];
        switch (_selectFlag) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                if (self.quDic) {
                    NSInteger flag = [self.quArr indexOfObject:self.quDic];
                    if (indexPath.row == flag) {
                        cell.isSel = YES;
                    } else {
                        cell.isSel = NO;
                    }
                } else {
                    cell.isSel = NO;
                }
            }
                break;
                case 2:
            {
                if (self.priceDic) {
                    NSInteger flag = [self.priceArr indexOfObject:self.priceDic];
                    if (indexPath.row == flag) {
                        cell.isSel = YES;
                    } else {
                        cell.isSel = NO;
                    }
                } else {
                    cell.isSel = NO;
                }
            }
                break;
                case 3:
            {
                if (self.conditionDic) {
                    NSInteger flag = [self.conditionArr indexOfObject:self.conditionDic];
                    if (indexPath.row == flag) {
                        cell.isSel = YES;
                    } else {
                        cell.isSel = NO;
                    }
                } else {
                    cell.isSel = NO;
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
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
                [self searchHouse];
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
                [self searchHouse];
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
    if (tableView == _resultTableView) {
        return 44;
    }
    return 140;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _resultTableView) {
        return 0.1;
    }
    return section?0.1:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _resultTableView) {
        return 0.1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */
@end
