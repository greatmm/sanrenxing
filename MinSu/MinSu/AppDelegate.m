//
//  AppDelegate.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import "AppDelegate.h"
#import "KKTabBarController.h"
#import "MinsuGuiderViewController.h"
#import "UMSocialCore.h"
#import "RongIMKit.h"
#import "KKNavigationController.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

//#import "RongIMLib.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [self showGuider];
    [self setUM];
    [self setRongClound];
    [WXApi registerApp:@"wxa372aef05ce3769b"];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayResult" object:nil userInfo:@{@"aliResult":resultDic}];;
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

//注册融云
- (void)setRongClound
{
    [[RCIM sharedRCIM] initWithAppKey:rcAppKey];
}
//注册友盟
- (void)setUM
{
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa372aef05ce3769b" appSecret:@"67e84a335b5fe291ba2bebef2aa0efec" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101456656" appSecret:@"ab99ee682c7e1fdec4b1d9850819c8e7" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3729388083"  appSecret:@"830346c946e542d1849d2951cc43ab22" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        
    }
    return result;
}
- (void)showGuider
{
    BOOL hasShowGuider = [[NSUserDefaults  standardUserDefaults] boolForKey:guider_key];
    
    if (hasShowGuider) {
        if ([UserDefaults token]) {
            self.window.rootViewController = [[KKTabBarController alloc] init];

        } else {
            KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:[LoginViewController new]];
            self.window.rootViewController = nav;
        }
    } else {
        self.window.rootViewController = [MinsuGuiderViewController new];
    }
}
- (void)onResp:(BaseResp *)resp
{
//    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
//
//    NSString * errStr  = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
//    NSLog(@"errStr: %@",errStr);
    
    
//    NSString * strTitle;
//    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        
//        strTitle = [NSString stringWithFormat:@"支付结果"];
        NSNumber * result;//0表示支付失败,1支付成功,2取消了支付
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                result = @1;
//                strMsg = @"支付结果:";
                NSLog(@"支付成功: %d",resp.errCode);
//                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                result = @2;
//                strMsg = @"用户取消了支付";
                NSLog(@"用户取消支付: %d",resp.errCode);
//                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                result = @0;
//                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
//                wxPayResult = @"faile";
                break;
            }
        }
        
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wxPayResult" object:nil userInfo:@{@"state":result}];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
