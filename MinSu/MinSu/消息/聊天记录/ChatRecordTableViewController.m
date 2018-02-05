//
//  ChatRecordTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "ChatRecordTableViewController.h"
#import "ChatRecordTableViewCell.h"
#import "RCIM.h"
#import "KKChatViewController.h"

@interface ChatRecordTableViewController ()<RCIMUserInfoDataSource>
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) NSDictionary * selDic;
@property (nonatomic,strong) NSDictionary * data1;
@property (nonatomic,strong) NSDictionary * data2;
@end

@implementation ChatRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addChat" object:nil];
    [self getData];
}
- (void)refreshData
{
    [KKNetWork getChatListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * arr = dic[@"data"];
            self.dataArr = arr;
            [self.tableView reloadData];
        }
    } erreorBlock:^(NSError *error) {
        
    }];
}
- (void)getData
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getChatListWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            NSArray * arr = dic[@"data"];
            self.dataArr = arr;
            [self.tableView reloadData];
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRecordTableViewCell * cell = [ChatRecordTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    [cell assignWithDic:self.dataArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selDic = self.dataArr[indexPath.row];
    [self getRCToken];
}
- (void)getRCToken
{
    [KKAlert showAnimateWithStauts:@"服务器连接中"];
    [KKNetWork getRTokenWithParm:@{@"token":[UserDefaults token],@"id":_selDic[@"id"]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * data1 = dic[@"data1"];
            NSString * rToken = data1[@"token"];
            NSDictionary * data2 = dic[@"data2"];
            NSString * targetId = [NSString stringWithFormat:@"%@",data2[@"userId"]];
            self.data1 = data1;
            self.data2 = data2;
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            [[RCIM sharedRCIM] connectWithToken:rToken success:^(NSString *userId) {
                [KKAlert dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    KKChatViewController *conversationVC = [[KKChatViewController alloc]init];
                    conversationVC.conversationType =ConversationType_PRIVATE;
                    conversationVC.targetId  = targetId;
                    conversationVC.title = data2[@"nickname"];
                    [self.navigationController pushViewController:conversationVC animated:YES];
                });
            } error:^(RCConnectErrorCode status) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"连接服务器失败"];
            } tokenIncorrect:^{
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"连接服务器失败"];
            }];
        } else {
            [KKAlert dismiss];
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"连接服务器失败"];
    }];
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    if (self.data1) {
        NSString * iden = [NSString stringWithFormat:@"%@",self.data1[@"userId"]];
        if ([iden isEqualToString:userId]) {
            NSString * headUrl = self.data1[@"head_pic"];
            if (headUrl && [headUrl isKindOfClass:[NSString class]]) {
                if (![headUrl containsString:@"http"]) {
                    headUrl = [NSString stringWithFormat:@"%@%@",baseUrl,headUrl];
                }
            } else {
                headUrl = @"";
            }
           completion([[RCUserInfo alloc] initWithUserId:userId name:self.data1[@"nickname"] portrait:headUrl]);
            return;
        }
    }
    
    if (self.data2) {
        NSString * iden = [NSString stringWithFormat:@"%@",self.data2[@"userId"]];
        if ([iden isEqualToString:userId]) {
            NSString * headUrl = self.data2[@"head_pic"];
            if (headUrl && [headUrl isKindOfClass:[NSString class]]) {
                if (![headUrl containsString:@"http"]) {
                    headUrl = [NSString stringWithFormat:@"%@%@",baseUrl,headUrl];
                }
            } else {
                headUrl = @"";
            }
            completion([[RCUserInfo alloc] initWithUserId:userId name:self.data2[@"nickname"] portrait:headUrl]);
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addChat" object:nil];;
}
@end
