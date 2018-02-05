//
//  MineViewController.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "MineViewController.h"
#import "KKNavigationController.h"
#import "LoginViewController.h"
#import "KKUpDownButton.h"
#import "KKTabBarController.h"
#import <SafariServices/SafariServices.h>

@interface MineViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;//我是房客还是房东
@property (weak, nonatomic) IBOutlet KKUpDownButton *orderBtn;//订单或房源

@property(nonatomic,strong) NSDictionary * dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopCons;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUserInfo];
    if ([UserDefaults isHouse]) {
        [self.orderBtn setTitle:@"房源" forState:UIControlStateNormal];
        [self.orderBtn setImage:[UIImage imageNamed:@"house"] forState:UIControlStateNormal];
        [self.bottomBtn setTitle:@"我是房客" forState:UIControlStateNormal];
    } else {
        [self.orderBtn setTitle:@"订单" forState:UIControlStateNormal];
        [self.orderBtn setImage:[UIImage imageNamed:@"dingdan"] forState:UIControlStateNormal];
        [self.bottomBtn setTitle:@"我是房东" forState:UIControlStateNormal];
    }
    if (isIphoneX) {
        self.toTopCons.constant = 0;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([UserDefaults userInfoUpdate]) {
        [self refreshUserInfo];
        [UserDefaults saveUserInfoUpdate:NO];
    }
}
- (void)refreshUserInfo
{
    [KKAlert showAnimateWithStauts:@"数据请求中"];
    [KKNetWork indexInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * data = dic[@"data"];
            self.dataDic = data;
            NSString * headPic = data[@"head_pic"];
            NSString * nickName = data[@"nickname"];
            if (nickName && [nickName isKindOfClass:[NSString class]]) {
                self.nameLabel.text = nickName;
            } else {
                self.nameLabel.text = @"";
            }
            
            /*
             {
             "head_pic" = "/Uploads/Images/2017-12-27/5a430affbc87e.png";
             "is_house" = 0;
             "is_name" = 0;
             nickname = "\U68a6\U73c2";
             "user_id" = 38;
             }
             */
            NSString * is_name = data[@"is_name"];
            NSInteger name = is_name.integerValue;
            NSString * state = @"";
            if (name == 0) {
                state = @"  未实名认证";
            } else if (name == 1){
                state = @"  已实名认证";
            } else {
                state = @"  实名认证审核中";
            }
            [self.stateBtn setTitle:state forState:UIControlStateNormal];
            
            if (headPic && ![headPic isKindOfClass:[NSNull class]]) {
                if ([headPic containsString:@"http"]) {
                    [self.avatarBtn.imageView sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"default_icon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image) {
                            [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
                            
                        } else {
                            [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];
                        }
                    }];
                } else {
                    [self.avatarBtn.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,headPic]] placeholderImage:[UIImage imageNamed:@"default_icon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image) {
                            [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];

                        } else {
                            [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];

                        }
                    }];
                }
            }
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - buttonclick

- (IBAction)selectAvatar:(id)sender {
    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    pickerC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    pickerC.allowsEditing = YES;
    UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerC animated:YES completion:nil];
    }];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerC animated:YES completion:nil];
    }];
    UIAlertAction * cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alert addAction:cameraAction];
    }
    [alert addAction:photoAction];
    [alert addAction:cacelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [KKNetWork uploadAvatarWithPara:@{@"token":[UserDefaults token]} img:image fileName:@"head_pic.png" SuccessBlock:^(NSDictionary *dic) {
        [self refreshUserInfo];
    } erreorBlock:^(NSError *error) {
        
    }];
}

- (IBAction)clickBtn:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSArray * arr;
    if ([UserDefaults isHouse]) {
        arr = @[@"MyHouseTableViewController",@"AccountTableViewController",@"JifenViewController",@"CouponTableViewController",@"HelpTableViewController",@"MyCollectionTableViewController"];
    } else {
       arr = @[@"OrderViewController",@"AccountTableViewController",@"JifenViewController",@"CouponTableViewController",@"HelpTableViewController",@"MyCollectionTableViewController"];
    }
    if (tag == 4) {
        SFSafariViewController * sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/faxian/bangzhu/token/%@",baseUrl,[UserDefaults token]]]];
        [self.navigationController presentViewController:sfVC animated:YES completion:nil];
        return;
    }
    Class class = NSClassFromString(arr[tag]);
    [self.navigationController pushViewController:[class new] animated:YES];
}
//点击我是房客
- (IBAction)clickFangkeBtn:(id)sender {
    BOOL isHouse = [UserDefaults isHouse];
    if (isHouse) {
        [UserDefaults saveIsHouse:!isHouse];
        [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
    } else {
        if (self.dataDic) {
            NSString * isH = self.dataDic[@"is_house"];
            if (isH.integerValue == 1) {
                [UserDefaults saveIsHouse:!isHouse];
                [UIApplication sharedApplication].delegate.window.rootViewController = [[KKTabBarController alloc] init];
            } else if (isH.integerValue == 2){
                [KKAlert showErrorHint:@"房东审核中"];
            } else if (isH.integerValue == -1){
                [KKAlert showErrorHint:@"房东审核失败,请重新上传资料"];
            } else if(isH.integerValue == 0){
                [KKAlert showErrorHint:@"您尚未进行房东认证,请先去账户/个人资料/房东认证进行认证"];
            }
        } else {
            [self refreshUserInfo];
        }
    }
}

- (IBAction)clickSettingBtn:(id)sender {
    Class class = NSClassFromString(@"SettingTableViewController");
    [self.navigationController pushViewController:[class new] animated:YES];
}

@end
