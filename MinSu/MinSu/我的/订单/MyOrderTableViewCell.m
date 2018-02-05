//
//  MyOrderTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import "MyOrderTableViewCell.h"
#import "HouseDetailViewController.h"
#import "PayViewController.h"
#import "RefundViewController.h"
#import "AddEvaluateViewController.h"

@interface MyOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//共几晚

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic,strong) void(^leftBlock)(void);

@property (nonatomic,strong) void(^rightBlock)(void);
@property (nonatomic,assign) NSInteger state;//订单状态 0待支付 -1 已取消 1待入住 2 入住中 3已退房
@end

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        [self assignWithDic:_dataDic];
    }
}
- (void)assignWithDic:(NSDictionary *)dic
{
    self.enterTimeLabel.text = dic[@"check_time"];
    self.leaveTimeLabel.text = dic[@"leave_time"];
    self.timeLabel.text = [NSString stringWithFormat:@"共%@晚",dic[@"days"]];
    self.titleLabel.text = dic[@"title"];
    self.desLabel.text = dic[@"house_info"];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"total_price"]];
    NSString * address = [NSString stringWithFormat:@"%@  %@  %@",dic[@"city"],dic[@"district"],dic[@"town"]];
    self.addressLabel.text = address;
    NSString * headPic = dic[@"head_pic"];
    if (headPic && [headPic isKindOfClass:[NSString class]]) {
        if ([headPic containsString:@"http"]) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        } else {
           [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,headPic]] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        }
    }
    self.userNameLabel.text = dic[@"h_name"];
    NSString * houseImg = dic[@"house_img"];
    if (houseImg && [houseImg isKindOfClass:[NSString class]]) {
        if ([houseImg containsString:@"http"]) {
            [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:houseImg] placeholderImage:[UIImage imageNamed:@"default_house"]];
        } else {
            [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,houseImg]] placeholderImage:[UIImage imageNamed:@"default_house"]];
        }
    }
    if ([UserDefaults isHouse]) {
        NSString * orderState = dic[@"order_status"];
        self.state = orderState.integerValue;
        return;
    }
    NSString * payState = dic[@"pay_status"];
    NSInteger isPay = payState.integerValue;
    if (isPay == 0) {
        self.state = 0;
    } else if (isPay == -1) {
        self.state = -1;
    } else if(isPay == 1)  {
        NSString * orderState = dic[@"order_status"];
        NSInteger state = orderState.integerValue;
        self.state = state + 1;
    }
    /*
     {
     "check_time" = "2018-01-27";
     city = "\U90d1\U5dde\U5e02";
     days = 2;
     district = "\U4e2d\U539f\U533a";
     "h_name" = "\U9ad8\U68a6\U53ef";
     "head_pic" = "/Uploads/Images/2018-01-10/5a558cc7c4408.png";
     "house_img" = "/Uploads/Images/2018-01-11/5a5730966355e.png";
     "house_info" = "\U4fbf\U5b9c\U5b9e\U7528";
     "leave_time" = "2018-01-27";
     "order_status" = 0;
     "pay_status" = 0;
     province = "\U6cb3\U5357\U7701";
     title = "\U7edd\U5bf9\U597d\U623f";
     "total_price" = "160.00";
     town = "\U5efa\U8bbe\U8def\U8857\U9053";
     "user_id" = 38;
     }
     */
}
- (IBAction)clickLeftBtn:(id)sender {
    if (self.leftBlock) {
        self.leftBlock();
    }
}
- (IBAction)clickRightBtn:(id)sender {
    if (self.rightBlock) {
        self.rightBlock();
    }
}
- (void)setState:(NSInteger)state
{
    _state = state;
    kkWeakSelf;
    
    if ([UserDefaults isHouse]) {
        //"订单状态0：待入住，1：入住中，2：已退房 ，3：已申请退款",4.提前退房
        switch (_state) {
            case 0:
            {
                self.stateLabel.text = @"待入住";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"确认入住" forState:UIControlStateNormal];
                self.rightBlock = ^{
                    [weakSelf fdEnsureEnter];
                };
            }
                break;
            case 1:
            {
                self.stateLabel.text = @"入住中";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                self.rightBtn.hidden = NO;
                self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"确认退房" forState:UIControlStateNormal];
                self.rightBlock = ^{
                    [weakSelf fdEnsureTuifang];
                };
            }
                break;
                case 2:
            {
                self.stateLabel.text = @"已退房";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
            }
                break;
                case 3:
            {
                NSString * isTuikuan = self.dataDic[@"is_tuikuan"];
                NSInteger tuikuan = isTuikuan.integerValue;
                if (tuikuan == 0) {
                    self.stateLabel.text = @"";
                    self.leftBtn.hidden = NO;
                    self.rightBtn.hidden = NO;
                    [self.leftBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
                    self.leftBtn.layer.borderColor = k153Color.CGColor;
                    [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
                    self.leftBlock = ^{
                        [weakSelf fdJujueTuikuan];
                    };
                    self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                    [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                    [self.rightBtn setTitle:@"同意退款" forState:UIControlStateNormal];
                    self.rightBlock = ^{
                        [weakSelf fdTongyiTuikuan];
                    };
                } else if (tuikuan == 1) {
                    self.stateLabel.text = @"退款成功";
                    self.leftBtn.hidden = YES;
                    self.rightBtn.hidden = YES;
                } else {
                    self.stateLabel.text = @"已拒绝退款";
                    self.leftBtn.hidden = YES;
                    self.rightBtn.hidden = YES;
                }
            }
                break;
                case 4:
            {
                NSString * isTuifang = self.dataDic[@"is_tuifang"];
                NSInteger tuifang = isTuifang.integerValue;
                if (tuifang == 0) {
                    self.leftBtn.hidden = NO;
                    self.rightBtn.hidden = NO;
                    self.stateLabel.text = @"";
                    [self.leftBtn setTitle:@"拒绝退房" forState:UIControlStateNormal];
                    self.leftBtn.layer.borderColor = k153Color.CGColor;
                    [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
                    self.leftBlock = ^{
                        [weakSelf fdJujueTuifang];
                    };
                    self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                    [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                    [self.rightBtn setTitle:@"同意退房" forState:UIControlStateNormal];
                    self.rightBlock = ^{
                        [weakSelf fdTongyiTuifang];
                    };
                } else if (tuifang == 1) {
                    self.stateLabel.text = @"退房成功";
                    self.leftBtn.hidden = YES;
                    self.rightBtn.hidden = YES;
                } else {
                    self.stateLabel.text = @"已拒绝退房";
                    self.leftBtn.hidden = YES;
                    self.rightBtn.hidden = YES;
                }
            }
                break;
            default:
                break;
        }
        return;
    }
#pragma mark  ---------------用户端-----------------
    switch (state) {
        case -1:
        {
            self.stateLabel.text = @"已取消";
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            [self.leftBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
            self.leftBlock = ^{
                [weakSelf showDeleteView];
            };
            self.leftBtn.layer.borderColor = k153Color.CGColor;
            self.rightBtn.layer.borderColor = kYellowColor.CGColor;
            [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"再次预定" forState:UIControlStateNormal];
            self.rightBlock = ^{
                [weakSelf checkInHouse];
            };
        }
            break;
         case 0:
        {
            self.stateLabel.text = @"待支付";
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;

            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
            self.leftBlock = ^{
                [weakSelf showCancelView];
            };
            self.leftBtn.layer.borderColor = k153Color.CGColor;
            self.rightBtn.layer.borderColor = kYellowColor.CGColor;
            [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            self.rightBlock = ^{
                [weakSelf payOrder];
            };
        }
            break;
        case 1:
        {
            self.stateLabel.text = @"待入住";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;

            self.rightBtn.layer.borderColor = kYellowColor.CGColor;
            [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            self.rightBlock = ^{
                [weakSelf applyBackMoney];
            };
        }
            break;
        case 2:
        {
            self.stateLabel.text = @"入住中";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;

            self.rightBtn.layer.borderColor = kYellowColor.CGColor;
            [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"提前退房" forState:UIControlStateNormal];
            self.rightBlock = ^{
                [weakSelf quitHouse];
            };
        }
            break;
         case 3:
        {
            self.stateLabel.text = @"已退房";
            self.leftBtn.hidden = NO;
            self.rightBtn.hidden = NO;

            [self.leftBtn setTitle:@"评价" forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
            self.leftBlock = ^{
                [weakSelf appraiseHouse];
            };
            self.leftBtn.layer.borderColor = k153Color.CGColor;
            self.rightBtn.layer.borderColor = kYellowColor.CGColor;
            [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"再次预定" forState:UIControlStateNormal];
            self.rightBlock = ^{
                [weakSelf checkInHouse];
            };
        }
            break;
            case 4:
        {
            //已退款
            NSString * key = self.dataDic[@"is_tuikuan"];
            NSInteger s = key.integerValue;
            NSString * status = @"";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            if (s == -1) {
                status = @"已拒绝退款";
            } else if (s == 0) {
                status = @"退款审核中";
            } else if (s == 1){
                status = @"退款成功";
                self.leftBtn.hidden = NO;
                self.rightBtn.hidden = NO;
                [self.leftBtn setTitle:@"评价" forState:UIControlStateNormal];
                [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
                self.leftBlock = ^{
                    [weakSelf appraiseHouse];
                };
                self.leftBtn.layer.borderColor = k153Color.CGColor;
                self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"再次预定" forState:UIControlStateNormal];
                self.rightBlock = ^{
                    [weakSelf checkInHouse];
                };
            }
            self.stateLabel.text = status;
        }
            break;
        default:
        {
           //提前退房
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            NSString * key = self.dataDic[@"is_tuifang"];
            NSInteger s = key.integerValue;
            NSString * status = @"";
            if (s == -1) {
                status = @"已拒绝提前退房";
            } else if (s == 0) {
                status = @"退房审核中";
            } else if (s == 1){
                status = @"退房成功";
                self.leftBtn.hidden = NO;
                self.rightBtn.hidden = NO;
                [self.leftBtn setTitle:@"评价" forState:UIControlStateNormal];
                [self.leftBtn setTitleColor:k153Color forState:UIControlStateNormal];
                self.leftBlock = ^{
                    [weakSelf appraiseHouse];
                };
                self.leftBtn.layer.borderColor = k153Color.CGColor;
                self.rightBtn.layer.borderColor = kYellowColor.CGColor;
                [self.rightBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
                [self.rightBtn setTitle:@"再次预定" forState:UIControlStateNormal];
                self.rightBlock = ^{
                    [weakSelf checkInHouse];
                };
            }
            self.stateLabel.text = status;
        }
            break;
    }
}
- (void)fdEnsureTuifang
{
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork fdEnsureTuifangWithParm:@{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"数据提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"提交数据失败"];
    }];
}
- (void)fdTongyiTuikuan
{
    NSDictionary * parm = @{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"],@"is_tuikuan":@"1"};
    [self fdTuikuanWithParm:parm];
}
- (void)fdJujueTuikuan
{
    NSDictionary * parm = @{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"],@"is_tuikuan":@"-1"};
    [self fdTuikuanWithParm:parm];

}
- (void)fdTuikuanWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork fdAgreeTuikuanWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"数据提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"提交数据失败"];
    }];
}
- (void)fdTongyiTuifang
{
    NSDictionary * parm = @{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"],@"is_tuifang":@"1"};
    [self fdTuifangWithParm:parm];
}
- (void)fdJujueTuifang
{
   NSDictionary * parm = @{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"],@"is_tuifang":@"-1"};
  [self fdTuifangWithParm:parm];
}
- (void)fdTuifangWithParm:(NSDictionary *)parm
{
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork fdAgreeTuifangWithParm:parm SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"数据提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"提交数据失败"];
    }];
}
- (void)fdEnsureEnter
{
    [KKAlert showAnimateWithStauts:@"数据提交中"];
    [KKNetWork fdEnsureRuzhuWithParm:@{@"token":[UserDefaults token],@"order_id":self.dataDic[@"order_id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"数据提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"提交数据失败"];
    }];
}


- (void)showCancelView
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"确认取消此订单?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self cancelOrder];
    }];
    
    NSMutableAttributedString *ensureStr = [[NSMutableAttributedString alloc] initWithString:@"确认取消此订单?"];
    [ensureStr addAttribute:NSForegroundColorAttributeName value:k102Color range:NSMakeRange(0, ensureStr.length)];
    [alertVC setValue:ensureStr forKey:@"attributedTitle"];
    [ensureAction setValue:kYellowColor forKey:@"titleTextColor"];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:k102Color forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:ensureAction];
    UIViewController * vc = [self viewController];
    [vc presentViewController:alertVC animated:YES completion:nil];
}
//取消订单
- (void)cancelOrder
{
    [KKAlert showAnimateWithStauts:@"订单取消中"];
    NSString * orderId = _dataDic[@"order_id"];
    [KKNetWork cancelOrderWithParm:@{@"token":[UserDefaults token],@"order_id":orderId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"订单已取消"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"取消订单失败"];
    }];
}
//立即支付
- (void)payOrder
{
    PayViewController * payVC = [PayViewController new];
    payVC.orderId = self.dataDic[@"order_id"];
    UIViewController * controller = [self viewController];
    [controller.navigationController pushViewController:payVC animated:YES];
}
//申请退款
- (void)applyBackMoney
{
    RefundViewController * refundVC = [RefundViewController new];
    refundVC.orderId = self.dataDic[@"order_id"];
    UIViewController * controller = [self viewController];
    [controller.navigationController pushViewController:refundVC animated:YES];
}
//提前退房
- (void)quitHouse
{
    RefundViewController * refundVC = [RefundViewController new];
    refundVC.isTuifang = YES;
    refundVC.orderId = self.dataDic[@"order_id"];
    UIViewController * controller = [self viewController];
    [controller.navigationController pushViewController:refundVC animated:YES];
}
//评价
- (void)appraiseHouse
{
    AddEvaluateViewController * vc = [AddEvaluateViewController new];
    vc.hosue_id = self.dataDic[@"house_id"];
    UIViewController * controller = [self viewController];
    [controller.navigationController pushViewController:vc animated:YES];
}
//再次预定
- (void)checkInHouse
{
    HouseDetailViewController * vc = [HouseDetailViewController new];
    vc.house_id = self.dataDic[@"house_id"];
    UIViewController * controller = [self viewController];
    [controller.navigationController pushViewController:vc animated:YES];
}
- (void)showDeleteView
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"确认删除此订单?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteOrder];
    }];
    
    NSMutableAttributedString *ensureStr = [[NSMutableAttributedString alloc] initWithString:@"确认删除此订单?"];
    [ensureStr addAttribute:NSForegroundColorAttributeName value:k102Color range:NSMakeRange(0, ensureStr.length)];
    [alertVC setValue:ensureStr forKey:@"attributedTitle"];
    [ensureAction setValue:kYellowColor forKey:@"titleTextColor"];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:k102Color forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:ensureAction];
    UIViewController * vc = [self viewController];
    [vc presentViewController:alertVC animated:YES completion:nil];
}
//删除
- (void)deleteOrder
{
    [KKAlert showAnimateWithStauts:@"订单删除中..."];
    NSString * orderId = _dataDic[@"order_id"];
    [KKNetWork deleteOrderWithParm:@{@"token":[UserDefaults token],@"order_id":orderId} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"订单已删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChanged" object:nil];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"删除订单失败"];
    }];
}
@end
