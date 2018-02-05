//
//  MessageViewController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemMessageTableViewController.h"
#import "OrderHintTableViewController.h"
#import "ChatRecordTableViewController.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)UIView *titleUnderline;
@property(nonatomic,strong)UIButton * preBtn;
@property(nonatomic,strong) NSArray * btnArr;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTitleView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _scrollView.scrollsToTop = NO;
    OrderHintTableViewController * orderVC = [OrderHintTableViewController new];
    [self addChildViewController:orderVC];
    ChatRecordTableViewController * chatVC = [ChatRecordTableViewController new];
    [self addChildViewController:chatVC];
    SystemMessageTableViewController * sysVC = [SystemMessageTableViewController new];
    [self addChildViewController:sysVC];
    
    [self addChildVcViewIntoScrollView:0];
}
- (void)createTitleView
{
    UIView * titleView = [UIView new];
    CGFloat width = ScreenWidth/3.0;
    titleView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 44, ScreenWidth, 44);
    CGRect frame1 =  CGRectMake(CGRectGetWidth(titleView.frame)/2 - 35, 7, 70, 30);
    UIButton * btn1 = [self btnWithTitle:@"聊天记录" frame:frame1];
    btn1.tag = 1;
    [titleView addSubview:btn1];
    CGRect frame = CGRectMake(width * 0.5 - 35, 7, 70, 30);
    UIButton * btn = [self btnWithTitle:@"订单提示" frame:frame];
    btn.selected = YES;
    btn.tag = 0;
    [titleView addSubview:btn];
    self.preBtn = btn;
    CGRect frame2 = CGRectMake(width * 2 + width *0.5 - 35, 7, 70, 30);
    UIButton * btn2 = [self btnWithTitle:@"系统消息" frame:frame2];
    btn2.tag = 2;
    [titleView addSubview:btn2];
    _titleUnderline = [UIView new];
    _titleUnderline.backgroundColor = kTabbarColor;
    _titleUnderline.frame = CGRectMake(frame.origin.x + frame.size.width/2 - 10,41,20,3);
    [titleView addSubview:_titleUnderline];
    self.navigationItem.titleView = titleView;
    self.btnArr = @[btn,btn1,btn2];
}
- (void)clickTopBtn:(UIButton *)btn
{
    if (btn == self.preBtn) {
        return;
    }
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
    NSUInteger index = btn.tag;
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center = self.titleUnderline.center;
        center.x = btn.center.x;
        self.titleUnderline.center = center;
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
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    childVcView.frame = CGRectMake(index * ScreenWidth, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    UIButton * btn = self.btnArr[index];
    [self clickTopBtn:btn];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
