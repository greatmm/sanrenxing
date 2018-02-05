//
//  AboutUsViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/26.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self getUsInfo];
}
- (void)getUsInfo
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getAboutUsWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSString * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            NSDictionary * data = dic[@"data"];
            NSString * content = data[@"content"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentLabel.text = content;
            });
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"数据获取失败"];
    }];
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
