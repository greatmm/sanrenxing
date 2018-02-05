//
//  SignInViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import "SignInViewController.h"
#import "KKCalendarView.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *calendarContentView;

@property (nonatomic,strong) KKCalendarView * calendarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHightCon;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";

    //日历
    self.calendarView = [KKCalendarView shareCalendarView];
    self.calendarView.frame = self.calendarContentView.frame;
    [self.calendarContentView removeFromSuperview];
    self.calendarContentView = nil;
    self.calendarView.date = [NSDate date];
    [self.scrollView addSubview:self.calendarView];
    self.contentHightCon.constant = CGRectGetMaxY(self.calendarView.frame);
    [self.scrollView layoutIfNeeded];
    [self getSignIninfo];
}
//获取签到信息
- (void)getSignIninfo
{
    NSString * token = [UserDefaults token];
    if (nil == token) {
        return;
    }
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getSignInInfoWithParm:@{@"token":token} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        [self refreshUIWithDic:dic];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)refreshUIWithDic:(NSDictionary *)dic
{
    NSArray * arr = dic[@"data1"];
    if (arr.count) {
        self.calendarView.signInDateArr = arr;
    }
    NSString * jifenStr = dic[@"data2"];
    if (jifenStr == nil || [jifenStr isKindOfClass:[NSNull class]]) {
        jifenStr = @"0";
    }
    self.jifenLabel.text = [NSString stringWithFormat:@"%ld积分",jifenStr.integerValue];
}
- (IBAction)clickSignInbtn:(id)sender {
    NSString * token = [UserDefaults token];
    if (nil == token) {
        return;
    }
    [KKAlert showAnimateWithStauts:@"签到中"];
    [KKNetWork signInWithParm:@{@"token":token} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSString * code = dic[@"code"];
        NSString * msg = dic[@"msg"];
        if (code.integerValue == 200) {
            [self getSignIninfo];
        } else {
            [KKAlert showErrorHint:msg];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"签到失败"];
    }];
}

@end
