//
//  DeatilTableViewCellValue2.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import "DeatilTableViewCellValue2.h"
#import "DetailCollectionViewCell.h"
#import "RCIM.h"
#import "KKChatViewController.h"
@interface DeatilTableViewCellValue2()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RCIMUserInfoDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) NSMutableArray * equArr;
@property(nonatomic,strong) NSString * phoneStr;
@property(nonatomic,strong) NSString * houseUserId;//房东id
@property(nonatomic,strong) NSDictionary * data1;
@property(nonatomic,strong) NSDictionary * data2;
@end
@implementation DeatilTableViewCellValue2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.equArr = [NSMutableArray new];
    [self.collectionView registerNib:[UINib  nibWithNibName:@"DetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailCollectionViewCell"];
}
- (void)assignWithDic:(NSDictionary *)dict
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,dict[@"head_pic"]]] placeholderImage:nil];
    self.nameLabel.text = dict[@"h_name"];
    NSString * phone = dict[@"h_mobile"];
    self.phoneStr = phone;
    self.houseUserId = dict[@"user_id"];
    NSString * status = dict[@"status"];
    NSArray * arr = [status componentsSeparatedByString:@","];
   NSArray * equArr = @[@{@"eId":@"1",@"title":@"标准间",@"imageName":@"biaozhunjian"},@{@"eId":@"2",@"title":@"大床间",@"imageName":@"dachuangjian"},@{@"eId":@"3",@"title":@"家庭房",@"imageName":@"jiatingfang"},@{@"eId":@"4",@"title":@"24小时热水",@"imageName":@"hotwater"},@{@"eId":@"5",@"title":@"电视",@"imageName":@"tv"},@{@"eId":@"6",@"title":@"空调",@"imageName":@"kongtiao"},@{@"eId":@"7",@"title":@"整租",@"imageName":@"zhengzu"},@{@"eId":@"8",@"title":@"单间",@"imageName":@"danzu"},@{@"eId":@"9",@"title":@"wifi",@"imageName":@"wifi"},@{@"eId":@"10",@"title":@"三人行礼包",@"imageName":@"sanrenxing"},@{@"eId":@"11",@"title":@"娱乐设施",@"imageName":@"game"},@{@"eId":@"12",@"title":@"周边景点",@"imageName":@"jingdian"},@{@"eId":@"13",@"title":@"停车场",@"imageName":@"tingchechang"}];
    [self.equArr removeAllObjects];
    for (NSString * s in arr) {
        NSDictionary * dic = equArr[s.integerValue - 1];
        [self.equArr addObject:dic];
    }
    [self.collectionView reloadData];
}

- (IBAction)call:(UIButton *)sender {
    if (self.phoneStr) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneStr];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self addSubview:callWebview];
        sender.userInteractionEnabled = NO;
        [NSThread sleepForTimeInterval:0.25];
        sender.userInteractionEnabled = YES;
    }
}
- (IBAction)sendMessage:(id)sender {
    if (self.houseUserId == nil) {
        [KKAlert showErrorHint:@"获取数据失败"];
        return;
    }
    //修改这里
    [KKAlert showAnimateWithStauts:@"服务器连接中"];
    [KKNetWork addChatWithParm:@{@"fs_token":[UserDefaults token],@"js_user_id":self.houseUserId} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        NSString * chatId = dic[@"data"];
        if (code.integerValue == 200) {
                [KKNetWork getRTokenWithParm:@{@"token":[UserDefaults token],@"id":chatId} SuccessBlock:^(NSDictionary *dic) {
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
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"addChat" object:nil];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                KKChatViewController *conversationVC = [[KKChatViewController alloc]init];
                                conversationVC.conversationType =ConversationType_PRIVATE;
                                conversationVC.targetId  = targetId;
                                conversationVC.title = data2[@"nickname"];
                                UIViewController * vc = [self viewController];
                                [vc.navigationController pushViewController:conversationVC animated:YES];
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
        } else {
            [KKAlert dismiss];
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"连接服务器失败"];
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.equArr[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.equArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 105);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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
@end
