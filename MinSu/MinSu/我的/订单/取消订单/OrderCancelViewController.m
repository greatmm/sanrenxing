//
//  OrderCancelViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/11.
//

#import "OrderCancelViewController.h"

@interface OrderCancelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款申请";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelOrder:(id)sender {
    NSLog(@"申请退款");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1?3:1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    return cell;
}

@end
