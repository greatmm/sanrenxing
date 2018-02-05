//
//  KKChatViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/23.
//

#import "KKChatViewController.h"

@interface KKChatViewController ()

@end

@implementation KKChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [[RCIM sharedRCIM] disconnect];
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
