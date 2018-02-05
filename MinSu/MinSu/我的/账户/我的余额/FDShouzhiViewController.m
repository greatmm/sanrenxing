//
//  FDShouzhiViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/24.
//

#import "FDShouzhiViewController.h"
#import "FDShouTableViewController.h"
#import "FDZhiTableViewController.h"
@interface FDShouzhiViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *underLineView;
@property (weak, nonatomic) IBOutlet UIButton *shouBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhiBtn;


@end

@implementation FDShouzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收支记录";
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    _scrollView.scrollsToTop = NO;
    FDShouTableViewController * shouVC = [FDShouTableViewController new];
    [self addChildViewController:shouVC];
    FDZhiTableViewController * zhiVC = [FDZhiTableViewController new];
    [self addChildViewController:zhiVC];
    [self addChildVcViewIntoScrollView:0];
}
- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    if (sender.tag) {
        self.zhiBtn.selected = YES;
        self.shouBtn.selected = NO;
    } else {
        self.zhiBtn.selected = NO;
        self.shouBtn.selected = YES;
    }
    NSUInteger index = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.underLineView.center;
        center.x = sender.center.x;
        self.underLineView.center = center;
        CGFloat offsetX = ScreenWidth * index;
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        [self addChildVcViewIntoScrollView:index];
    }];
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        scrollView.scrollsToTop = (i == index);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    UIButton * btn = index?self.zhiBtn:self.shouBtn;
    [self clickBtn:btn];
}
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    childVcView.frame = CGRectMake(index * ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.scrollView.bounds));
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
