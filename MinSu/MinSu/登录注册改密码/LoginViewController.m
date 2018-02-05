//
//  LoginViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/25.
//

#import "LoginViewController.h"
#import "UMSocialCore.h"
#import "KKTabBarController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (strong, nonatomic) UIButton *dtLoginBtn;
@property (strong, nonatomic)  UIButton *pwdLoginBtn;
@property (strong, nonatomic) UITextField *phoneTf;
@property (strong, nonatomic) UITextField *pwdTf;
@property (strong, nonatomic) UIButton * authCodeBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
       self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (isIphoneX) {
        self.topLayout.constant = 0;
        [self.view layoutIfNeeded];
    }
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)initUI
{
    UIImageView * imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"login_back"];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 487.0/750);
    [self.scrollView addSubview:imageView];
    
    self.dtLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dtLoginBtn.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), ScreenWidth * 0.5, 44);
    [self.dtLoginBtn setTitle:@"动态码登录" forState:UIControlStateNormal];
    self.dtLoginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.dtLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.dtLoginBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [self.dtLoginBtn setBackgroundImage:[KKTool imageWithColor:[UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1]] forState:UIControlStateSelected];
    self.dtLoginBtn.selected = YES;
    [self.dtLoginBtn setBackgroundImage:[KKTool imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.dtLoginBtn addTarget:self action:@selector(selectLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.dtLoginBtn];
    
    self.pwdLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pwdLoginBtn.frame = CGRectMake(ScreenWidth * 0.5, CGRectGetMaxY(imageView.frame), ScreenWidth * 0.5, 44);
    self.pwdLoginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.pwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    [self.pwdLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.pwdLoginBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [self.pwdLoginBtn setBackgroundImage:[KKTool imageWithColor:[UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1]] forState:UIControlStateSelected];
    [self.pwdLoginBtn setBackgroundImage:[KKTool imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.pwdLoginBtn addTarget:self action:@selector(selectLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.pwdLoginBtn];
    
    self.phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.pwdLoginBtn.frame) + 50, ScreenWidth - 40, 30)];
    self.phoneTf.font  = [UIFont systemFontOfSize:15];
    [self.phoneTf addLeftViewWithImagename:@"login_phone"];
    self.phoneTf.placeholder = @"请输入电话号码";
    self.phoneTf.delegate = self;
    self.phoneTf.textColor = k40Color;
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.phoneTf];
    
    UIView * line = [UIView new];
    line.frame = CGRectMake(15, CGRectGetMaxY(self.phoneTf.frame) + 10, ScreenWidth - 30, 0.5);
    line.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self.scrollView addSubview:line];
    
    self.pwdTf = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame) + 10, ScreenWidth - 40, 30)];
    self.pwdTf.font = [UIFont systemFontOfSize:15];
    self.pwdTf.textColor = k40Color;
    self.pwdTf.delegate = self;
    [self.pwdTf addLeftViewWithImagename:@"pwdlock"];
    self.pwdTf.placeholder = @"请输入验证码";
    self.pwdTf.secureTextEntry = NO;
    self.pwdTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:self.pwdTf];
    
    self.authCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.authCodeBtn.frame = CGRectMake(ScreenWidth -  120, CGRectGetMinY(self.pwdTf.frame), 100, 30);
    self.authCodeBtn.layer.cornerRadius = 4;
    self.authCodeBtn.layer.masksToBounds = YES;
    self.authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.authCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.authCodeBtn addTarget:self action:@selector(sendAuthCode) forControlEvents:UIControlEventTouchUpInside];
    self.authCodeBtn.backgroundColor = [UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1];
    [self.scrollView addSubview:self.authCodeBtn];
    
    UIView * line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    line1.frame = CGRectMake(15, CGRectGetMaxY(self.pwdTf.frame) + 10, ScreenWidth - 30, 0.5);
    [self.scrollView addSubview:line1];
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(18, CGRectGetMaxY(line1.frame) + 30, ScreenWidth - 36, 44);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 22;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = kTabbarColor;
    
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:loginBtn];
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(ScreenWidth * 0.5 - 30, CGRectGetMaxY(loginBtn.frame) + 20, 60, 20);
    [forgetBtn setTitleColor:[UIColor colorWithWhite:102/255.0 alpha:1] forState:UIControlStateNormal];
    [forgetBtn setTitleColor:k153Color forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [forgetBtn addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:forgetBtn];
    
    UIButton * qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(ScreenWidth * 0.5 - 115, CGRectGetMaxY(forgetBtn.frame) + 25, 50, 50);
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    qqBtn.tag = 0;
    [self.scrollView addSubview:qqBtn];
    
    UIButton * wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.frame = CGRectMake(ScreenWidth * 0.5 - 25, CGRectGetMaxY(forgetBtn.frame) + 25, 50, 50);
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    wechatBtn.tag = 1;
    [self.scrollView addSubview:wechatBtn];
    
    UIButton * weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(ScreenWidth * 0.5 + 65, CGRectGetMaxY(forgetBtn.frame) + 25, 50, 50);
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    weiboBtn.tag = 2;
    [weiboBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:weiboBtn];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(weiboBtn.frame) + 50);
}
- (void)selectLoginStyle:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self.view endEditing:YES];
    if (sender == self.dtLoginBtn) {
        self.pwdTf.text = @"";
        self.dtLoginBtn.selected = YES;
        self.pwdLoginBtn.selected = NO;
        self.authCodeBtn.hidden = NO;
        self.pwdTf.placeholder = @"请输入验证码";
        self.pwdTf.secureTextEntry = NO;
        self.pwdTf.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.pwdTf.text = @"";
        self.pwdLoginBtn.selected = YES;
        self.dtLoginBtn.selected = NO;
        self.authCodeBtn.hidden = YES;
        self.pwdTf.placeholder = @"请输入密码(6-16位)";
        self.pwdTf.secureTextEntry = YES;
        self.pwdTf.keyboardType = UIKeyboardTypeDefault;
    }
    
    /*
     {
     code = 200;
     data =     {
     number = 364248;
     };
     msg = "\U77ed\U4fe1\U5df2\U53d1\U9001\U5230\U60a8\U624b\U673a";
     }
     */
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
//发送验证码
- (void)sendAuthCode
{
    NSString * phoneNumber = self.phoneTf.text;
    if (![phoneNumber isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码格式不正确"];
        return;
    }
    [KKNetWork sendVerifyWithParm:@{@"phone":phoneNumber,@"type":@"1"} SuccessBlock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"验证码发送成功"];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert showErrorHint:@"验证码发送失败"];
    }];
    [KKTool downCount:self.authCodeBtn];
}
- (void)login:(id)sender {

    NSString * phoneStr = self.phoneTf.text;
    if (![phoneStr isPhoneNumber]) {
        [KKAlert showErrorHint:@"电话号码格式不正确"];
        return;
    }
    NSString * pwd = self.pwdTf.text;
    NSDictionary * dic = @{@"mobile":phoneStr,@"password":pwd};
    if (self.pwdLoginBtn.selected) {
        if (![pwd isPwd]) {
            [KKAlert showErrorHint:@"密码格式不正确"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"登录中..."];
        [KKNetWork loginWithParm:dic SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"登录成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
                });
                
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"登录失败"];
        }];
    } else {
        if (![pwd isAuthCode]) {
            [KKAlert showErrorHint:@"验证码格式不正确"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"登录中..."];
        [KKNetWork dynamicLoginWithParm:@{@"mobile":self.phoneTf.text,@"password":@"666666",@"verify":self.pwdTf.text} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 210) {
                [KKAlert showSuccessHint:@"登录成功,您的默认密码为666666"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
                });
            } else if(code.integerValue == 200){
                [KKAlert showSuccessHint:@"登录成功"];
                [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"登录失败"];
        }];
    }
    

    /*
     {
     code = 200;
     data =     {
     nickname = 17637500521;
     token = ba3d36e018a39edb5d927dff84ff0f86;
     };
     msg = "\U767b\U5f55\U6210\U529f";
     }
     */
}
- (void)forgetPwd:(id)sender {
    ForgetPwdViewController * forgetVC = [ForgetPwdViewController new];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)thirdLogin:(UIButton *)sender {
    NSLog(@"三方登录");
    switch (sender.tag) {
        case 0:
        {
            //qq
            [self qqLogin];
        }
            break;
        case 1:
        {
           //微信
            [self wechatLogin];
        }
            break;
        case 2:
        {
           //微博
            [self weiboLogin];
        }
            break;
        default:
            break;
    }
}
- (void)qqLogin
{
  [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
     if (error) {
         KKLog(@"%@",error);
     } else {
         UMSocialUserInfoResponse *resp = result;
         NSDictionary * parmDic = @{@"openid":resp.uid,@"nickname":resp.name,@"head_pic":resp.iconurl};
         [self loginWithParm:parmDic];
         // 授权信息
         NSLog(@"qq uid: %@", resp.uid);
         NSLog(@"qq accessToken: %@", resp.accessToken);
         NSLog(@"qq refreshToken: %@", resp.refreshToken);
         NSLog(@"qq expiration: %@", resp.expiration);
         
         // 用户信息
         NSLog(@"qq name: %@", resp.name);
         NSLog(@"qq iconurl: %@", resp.iconurl);
         NSLog(@"qq gender: %@", resp.unionGender);
         // 第三方平台SDK源数据
         NSLog(@"qq originalResponse: %@", resp.originalResponse);
         
     }
  }];
}
- (void)loginWithParm:(NSDictionary *)parmDic
{
    [KKAlert showAnimateWithStauts:@"登录中"];
    [KKNetWork thirdLoginWithParm:parmDic SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * data = dic[@"data"];
            NSString * token = data[@"token"];
            [UserDefaults saveToken:token];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"登录失败"];
    }];
}
- (void)weiboLogin
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            KKLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            NSDictionary * parmDic = @{@"openid":resp.uid,@"nickname":resp.name,@"head_pic":resp.iconurl};
            [self loginWithParm:parmDic];
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (void)wechatLogin
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            KKLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            NSDictionary * parmDic = @{@"openid":resp.uid,@"nickname":resp.name,@"head_pic":resp.iconurl};
            [self loginWithParm:parmDic];
            // 授权信息
            NSLog(@"wechat uid: %@", resp.uid);
            NSLog(@"wechat accessToken: %@", resp.accessToken);
            NSLog(@"wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"wechat name: %@", resp.name);
            NSLog(@"wechat iconurl: %@", resp.iconurl);
            NSLog(@"wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
