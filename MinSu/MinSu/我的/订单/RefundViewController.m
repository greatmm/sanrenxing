//
//  RefundViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "RefundViewController.h"
#import "RefundTopTableViewCell.h"
#import "PayBottomTableViewCell.h"
#import "KKUtils.h"
@interface RefundViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UITextView * textView;
@property (strong,nonatomic) NSDictionary * orderDic;
@property (strong,nonatomic) NSIndexPath * selIndex;
@property(strong,nonatomic) NSString * tuifangDatestr;//退房时间
@end

@implementation RefundViewController

- (IBAction)applyTuikuan:(id)sender {
    if (self.isTuifang) {
        [self tuifang];
    } else {
        [self tuiKuan];
    }
}
- (void)tuifang
{
    if (self.tuifangDatestr == nil) {
        [KKAlert showErrorHint:@"请选择退房时间"];
        return;
    }
    if (self.selIndex == nil && self.textView.text.length == 0) {
        [KKAlert showErrorHint:@"请选择退房原因"];
        return;
    }
    NSString * type;
    if (self.selIndex) {
        NSArray * arr = @[@"订单信息有误",@"行程有变",@"其它理由"];
        type = arr[self.selIndex.row];
    }
    NSString * content;
    if (self.textView.text.length) {
        content = self.textView.text;
    }
    NSMutableDictionary * parm = [NSMutableDictionary new];
    parm[@"token"] = [UserDefaults token];
    parm[@"order_id"] = self.orderId;
    if (type) {
        parm[@"tuikuan_type"] = type;
    }
    if (content) {
        parm[@"tuikuan_txt"] = content;
    }
    [KKAlert showAnimateWithStauts:@"退房申请中"];
    [KKNetWork appleyTuifangWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"提交申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据提交失败"];
    }];
}
- (void)tuiKuan
{
    if (self.selIndex == nil && self.textView.text.length == 0) {
        [KKAlert showErrorHint:@"请选择退款原因"];
        return;
    }
    NSString * type;
    if (self.selIndex) {
        NSArray * arr = @[@"订单信息有误",@"行程有变",@"其它理由"];
        type = arr[self.selIndex.row];
    }
    NSString * content;
    if (self.textView.text.length) {
        content = self.textView.text;
    }
    NSMutableDictionary * parm = [NSMutableDictionary new];
    parm[@"token"] = [UserDefaults token];
    parm[@"order_id"] = self.orderId;
    if (type) {
        parm[@"tuikuan_type"] = type;
    }
    if (content) {
        parm[@"tuikuan_txt"] = content;
    }
    [KKAlert showAnimateWithStauts:@"退款申请中"];
    [KKNetWork applyTuikuanWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"提交申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据提交失败"];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isTuifang) {
        self.title = @"退房申请";
    } else {
        self.title = @"退款申请";
    }
    self.tableView.separatorColor = [UIColor colorWithWhite:245/255.0 alpha:1];
    UIView * footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    footer.frame = CGRectMake(0, 0, ScreenWidth, 140);
    [footer addSubview:self.textView];
    self.tableView.tableFooterView = footer;
    [self getOrderInfo];
}
- (void)getOrderInfo
{
    if (self.isTuifang) {
        [self getTuifangInfo];
    } else {
        [self getTuikuanInfo];
    }
}
- (void)getTuikuanInfo
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getTuikuanInfoWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.orderDic = dic[@"data"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}

- (void)getTuifangInfo
{
    /*{
     "check_time" = "2018-01-27";
     city = "\U90d1\U5dde\U5e02";
     days = 2;
     district = "\U4e2d\U539f\U533a";
     "house_id" = 24;
     "house_img" = "/Uploads/Images/2018-01-19/5a614c962b157.png";
     "house_info" = "\U5730\U6bb5\U597d\Uff0c\U4ef7\U683c\U4f18";
     "leave_time" = "2018-01-29";
     "order_id" = 76;
     "order_sn" = fy201801191454568485;
     province = "\U6cb3\U5357\U7701";
     title = "\U90d1\U5dde\U597d\U623f\U51fa\U79df";
     town = "\U5efa\U8bbe\U8def\U8857\U9053";
     };*/
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork applyTuifangInfoWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.orderDic = dic[@"data"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 100)];
        _textView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        _textView.delegate = self;
    }
    return _textView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isTuifang) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isTuifang) {
        return section == 2?3:1;
    }
    return section?3:1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RefundTopTableViewCell * cell = [RefundTopTableViewCell cellWithTableView:tableView indexPatch:indexPath];
        if (self.orderDic) {
            [cell assignWithDic:self.orderDic];
        }
        return cell;
    }
    if (self.isTuifang) {
        if (indexPath.section == 1) {
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
            if (self.tuifangDatestr) {
                cell.textLabel.text = self.tuifangDatestr;
            } else {
                cell.textLabel.text = @"请选择退房时间";
            }
            cell.textLabel.textColor = k102Color;
            return cell;
        }
    }
    PayBottomTableViewCell * cell = [PayBottomTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSArray * arr = @[@"订单信息有误",@"行程有变",@"其它理由"];
    cell.textLabel.text = arr[indexPath.row];
    if (indexPath == self.selIndex) {
        cell.cycleBtn.selected = YES;
        cell.textLabel.textColor = kYellowColor;
    } else {
        cell.cycleBtn.selected = NO;
        cell.textLabel.textColor = k153Color;
    }
    kkWeakSelf
    cell.selectBlock = ^{
        weakSelf.selIndex = indexPath;
        NSInteger flag = weakSelf.isTuifang + 1;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:flag] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 174;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isTuifang) {
        if (section == 2) {
            return 30;
        }
        return 0.1;
    }
    
    return section?30:0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isTuifang) {
        if (section == 2) {
            UILabel * label = [UILabel new];
            label.text = @"   退房原因";
            label.textColor = k40Color;
            label.backgroundColor = [UIColor whiteColor];
            return label;
        }
    } else  {
        if (section == 1) {
            UILabel * label = [UILabel new];
            label.text = @"   退订原因";
            label.textColor = k40Color;
            label.backgroundColor = [UIColor whiteColor];
            return label;
        }
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker * datePicker = [UIDatePicker new];
    datePicker.datePickerMode  = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    if (self.orderDic) {
        NSString * checkTime = self.orderDic[@"check_time"];
        NSDate * checkDate = [KKUtils stringToDate:checkTime];
        NSString * leaveTime = self.orderDic[@"leave_time"];
        NSDate * leaveDate =  [KKUtils stringToDate:leaveTime];
        datePicker.minimumDate = checkDate;
        datePicker.maximumDate = leaveDate;
    }
    [alert.view addSubview:datePicker];
    UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.tuifangDatestr = [dateFormat stringFromDate:datePicker.date];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction * cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ensure];
    [alert addAction:cacelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
