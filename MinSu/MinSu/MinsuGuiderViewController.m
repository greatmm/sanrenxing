//
//  MinsuGuiderViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/20.
//

#import "MinsuGuiderViewController.h"
#import "KKNavigationController.h"
#import "LoginViewController.h"

@interface MinsuGuiderViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation MinsuGuiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!isIphoneX) {
        self.top.constant = -20;
    }
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, CGRectGetHeight(_scrollView.bounds))];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_%d",i + 1] ofType:@"png"];
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:filePath];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.x > ScreenWidth * 2 + 20) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:guider_key];
        KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
