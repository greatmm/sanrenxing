//
//  PersonInfoTableViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "PersonInfoTableViewController.h"
#import "AvatarTableViewCell.h"
#import "LandlordAuthViewController.h"
#import "UpdateInfoViewController.h"

@interface PersonInfoTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) NSArray * arr;
@property(nonatomic,strong) NSDictionary * userInfoDic;
@end

@implementation PersonInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.arr = @[@"昵称",@"性别",@"生日",@"邮箱",@"实名认证",@"房东认证"];
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [UIView new];
    [self getUserInfo];
    /*
     {
     birthday = "";
     email = "";
     "head_pic" = "<null>";
     "is_house" = 0;
     "is_name" = 0;
     nickname = "\U68a6\U73c2";
     sex = 0;
     "user_id" = 38;
     };
     */
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserDefaults userInfoUpdate]) {
        [UserDefaults saveUserInfoUpdate:NO];
        [self getUserInfo];
    }
}
- (void)getUserInfo
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getUserInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSString * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSDictionary * data = dic[@"data"];
            self.userInfoDic = data;
            [self.tableView reloadData];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section?self.arr.count:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AvatarTableViewCell * cell = [AvatarTableViewCell cellWithTableView:tableView indexPatch:indexPath];
        cell.textLabel.text = @"头像";
        cell.textLabel.textColor = k102Color;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.avatarButton addTarget:self action:@selector(selectAvatar) forControlEvents:UIControlEventTouchUpInside];
        if (self.userInfoDic) {
            NSString * head_pic = self.userInfoDic[@"head_pic"];
            if (head_pic && ![head_pic isKindOfClass:[NSNull class]]) {
                if ([head_pic containsString:@"http"]) {
                    [cell.avatarButton.imageView sd_setImageWithURL:[NSURL URLWithString:head_pic] placeholderImage:[UIImage imageNamed:@"default_icon"]   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image) {
                            [cell.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
                        } else {
                           [cell.avatarButton setBackgroundImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];
                        }
                    }];
                } else {
                    [cell.avatarButton.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,head_pic]] placeholderImage:[UIImage imageNamed:@"default_icon"]   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image) {
                            [cell.avatarButton setBackgroundImage:image forState:UIControlStateNormal];
                        } else {
                            [cell.avatarButton setBackgroundImage:[UIImage imageNamed:@"default_icon"] forState:UIControlStateNormal];
                        }
                    }];
                }
            }
        }
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = k102Color;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.textLabel.text = self.arr[indexPath.row];
   
    if (self.userInfoDic) {
        switch (indexPath.row) {
            case 0:
            {
                NSString * nickName = self.userInfoDic[@"nickname"];
                if (nickName) {
                    cell.detailTextLabel.text = nickName;
                }
            }
                break;
            case 1:
            {
                NSString * sex = self.userInfoDic[@"sex"];
                if (sex.integerValue == 1) {
                    cell.detailTextLabel.text = @"男";
                } else if(sex.integerValue == 2){
                    cell.detailTextLabel.text = @"女";
                }
            }
                break;
            case 2:
            {
                NSString * birthday = self.userInfoDic[@"birthday"];
                cell.detailTextLabel.text = birthday;
            }
                break;
                
            case 3:
            {
                NSString * email = self.userInfoDic[@"email"];
                cell.detailTextLabel.text = email;
            }
                break;
            case 4:
            {
                NSString * is_name = self.userInfoDic[@"is_name"];
                // "is_name": "实名认证1认证通过 2审核中 -1审核失败"
                NSString * str = @"未认证";
                if (is_name.integerValue == 1) {
                    str = @"认证通过";
                } else if (is_name.integerValue == 2){
                    str = @"审核中";
                } else if(is_name.integerValue == -1){
                    str = @"审核失败";
                }
                cell.detailTextLabel.text = str;
            }
                break;
            case 5:
            {

                //"is_house": "房东认证1认证通过 2审核中 -1审核失败"
                NSString * is_house = self.userInfoDic[@"is_house"];
                NSString * str = @"未认证";
                if (is_house.integerValue == 1) {
                    str = @"认证通过";
                } else if (is_house.integerValue == 2){
                    str = @"审核中";
                } else if(is_house.integerValue == -1){
                    str = @"审核失败";
                }
                cell.detailTextLabel.text = str;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section?44:86;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.row == 0 || indexPath.row == 3) {
        UpdateInfoViewController * updateVC = [UpdateInfoViewController new];
        updateVC.style = indexPath.row?1:0;
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextLabel) {
            updateVC.content = cell.detailTextLabel.text;
        }
        [self.navigationController pushViewController:updateVC animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        UIAlertController * alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * boyAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.userInfoDic) {
                NSString * sexDefault = self.userInfoDic[@"sex"];
                if (sexDefault.integerValue == 1) {
                    return;
                }
            }
            NSString * sex = @"1";
            NSDictionary * parm = @{@"token":[UserDefaults token],@"sex":sex};
            [KKAlert showAnimateWithStauts:@"数据上传中"];
            [KKNetWork updateSexWithParm:parm SuccessBlock:^(NSDictionary *dic) {
                [KKAlert dismiss];
                NSNumber * code = dic[@"code"];
                if (code.integerValue == 200) {
                    [self getUserInfo];
                } else {
                    [KKAlert showErrorHint:dic[@"msg"]];
                }
            } erreorBlock:^(NSError *error) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"修改失败"];
            }];
        }];
        UIAlertAction * girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.userInfoDic) {
                NSString * sexDefault = self.userInfoDic[@"sex"];
                if (sexDefault.integerValue == 2) {
                    return;
                }
            }
            NSString * sex = @"2";
            NSDictionary * parm = @{@"token":[UserDefaults token],@"sex":sex};
            [KKAlert showAnimateWithStauts:@"数据上传中"];
            [KKNetWork updateSexWithParm:parm SuccessBlock:^(NSDictionary *dic) {
                [KKAlert dismiss];
                NSNumber * code = dic[@"code"];
                if (code.integerValue == 200) {
                    [self getUserInfo];
                } else {
                    [KKAlert showErrorHint:dic[@"msg"]];
                }
            } erreorBlock:^(NSError *error) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"修改失败"];
            }];
        }];
        UIAlertAction * cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:boyAction];
        [alert addAction:girlAction];
        [alert addAction:cacelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (indexPath.row == 2) {
        UIAlertController * alert =  [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIDatePicker * datePicker = [UIDatePicker new];
        datePicker.datePickerMode  = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSDate * date;
        if (self.userInfoDic && self.userInfoDic[@"birthday"]) {
            NSString * birthday = self.userInfoDic[@"birthday"];
            date = [dateFormat dateFromString:birthday];
        } else {
            date = [NSDate date];
        }
        datePicker.maximumDate = [NSDate date];
        datePicker.date = date;
        [alert.view addSubview:datePicker];
        UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            if (self.userInfoDic) {
                NSString * birthday = self.userInfoDic[@"birthday"];
                if (birthday && ![birthday isKindOfClass:[NSNull class]]) {
                    if ([birthday isEqualToString:dateString]) {
                        return;
                    }
                }
            }
            NSDictionary * parm = @{@"token":[UserDefaults token],@"birthday":dateString};
            [KKAlert showAnimateWithStauts:@"数据上传中"];
            [KKNetWork updateBirthdayWithParm:parm SuccessBlock:^(NSDictionary *dic) {
                [KKAlert dismiss];
                NSNumber * code = dic[@"code"];
                if (code.integerValue == 200) {
                    [self getUserInfo];
                } else {
                    [KKAlert showErrorHint:dic[@"msg"]];
                }
            } erreorBlock:^(NSError *error) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"修改失败"];
            }];
        }];
        
        UIAlertAction * cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ensure];
        [alert addAction:cacelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (indexPath.row > 3) {
        if (self.userInfoDic == nil) {
            [KKAlert showErrorHint:@"获取数据失败"];
            return;
        }
        LandlordAuthViewController * vc = [LandlordAuthViewController new];
        vc.isLandloarAuth = indexPath.row == 5;
        if (indexPath.row == 4) {
            NSString * is_name = self.userInfoDic[@"is_name"];
            vc.status = is_name.integerValue;
        } else {
            NSString * is_house = self.userInfoDic[@"is_house"];
            vc.status = is_house.integerValue;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)selectAvatar
{
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
    [KKAlert showAnimateWithStauts:@"头像上传中"];
    [KKNetWork uploadAvatarWithPara:@{@"token":[UserDefaults token]} img:image fileName:@"head_pic.png" SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [self getUserInfo];
        } else {
            [KKAlert showErrorHint:dic[@"msg"]];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"头像上传失败"];
    }];
}
@end
