//
//  KKNavigationController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKNavigationController.h"
#import "UIBarButtonItem+KKCategory.h"

@interface KKNavigationController ()

@end

@implementation KKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置返回按钮,只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//        [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back"] highImage:[UIImage imageNamed:@"back"]  target:self action:@selector(back) title:@"返回"];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
