//
//  OrderViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import "OrderViewController.h"

@interface OrderViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *btnsView;//存放button

@property (strong,nonatomic)UIView * titleUnderline;//小短线

@property (strong,nonatomic)UIButton * preBtn;//选中的button
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSArray * btnArr;
@property(nonatomic,strong) NSArray * dataArr;//总数据
@property(nonatomic,strong) NSMutableArray * subDataArr;//分类数组
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    CGRect sFrame = self.scrollView.frame;
    sFrame.size.width = ScreenWidth;
    self.scrollView.frame = sFrame;
    self.subDataArr = [NSMutableArray new];
    self.navigationItem.title = @"我的订单";
    [self createBtns];
    [self addChilds];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"orderChanged" object:nil];
}
- (void)getData
{
    if ([UserDefaults isHouse]) {
        [self getFdOrderList];
    } else {
        [self getOrderList];
    };
}
//获取房东端订单列表
- (void)getFdOrderList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getHouseOrderListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.dataArr = dic[@"data"];
            [self dealFdData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
//处理房东订单
- (void)dealFdData
{
    for (NSMutableArray * arr in self.subDataArr) {
        [arr removeAllObjects];
    }
    for (NSDictionary * dic in self.dataArr) {
            NSString * orderState = dic[@"order_status"];
            NSInteger state = orderState.integerValue;
            switch (state) {
                case 0:
                {
                    //待入住
                    NSMutableArray * orderArr = self.subDataArr[1];
                    [orderArr addObject:dic];
                }
                    break;
                case 1:
                {
                    //入住中
                    NSMutableArray * orderArr = self.subDataArr[2];
                    [orderArr addObject:dic];
                }
                    break;
                case 2:
                {
                    //已退房
                    NSMutableArray * orderArr = self.subDataArr[5];
                    [orderArr addObject:dic];
                }
                    break;
                case 3:
                {
                    //已退款
                    NSMutableArray * orderArr = self.subDataArr[3];
                    [orderArr addObject:dic];
                }
                    break;
                case 4:
                {
                    //提前退房
                    NSMutableArray * orderArr = self.subDataArr[4];
                    [orderArr addObject:dic];
                }
                    break;
                default:
                    break;
            }
    }
    NSArray * childArr = self.childViewControllers;
    NSInteger count = childArr.count;
    for (int i = 1; i < count; i ++) {
        UIViewController * vc = childArr[i];
        [vc setValue:self.subDataArr[i] forKey:@"orderArr"];
    }
    [self.childViewControllers.firstObject setValue:self.dataArr forKey:@"orderArr"];
}
//获取用户端订单
- (void)getOrderList
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getOrderListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            self.dataArr = dic[@"data"];
            [self dealData];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
//对用户订单数据进行分类
- (void)dealData
{
    for (NSMutableArray * arr in self.subDataArr) {
        [arr removeAllObjects];
    }
    for (NSDictionary * dic in self.dataArr) {
        NSString * payState = dic[@"pay_status"];
        NSInteger isPay = payState.integerValue;
        if (isPay == 0) {
            //待支付
            
        } else if (isPay == -1) {
            //已取消
            NSMutableArray * orderArr = self.subDataArr[4];
            [orderArr addObject:dic];
            
        } else if(isPay == 1)  {
            NSString * orderState = dic[@"order_status"];
            NSInteger state = orderState.integerValue;
            switch (state) {
                case 0:
                {
                  //待入住
                    NSMutableArray * orderArr = self.subDataArr[1];
                    [orderArr addObject:dic];
                }
                    break;
                case 1:
                {
                   //入住中
                    NSMutableArray * orderArr = self.subDataArr[2];
                    [orderArr addObject:dic];
                }
                    break;
                    case 2:
                {
                    //已退房
                    NSMutableArray * orderArr = self.subDataArr[3];
                    [orderArr addObject:dic];
                }
                    break;
                    case 3:
                {
                    //已退款
                    
                }
                    break;
                    case 4:
                {
                   //提前退房
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
    NSArray * childArr = self.childViewControllers;
    NSInteger count = childArr.count;
    for (int i = 1; i < count; i ++) {
        UIViewController * vc = childArr[i];
        [vc setValue:self.subDataArr[i] forKey:@"orderArr"];
    }
    [self.childViewControllers.firstObject setValue:self.dataArr forKey:@"orderArr"];
}

//添加子控制器
- (void)addChilds
{
    NSArray * arr;
    if ([UserDefaults isHouse]) {
        arr = @[@"HouseAllOrderTableViewController",@"HouseCheckInTableViewController",@"HouseLivingTableViewController",@"HouseTuikuanTableViewController",@"HouseTiqianTuifangTableViewController",@"HouseYituifangTableViewController"];
    } else {
        arr = @[@"OrderlistTableViewController",@"WaitToCheckInTableViewController",@"CheckInTableViewController",@"QuitedOrderTableViewController",@"CanceledOrderTableViewController"];
    }
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * arr.count, 0);
    for (NSString * str in arr) {
        Class class = NSClassFromString(str);
        [self addChildViewController:[class new]];
        NSMutableArray * arr = [NSMutableArray new];
        [self.subDataArr addObject:arr];
    }
    [self addChildVcViewIntoScrollView:0];
}
- (void)createBtns
{
    NSArray * titleArr;
    if ([UserDefaults isHouse]) {
       titleArr = @[@"全部",@"待入住",@"入住中",@"申请退款",@"提前退房",@"已退房"];
    } else {
       titleArr = @[@"全部",@"待入住",@"入住中",@"已退房",@"已取消"];
    }
    NSInteger count = titleArr.count;
    CGFloat width = ScreenWidth/count;
    NSMutableArray * btnArr = [NSMutableArray new];
    for (int i = 0; i < count; i ++) {
        CGRect frame = CGRectMake(width * i, 0, width, 35);
        UIButton * btn = [self btnWithTitle:titleArr[i] frame:frame];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnsView addSubview:btn];
        [btnArr addObject:btn];
    }
    self.btnArr = btnArr;
    _titleUnderline = [UIView new];
    _titleUnderline.backgroundColor = kTabbarColor;
    _titleUnderline.frame = CGRectMake(width * 0.5 - 15, 33, 30, 2);
    [self.btnsView addSubview:_titleUnderline];
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
//        [self addChildVcViewIntoScrollView:index];
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
    NSUInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i ++) {
        UIViewController *childVc = self.childViewControllers[i];
        UIView *childVcView = childVc.view;
        // 设置子控制器view的frame
        childVcView.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.scrollView.bounds));
        // 添加子控制器的view到scrollView中
        [self.scrollView addSubview:childVcView];
    }
    /*
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    childVcView.frame = CGRectMake(index * ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.scrollView.bounds));
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
     */
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    UIButton * btn = self.btnArr[index];
    [self clickTopBtn:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderChanged" object:nil];
}
@end
