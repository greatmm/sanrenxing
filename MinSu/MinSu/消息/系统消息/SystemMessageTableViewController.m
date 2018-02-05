//
//  SystemMessageTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "SystemMessageTableViewController.h"
#import "SystemMessageTableViewCell.h"
#import <SafariServices/SafariServices.h>
@interface SystemMessageTableViewController ()
@property (nonatomic,strong) NSArray * dataArr;
@end

@implementation SystemMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getSystemMsg];
}
- (void)getSystemMsg
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getSystemMsgWithParm:nil SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * number = dic[@"code"];
        if (number.integerValue == 200) {
            self.dataArr = dic[@"data"];
            [self.tableView reloadData];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMessageTableViewCell * cell = [SystemMessageTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.dataArr[indexPath.row];
    cell.timeLabel.text = dic[@"add_time"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,dic[@"xx_img"]]] placeholderImage:nil];
    cell.contentLabel.text = dic[@"content"];
    /*
     {
     "add_time" = "11:36";
     content = "\U4e70\U4e00\U9001\U4e8c\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566\U5566";
     "link_url" = "abc.com";
     title = "\U4eca\U65e5\U70ed\U95e8\U63a8\U8350";
     "xx_img" = "/Public/upload/xx/2017/12-21/5a3b319d7b66c.jpg";
     },
     {
     "add_time" = "08:00";
     content = "\U5929\U6c14\U771f\U597d\Uff0c\U98ce\U548c\U65e5\U4e3d\Uff0c\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8\U54c8";
     "link_url" = "abc.com";
     title = "\U5929\U6c14\U771f\U597d";
     "xx_img" = "/Public/upload/xx/2017/12-21/5a3b31857975f.jpg";
     }
     */
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArr[indexPath.row];
    NSString * content = dic[@"content"];
    CGFloat h = [content getHeightWithWidth:ScreenWidth - 20 fontSize:12];
    return 145 + (ScreenWidth - 50) * 0.4 + h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArr[indexPath.row];
    NSString * url = dic[@"link_url"];
    if ([url isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([url containsString:@"http"]) {
        SFSafariViewController * sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.navigationController presentViewController:sfVC animated:YES completion:nil];
    } else {
        NSString * aUrl = [NSString stringWithFormat:@"http://%@",url];
        SFSafariViewController * sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:aUrl]];
        [self.navigationController presentViewController:sfVC animated:YES completion:nil];
    }
}
@end
