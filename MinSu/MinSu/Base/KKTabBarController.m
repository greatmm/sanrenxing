//
//  KKTabBarController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKTabBarController.h"
#import "KKNavigationController.h"
#import "KKTabBar.h"
#import "UIImage+KKCategory.h"
#import "HomePageViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "OrderViewController.h"

@interface KKTabBarController ()

@end

@implementation KKTabBarController

+ (void)load
{
    // 获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:62/255.0 green:90/255.0 blue:102/255.0 alpha:1.0]} forState:UIControlStateSelected];
}
- (void)setupTabBar
{
    KKTabBar *tabBar = [[KKTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}
//添加子控制器
- (void)setupAllChildViewController
{
    UIViewController * firstVC;
    if ([UserDefaults isHouse]) {
        OrderViewController * orderVC = [[OrderViewController alloc] init];
        firstVC = orderVC;
    } else {
        HomePageViewController * homeVC = [[HomePageViewController alloc] init];
        firstVC = homeVC;
    }
    
    KKNavigationController * homeNav = [[KKNavigationController alloc] initWithRootViewController:firstVC];
    [self addChildViewController:homeNav];
    
    DiscoverViewController * disVC = [[DiscoverViewController alloc] init];
    KKNavigationController * disNav = [[KKNavigationController alloc] initWithRootViewController:disVC];
    [self addChildViewController:disNav];
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    KKNavigationController * messageNav = [[KKNavigationController alloc] initWithRootViewController:messageVC];
    [self addChildViewController:messageNav];
    
    MineViewController * mineVC = [[MineViewController alloc] init];
    KKNavigationController * mineNav = [[KKNavigationController alloc] initWithRootViewController:mineVC];
    [self addChildViewController:mineNav];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewController];
    [self setupAllTitle];
    [self setupTabBar];
}
- (void)setupAllTitle
{
    UINavigationController *nav = self.childViewControllers[0];
    if ([UserDefaults isHouse]) {
        nav.tabBarItem.title = @"订单";
        nav.tabBarItem.image = [UIImage imageNamed:@"dingdan"];
        nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"dingdan_sel"];
    } else {
        nav.tabBarItem.title = @"首页";
        nav.tabBarItem.image = [UIImage imageNamed:@"homepage"];
        nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"homepage_sel"];
    }
    
    
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"发现";
    nav1.tabBarItem.image = [UIImage imageNamed:@"discover"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"discover_sel"];
    
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"消息";
    nav2.tabBarItem.image = [UIImage imageNamed:@"message"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"message_sel"];
    
    UINavigationController *nav3 = self.childViewControllers[3];
    nav3.tabBarItem.title = @"我的";
    nav3.tabBarItem.image = [UIImage imageNamed:@"mine"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"mine_sel"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    NSInteger index = [tabBar.items indexOfObject:item];
//    NSString * imageName = [NSString stringWithFormat:@"tabbar_back_%ld",index];
//    [tabBar setBackgroundImage:[UIImage imageNamed:imageName]];
}
@end
