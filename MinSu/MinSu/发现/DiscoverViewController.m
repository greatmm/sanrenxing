//
//  DiscoverViewController.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "DiscoverViewController.h"
#import "AddArticleViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface DiscoverViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)JSContext * context;

//@property(nonatomic,strong) UIView * titleUnderline;
//@property(nonatomic,strong) UIButton * preBtn;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithName:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/faxian/fx_html/token/%@",baseUrl,[UserDefaults token]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWeb) name:@"addPublish" object:nil];
}
- (void)reloadWeb
{
    [self.webView reload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    kkWeakSelf
    self.context[@"js_java"] =
    ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf add];
        });
    };
}
- (void)add
{
    AddArticleViewController * addVC = [AddArticleViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addPublish" object:nil];
}
/*
- (void)createTitleView
{
    UIView * titleView = [UIView new];
    
    titleView.frame = CGRectMake(ScreenWidth/2 - 117, self.navigationController.navigationBar.frame.size.height - 44, 234, 44);
    CGRect frame1 =  CGRectMake(CGRectGetWidth(titleView.frame)/2 - 16, 7, 35, 30);
    UIButton * btn1 = [self btnWithTitle:@"游记" frame:frame1];
    [titleView addSubview:btn1];
    CGRect frame = CGRectMake(frame1.origin.x - 99, 7, 35, 30);
    UIButton * btn = [self btnWithTitle:@"发现" frame:frame];
    btn.selected = YES;
    [titleView addSubview:btn];
    CGRect frame2 = CGRectMake(CGRectGetMaxX(frame1) + 64, 7, 35, 30);
    UIButton * btn2 = [self btnWithTitle:@"攻略" frame:frame2];
    [titleView addSubview:btn2];
    _titleUnderline = [UIView new];
    _titleUnderline.backgroundColor = kTabbarColor;
    _titleUnderline.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 10,41,20,3);
    [titleView addSubview:_titleUnderline];
    self.navigationItem.titleView = titleView;
}
- (void)clickTopBtn:(UIButton *)btn
{
    if (btn == self.preBtn) {
        return;
    }
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.titleUnderline.center;
        center.x = btn.center.x;
        self.titleUnderline.center = center;
    } completion:^(BOOL finished) {
        
    }];
}
- (UIButton *)btnWithTitle:(NSString *)title frame:(CGRect)frame
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:k153Color forState:UIControlStateNormal];
    [btn setTitleColor:kTabbarColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
