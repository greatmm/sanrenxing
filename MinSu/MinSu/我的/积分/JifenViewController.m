//
//  JifenViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "JifenViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AddressViewController.h"

@interface JifenViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)JSContext * context;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation JifenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(guanbi)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/faxian/jf_list/token/%@",baseUrl,[UserDefaults token]]]]];
}
- (void)guanbi
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadWebView
{
    [self.webView reload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView reload];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
        [weakSelf js_java];
    };
}
- (void)js_java
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AddressViewController * vc = [AddressViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
