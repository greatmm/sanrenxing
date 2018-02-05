//
//  AddHouseViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "AddHouseViewController.h"
#import "SelectTypeTableViewCell.h"
#import "ShowTypeTableViewCell.h"
#import "PublishHouseViewController.h"

@interface AddHouseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * fyArr;//房源类型
@property (nonatomic,strong) NSMutableArray * kjArr;//空间类型
@property (nonatomic,strong) NSIndexPath * fyIndex;//选中的房源
@property (nonatomic,strong) NSIndexPath * kjIndex;//选中的空间
@property (nonatomic,assign) BOOL fyOpen;//房源选项是否打开

@property (nonatomic,assign) BOOL kjOpen;//空间选项是否打开
@property (nonatomic,strong) NSArray * cityArr;
@end

@implementation AddHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加房源";
    self.fyArr = [NSMutableArray new];
    self.kjArr = [NSMutableArray new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    [self getData];
}
- (void)getData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork addHoustInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSString * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            NSArray * cityArr = dic[@"data1"];
            self.cityArr = cityArr;
            NSArray * fyArr = dic[@"data2"];
            NSArray * kjArr = dic[@"data3"];
            [self.fyArr addObjectsFromArray:fyArr];
            [self.kjArr addObjectsFromArray:kjArr];
            [self.tableView reloadData];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
}
- (void)setFyOpen:(BOOL)fyOpen
{
    if (_fyOpen == fyOpen) {
        return;
    }
    _fyOpen = fyOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)setKjOpen:(BOOL)kjOpen
{
    if (_kjOpen == kjOpen) {
        return;
    }
    _kjOpen = kjOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)nextStep:(id)sender {
    if (self.fyIndex == nil) {
        [KKAlert showErrorHint:@"请选择房源类型"];
        return;
    }
    if (self.kjIndex == nil) {
        [KKAlert showErrorHint:@"请选择空间类型"];
        return;
    }
    PublishHouseViewController * pubVC = [PublishHouseViewController new];
    pubVC.cityArr = self.cityArr;
    pubVC.fyDic = self.fyArr[_fyIndex.row - 1];
    pubVC.kjDic = self.kjArr[_kjIndex.row - 1];
    [self.navigationController pushViewController:pubVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        if (_kjOpen) {
            return self.kjArr.count + 1;
        }
        return 1;
    }
    if (_fyOpen) {
       return self.fyArr.count + 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        SelectTypeTableViewCell * cell = [SelectTypeTableViewCell cellWithTableView:tableView indexPatch:indexPath];
        NSDictionary * dic;
        if (indexPath.section) {
            dic = self.kjArr[indexPath.row - 1];
            if (indexPath == self.kjIndex) {
                cell.isSel = YES;
            } else {
                cell.isSel = NO;
            }
        } else {
            if (indexPath == self.fyIndex) {
                cell.isSel = YES;
            } else {
                cell.isSel = NO;
            }
            dic = self.fyArr[indexPath.row - 1];
        }
        NSString * name = dic[@"name"];
        if (name && [name isKindOfClass:[NSString class]]) {
            cell.selectLabel.text = name;
        } else {
            cell.selectLabel.text = @"";
        }
        return cell;
    }
    ShowTypeTableViewCell * cell = [ShowTypeTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    if (indexPath.section) {
        cell.btn.selected = self.kjOpen;
    } else {
        cell.btn.selected = self.fyOpen;
    }
    kkWeakSelf
    cell.clickBtnBlock = ^{
        if (indexPath.section) {
            weakSelf.kjOpen = !weakSelf.kjOpen;
        } else {
            weakSelf.fyOpen = !weakSelf.fyOpen;
        }
    };
    if (indexPath.section) {
        if (self.kjIndex) {
            NSDictionary * dic = self.kjArr[self.kjIndex.row - 1];
            NSString * name = dic[@"name"];
            if (name && [name isKindOfClass:[NSString class]]) {
                cell.typeLabel.text = name;
            } else {
                cell.typeLabel.text = @"请选择";
            }
            NSString * info = dic[@"info"];
            if (info && [info isKindOfClass:[NSString class]]) {
                cell.desLabel.text = info;
            } else {
                cell.desLabel.text = @"";
            }
            
        } else {
            cell.typeLabel.text = @"请选择";
            cell.desLabel.text = @"";
        }
    } else {
        if (self.fyIndex) {
            NSDictionary * dic = self.fyArr[self.fyIndex.row - 1];
            NSString * name = dic[@"name"];
            if (name && [name isKindOfClass:[NSString class]]) {
                cell.typeLabel.text = name;
            } else {
                cell.typeLabel.text = @"请选择";
            }
            NSString * info = dic[@"info"];
            if (info && [info isKindOfClass:[NSString class]]) {
                cell.desLabel.text = info;
            } else {
                cell.desLabel.text = @"";
            }
        } else {
            cell.typeLabel.text = @"请选择";
            cell.desLabel.text = @"";
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.section) {
        if (indexPath == self.kjIndex) {
            return;
        }
        self.kjIndex = indexPath;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (indexPath == self.fyIndex) {
            return;
        }
        self.fyIndex = indexPath;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithWhite:40/255.0 alpha:1];
    label.frame = CGRectMake(15, 0, ScreenWidth - 30, 44);
    label.text = section?@"空间类型":@"房源类型";
    [header addSubview:label];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
@end
