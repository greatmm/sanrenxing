//
//  HouseDetailViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/29.
//

#import "HouseDetailViewController.h"
#import "HouseDetailBottomView.h"
#import "DetailTableViewCellValue1.h"
#import "DeatilTableViewCellValue2.h"
#import "KKCalendarView.h"

#import "SDCycleScrollView.h"
#import "PayViewController.h"
#import "KKUtils.h"
#import "HousePingjiaTableViewController.h"
@interface HouseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)SDCycleScrollView * cycleView;//轮播图
@property (nonatomic,strong) KKCalendarView * calView;
@property(nonatomic,strong) NSDictionary * dataDic;
@property(nonatomic,assign) BOOL collected;
@property(nonatomic,strong)HouseDetailBottomView * footer;
@property(nonatomic,assign)NSUInteger days;//入住天数
@property(nonatomic,strong)NSString * check_time;//入住日期
@property(nonatomic,strong)NSString * leave_time;//离开日期
@end

@implementation HouseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = self.cycleView;
//    self.tableView.tableFooterView = self.footer;
//    self.footer.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [self getHouseDeatil];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (HouseDetailBottomView *)footer
{
    if (_footer) {
        return _footer;
    }
    HouseDetailBottomView * footer = [[NSBundle mainBundle] loadNibNamed:@"HouseDetailBottomView" owner:nil options:nil].firstObject;
    kkWeakSelf
    footer.bookBlock = ^{
        if (weakSelf.dataDic == nil) {
            [KKAlert showErrorHint:@"获取数据失败"];
            return;
        }
        if (weakSelf.check_time == nil) {
            [KKAlert showErrorHint:@"请选择入住日期"];
            return;
        }
        if (weakSelf.leave_time == nil) {
            [KKAlert showErrorHint:@"请选择离开日期"];
            return;
        }
        
        NSDictionary * parm = @{@"token":[UserDefaults token],@"house_id":weakSelf.house_id,@"check_time":weakSelf.check_time,@"leave_time":weakSelf.leave_time,@"house_price":weakSelf.dataDic[@"house_price"],@"days":[NSString stringWithFormat:@"%ld",weakSelf.days]};
        [KKAlert showAnimateWithStauts:@"订单提交中..."];
        [KKNetWork addOrderWithParm:parm SuccessBlock:^(NSDictionary *dic) {
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert dismiss];
                NSString * data = dic[@"data"];//订单编码
                KKLog(@"%@",dic);
                PayViewController * payVC = [PayViewController new];
                payVC.orderId = data;
                [weakSelf.navigationController pushViewController:payVC animated:YES];
            } else {
                [KKAlert dismiss];
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            
        }];
    };
    _footer = footer;
    return _footer;
}

- (void)getHouseDeatil
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getHouseDetailWithParm:@{@"token":[UserDefaults token],@"house_id":self.house_id} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.dataDic = dic[@"data"];
            NSString * price = self.dataDic[@"house_price"];
            if (price) {
                self.calView.price = [NSString stringWithFormat:@"¥%@",price];
            } else {
                self.calView.price = @"¥0";
            }
            NSString * collect = self.dataDic[@"collect"];
            self.collected = collect.integerValue;
            NSMutableArray * arr = [NSMutableArray new];
            NSArray * imageArr = self.dataDic[@"house_img"];
            for (NSString * str in imageArr) {
                [arr addObject:[NSString stringWithFormat:@"%@%@",baseUrl,str]];
            }
            self.cycleView.imageURLStringsGroup = arr;
            [self.tableView reloadData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (KKCalendarView *)calView
{
    if (_calView) {
        return _calView;
    }
    _calView = [KKCalendarView shareCalendarView];
    _calView.isHouse = YES;
    _calView.frame = CGRectMake(0, 0, ScreenWidth, 470);
    kkWeakSelf
    _calView.selectDateBlock = ^(NSArray *dateArr) {
        NSInteger count = dateArr.count;
        if (count == 0) {
            return;
        }
        if (count == 1) {
            NSDate * indate = dateArr.firstObject;
            NSString * dateStr = [KKUtils dateStringFromDate:indate withFormat:@"yyyy-MM-dd"];
            weakSelf.check_time = dateStr;
            weakSelf.footer.inLabel.text = [NSString stringWithFormat:@"入住:%@",dateStr];
            weakSelf.footer.leaveLabel.text = @"入住";
            weakSelf.footer.timeLabel.text = @"共0晚";
            return;
        }
        if (count == 2) {
            NSDate * indate = dateArr.firstObject;
            NSString * dateStr = [KKUtils dateStringFromDate:indate withFormat:@"yyyy-MM-dd"];
            weakSelf.check_time = dateStr;
            weakSelf.footer.inLabel.text = [NSString stringWithFormat:@"入住:%@",dateStr];
            NSDate * leaveDate = dateArr.lastObject;
            NSString * leaveStr = [KKUtils dateStringFromDate:leaveDate withFormat:@"yyyy-MM-dd"];
            weakSelf.leave_time = leaveStr;
            weakSelf.footer.leaveLabel.text = [NSString stringWithFormat:@"离开:%@",leaveStr];
            NSUInteger days = [KKUtils daysBetweenDate1:indate date2:leaveDate];
            weakSelf.days = days;
            weakSelf.footer.timeLabel.text = [NSString stringWithFormat:@"共%lu晚",(unsigned long)days];
        }
    };
    [_calView layoutIfNeeded];
    return _calView;
}

- (SDCycleScrollView *)cycleView
{
    if (_cycleView) {
        return _cycleView;
    }
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"4.jpg"]];
    return _cycleView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return self.footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            DetailTableViewCellValue1 * cell = [DetailTableViewCellValue1 cellWithTableView:tableView indexPatch:indexPath];
            if (self.dataDic) {
                cell.titleLabel.text = self.dataDic[@"title"];
                cell.desLabel.text = self.dataDic[@"house_info"];
                cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",self.dataDic[@"city"],self.dataDic[@"district"],self.dataDic[@"town"]];
                [cell.pingjiaBtn setTitle:[NSString stringWithFormat:@"    %@条评价",self.dataDic[@"com_count"]] forState:UIControlStateNormal];
                [cell.pingjiaBtn addTarget:self action:@selector(pingjiaList) forControlEvents:UIControlEventTouchUpInside];
                NSString * price = self.dataDic[@"house_price"];
                NSString * priceStr = [NSString stringWithFormat:@"¥%@/天",price];
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:priceStr];
                NSRange range = [priceStr rangeOfString:price];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
                cell.priceLabel.attributedText = str;
                
                if (self.collected) {
                    [cell.shoucangBtn setImage:[UIImage imageNamed:@"like_sel"] forState:UIControlStateNormal];
                } else {
                    [cell.shoucangBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                }
                [cell.shoucangBtn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
            break;
        case 1:
        {
            DeatilTableViewCellValue2 * cell = [DeatilTableViewCellValue2 cellWithTableView:tableView indexPatch:indexPath];
            if (self.dataDic) {
                [cell assignWithDic:self.dataDic];
            }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:self.calView];
                UIView * line = [UIView new];
                line.frame = CGRectMake(0, 470, ScreenWidth, 10);
                line.backgroundColor =  [UIColor colorWithWhite:245/255.0 alpha:1];
                [cell.contentView addSubview:line];
            }
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}
- (void)collect
{
    if (self.dataDic == nil) {
        [KKAlert showErrorHint:@"获取数据失败"];
        return;
    }
    NSDictionary * parm = @{@"token":[UserDefaults token],@"house_id":self.house_id};
    if (self.collected) {
        [self delCollectWithParm:parm];
    } else {
        [self addCollectWithParm:parm];
    }
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
                self.collected = YES;
                NSString * collect = self.dataDic[@"collect"];
                if (self.collected == collect.integerValue) {
                    [UserDefaults saveCollectUpdate:NO];
                } else {
                    [UserDefaults saveCollectUpdate:YES];
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
                self.collected = NO;
                NSString * collect = self.dataDic[@"collect"];
                if (self.collected == collect.integerValue) {
                    [UserDefaults saveCollectUpdate:NO];
                } else {
                    [UserDefaults saveCollectUpdate:YES];
                }
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    if (indexPath.row == 0) {
        return 115;
    }
    if (indexPath.row == 1) {
        return 213;
    }
    return 480;
}
//调至评价列表
- (void)pingjiaList
{
    HousePingjiaTableViewController * pingjiaVC  = [HousePingjiaTableViewController new];
    pingjiaVC.house_id = self.house_id;
    [self.navigationController pushViewController:pingjiaVC animated:YES];
}

@end
