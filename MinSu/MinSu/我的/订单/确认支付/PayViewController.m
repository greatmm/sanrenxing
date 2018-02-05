//
//  PayViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "PayViewController.h"
#import "PayTopTableViewCell.h"
#import "PayBottomTableViewCell.h"
#import "MyCouponTableViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSIndexPath * selIndexPath;
@property (nonatomic,strong) NSDictionary * orderDic;
@property (nonatomic,strong) NSDictionary * youhuiDic;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self getPayInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwxPayResult:) name:@"wxPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealAliPayResult:) name:@"aliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectYouhui:) name:@"selectYouhuiQuan" object:nil];
}
- (void)selectYouhui:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo[@"data"];
    self.youhuiDic = dic;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)dealAliPayResult:(NSNotification *)noti
{
    NSDictionary * dict = noti.userInfo;
    NSDictionary * dic = dict[@"aliResult"];
    [self dealAliWithDic:dic];
}
- (void)dealAliWithDic:(NSDictionary *)dic
{
    NSNumber * resultCode = dic[@"resultStatus"];
    NSInteger code = resultCode.integerValue;
    if (code == 9000) {
        NSString * youhuiId = @"";
        if (self.youhuiDic) {
            youhuiId = self.youhuiDic[@"id"];
        }
        [KKAlert showAnimateWithStauts:@"数据提交中"];
        [KKNetWork paySuccessWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId,@"id":youhuiId} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                self.youhuiDic = nil;
                [KKAlert showSuccessHint:@"房屋预定成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"数据提交失败"];
        }];
    } else if(code == 6001) {
        [KKAlert showErrorHint:@"您取消了支付"];
    } else {
        [KKAlert showErrorHint:@"支付失败"];
    }
}
- (void)dealwxPayResult:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo;
    NSNumber * state = dic[@"state"];
    NSInteger s = state.integerValue;
    if (s == 1) {
        NSString * youhuiId = @"";
        if (self.youhuiDic) {
            youhuiId = self.youhuiDic[@"id"];
        }
        [KKAlert showAnimateWithStauts:@"数据提交中"];
        [KKNetWork paySuccessWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId,@"id":youhuiId} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                self.youhuiDic = nil;
                [KKAlert showSuccessHint:@"房屋预定成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"数据提交失败"];
        }];
    } else if(s == 0) {
        [KKAlert showErrorHint:@"支付失败"];
    } else if (s == 2){
        [KKAlert showErrorHint:@"您取消了支付"];
    }
}
- (void)getPayInfo
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getOrderPayInfoWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            self.orderDic = dic[@"data"];
            [self.tableView reloadData];
            /*
             {
             "check_time" = "2018-01-28";
             city = "\U90d1\U5dde\U5e02";
             days = 2;
             district = "\U4e2d\U539f\U533a";
             "house_id" = 23;
             "house_img" = "/Uploads/Images/2018-01-11/5a5730966355e.png";
             "house_info" = "\U4fbf\U5b9c\U5b9e\U7528";
             "is_name" = 0;
             "leave_time" = "2018-01-28";
             mobile = "<null>";
             nickname = "\U53ef\U53ef";
             "order_id" = 15;
             province = "\U6cb3\U5357\U7701";
             title = "\U7edd\U5bf9\U597d\U623f";
             "total_price" = "160.00";
             town = "\U5efa\U8bbe\U8def\U8857\U9053";
             "user_id" = 50;
             };
             */
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectYouhuiQuan" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"aliPayResult" object:nil];
}
//立即支付
- (IBAction)payAtMoment:(id)sender {
    if (self.selIndexPath == nil) {
        [KKAlert showErrorHint:@"请选择支付方式"];
        return;
    }
    /*
    NSString * youhuiId = @"";
    if (self.youhuiDic) {
        youhuiId = self.youhuiDic[@"id"];
    }
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork paySuccessWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId,@"id":youhuiId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.youhuiDic = nil;
            [KKAlert showSuccessHint:@"房屋预定成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据提交失败"];
    }];
    return;
     */
    if (self.selIndexPath.row) {
        KKLog(@"微信支付");
        NSNumber * youhuiPrice = @0;
        if (self.youhuiDic) {
            NSString * youhui = self.youhuiDic[@"price"];
            youhuiPrice = [NSNumber numberWithFloat:youhui.floatValue];
            
        }
        [KKAlert showAnimateWithStauts:@"订单生成中"];
        [KKNetWork getWxpayOrderWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId,@"youhui_price":youhuiPrice} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSDictionary * data = dic[@"data"];
            if (data) {
                //需要创建这个支付对象
                PayReq *req   = [[PayReq alloc] init];
                //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                req.openID = data[@"appid"];
                
                // 商家id，在注册的时候给的
                req.partnerId = data[@"mch_id"];
                
                // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                req.prepayId  = data[@"prepay_id"];
                
                // 根据财付通文档填写的数据和签名
                //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                req.package  = @"Sign=WXPay";
                
                // 随机编码，为了防止重复的，在后台生成
                req.nonceStr  = data[@"nonce_str"];
                
                // 这个是时间戳，也是在后台生成的，为了验证支付的
                NSString * stamp = data[@"timestamp"];
                req.timeStamp = stamp.intValue;
                
                // 这个签名也是后台做的
                req.sign = data[@"sign"];
                
                //发送请求到微信，等待微信返回onResp
                [WXApi sendReq:req];
                
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"订单生成失败"];
        }];
        
    } else {
        [KKAlert showAnimateWithStauts:@"订单生成中"];
        NSNumber * youhuiPrice = @0;
        if (self.youhuiDic) {
            NSString * youhui = self.youhuiDic[@"price"];
           youhuiPrice = [NSNumber numberWithFloat:youhui.floatValue];
            
        }
        [KKNetWork getAlipayOrderWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId,@"youhui_price":youhuiPrice} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSDictionary * data = dic[@"data"];
            if (data[@"payinfo"]) {
                [[AlipaySDK defaultService] payOrder:data[@"payinfo"] fromScheme:@"com.minsu.minsu" callback:^(NSDictionary *resultDic) {
                    [self dealAliWithDic:resultDic];
                }];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"订单生成失败"];
        }];
        
    }
    /*
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork paySuccessWithParm:@{@"token":[UserDefaults token],@"order_id":self.orderId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"房屋预定成功"];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据提交失败"];
    }];
     */
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            PayTopTableViewCell * cell = [PayTopTableViewCell cellWithTableView:tableView indexPatch:indexPath];
            if (self.orderDic) {
                cell.titleLabel.text = self.orderDic[@"title"];
                cell.nameLabel.text = self.orderDic[@"nickname"];
                cell.desLabel.text = self.orderDic[@"house_info"];
                cell.intimeLabel.text = self.orderDic[@"check_time"];
                cell.outTimeLabel.text = self.orderDic[@"leave_time"];
                cell.dayLabel.text = [NSString stringWithFormat:@"共%@晚",self.orderDic[@"days"]];
                cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",self.orderDic[@"city"],self.orderDic[@"district"],self.orderDic[@"town"]];
                NSString * phone = self.orderDic[@"mobile"];
                if (phone && [phone isKindOfClass:[NSString class]]) {
                    NSMutableString * pStr = [NSMutableString stringWithString:phone];
                    [pStr replaceCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
                    cell.phoneLabel.text = pStr;
                } else {
                    cell.phoneLabel.text = @"";
                }
                NSString * imageUrl = self.orderDic[@"house_img"];
                if (imageUrl) {
                    [cell.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,imageUrl]] placeholderImage:nil];
                } else {
#warning 缺默认图片
                    cell.houseImageView.image = nil;
                }
            }
            return cell;
        }
            break;
         case 1:
        {
            static NSString * reuse = @"iden";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                cell.textLabel.textColor = [UIColor colorWithWhite:40/255.0 alpha:1];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            if (indexPath.row == 0) {
                if (self.youhuiDic) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.youhuiDic[@"price"]];
                } else {
                    cell.detailTextLabel.text  = @"";
                }
            }
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                if (self.orderDic) {
                    NSString * totalPice = self.orderDic[@"total_price"];
                    if (totalPice) {
                        CGFloat price  = totalPice.floatValue;
                        if (self.youhuiDic) {
                            NSString * yPrice = self.youhuiDic[@"price"];
                            price -= yPrice.floatValue;
                        }
                        
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.f",price];
                    } else {
                       cell.detailTextLabel.text = @"￥0";
                    }
                } else {
                    cell.detailTextLabel.text = @"￥0";
                }
                cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:150/255.0 blue:0 alpha:1];
            } else {
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            NSArray * arr = @[@"优惠券",@"合计"];
            cell.textLabel.text = arr[indexPath.row];
            return cell;
        }
        default:
        {
            PayBottomTableViewCell * cell = [PayBottomTableViewCell cellWithTableView:tableView indexPatch:indexPath];
            if (indexPath.row) {
                cell.textLabel.text = @"微信支付";
            } else {
                cell.textLabel.text = @"支付宝";
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorWithWhite:40/255.0 alpha:1];
            if (self.selIndexPath) {
                if (indexPath == self.selIndexPath) {
                    cell.cycleBtn.selected = YES;
                } else {
                    cell.cycleBtn.selected = NO;
                }
            }
            kkWeakSelf
            cell.selectBlock = ^{
                weakSelf.selIndexPath = indexPath;
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
            break;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return [WXApi isWXAppInstalled]?2:1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?44:180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        MyCouponTableViewController * vc = [MyCouponTableViewController new];
        vc.isUse = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
