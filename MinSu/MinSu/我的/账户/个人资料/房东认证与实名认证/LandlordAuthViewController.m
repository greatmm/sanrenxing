//
//  LandlordAuthViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "LandlordAuthViewController.h"
#import "KKInputTableViewCell.h"
#import "KKSelectControl.h"

@interface LandlordAuthViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray * arr;
@property(nonatomic,strong) UIView * footer;
@property(nonatomic,strong) NSString * name;//姓名
@property(nonatomic,strong) NSString * idNumber;//身份证号
@property(nonatomic,strong) NSString * phone;//电话号
@property(nonatomic,strong) NSString * address;//地址
@property(nonatomic,strong) UIImage * idCordBefore;//身份证正面
@property(nonatomic,strong) UIImage * idCordBehind;//身份证反面
@property(nonatomic,strong) UIImage * fangchanzheng;//房产证图片
@property(nonatomic,assign) NSInteger flag;//上传的什么图片
@property(nonatomic,assign) BOOL inputEnabled;//是否允许输入
@end

@implementation LandlordAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputEnabled = YES;
    self.arr = @[@{@"title":@"姓名",@"placehold":@"您的姓名"},@{@"title":@"身份证号",@"placehold":@"您的身份证号码"},@{@"title":@"联系电话",@"placehold":@"您的电话号码"},@{@"title":@"地址",@"placehold":@"您的居住地址"}];
    self.tableView.tableFooterView = self.footer;
    if (self.isLandloarAuth) {
        self.title = @"房东认证";
        if (self.status == 1 || self.status == 2) {
            self.inputEnabled = NO;
            self.footer.userInteractionEnabled = NO;
            [KKAlert showAnimateWithStauts:@"数据获取中"];
            [KKNetWork getHoustUserInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
                [KKAlert dismiss];
                NSString * code  = dic[@"code"];
                if (code.integerValue == 200) {
                    NSDictionary * data = dic[@"data"];
                    self.address = data[@"h_address"];
                    self.name = data[@"h_name"];
                    self.idNumber = data[@"h_card"];
                    self.phone = data[@"h_mobile"];
                    NSString * beforeUrl = data[@"h_zheng_pic"];
                    NSString * behindUrl = data[@"h_fan_pic"];
                    NSString * fcUrl = data[@"h_fc_pic"];
                    [self.tableView reloadData];
                    KKSelectControl * control1 = self.footer.subviews[0];
                    KKSelectControl * control2 = self.footer.subviews[1];
                    KKSelectControl * control3 = self.footer.subviews[2];
                    [control1.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,beforeUrl]] placeholderImage:nil];

                    [control2.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,behindUrl]] placeholderImage:nil];
                    [control3.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,fcUrl]] placeholderImage:nil];
                    /*
                     {
                     "is_name" = 2;
                     "n_address" = "\U5317\U4eac\U5e02\U671d\U9633\U533a";
                     "n_card" = 410425198910296536;
                     "n_fan_pic" = "/Uploads/Images/2017-12-27/5a435d4f51ff8.png";
                     "n_mobile" = 17637500521;
                     "n_name" = "\U9ad8\U68a6\U53ef";
                     "n_zheng_pic" = "/Uploads/Images/2017-12-27/5a435d4f772f6.png";
                     };
                     */
                } else {
                    [KKAlert showErrorHint:dic[@"msg"]];
                }
            } erreorBlock:^(NSError *error) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"获取数据失败"];
            }];
        }
    } else {
        self.title = @"实名认证";
        if (self.status == 1 || self.status == 2) {
            self.inputEnabled = NO;
            self.footer.userInteractionEnabled = NO;
            [KKAlert showAnimateWithStauts:@"数据获取中"];
            [KKNetWork getNameUserInfoWithParm:@{@"token":[UserDefaults token]} SuccessBlock:^(NSDictionary *dic) {
                [KKAlert dismiss];
                NSString * code  = dic[@"code"];
                if (code.integerValue == 200) {
                    NSDictionary * data = dic[@"data"];
                    self.address = data[@"n_address"];
                    self.name = data[@"n_name"];
                    self.idNumber = data[@"n_card"];
                    self.phone = data[@"n_mobile"];
                    NSString * beforeUrl = data[@"n_zheng_pic"];
                    NSString * behindUrl = data[@"n_fan_pic"];
                    [self.tableView reloadData];
                    KKSelectControl * control1 = self.footer.subviews[0];
                    KKSelectControl * control2 = self.footer.subviews[1];
                    [control1.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,beforeUrl]] placeholderImage:nil];
                    [control2.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,behindUrl]] placeholderImage:nil];
                } else {
                    [KKAlert showErrorHint:dic[@"msg"]];
                }
            } erreorBlock:^(NSError *error) {
                [KKAlert dismiss];
                [KKAlert showErrorHint:@"数据获取失败"];
            }];
        }
    }
}
- (UIView *)footer
{
    if (_footer) {
        return _footer;
    }
    _footer = [UIView new];
    KKSelectControl * control1 = [[KKSelectControl alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth * 0.5, 125)];
    control1.imageView.image = [UIImage imageNamed:@"camera1"];
    control1.label.text = @"身份证正面";
    control1.tag = 0;
    KKSelectControl * control2 = [[KKSelectControl alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5, 35, ScreenWidth * 0.5, 125)];
    control2.imageView.image = [UIImage imageNamed:@"camera2"];
    control2.tag = 1;
    control2.label.text = @"身份证反面";
    [control1 addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [control2 addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [_footer addSubview:control1];
    [_footer addSubview:control2];
    CGFloat height = 190;
    if (self.isLandloarAuth) {
       KKSelectControl * control3 = [[KKSelectControl alloc] initWithFrame:CGRectMake(0, 180, ScreenWidth * 0.5, 125)];
        control3.imageView.image = [UIImage imageNamed:@"camera3"];
        control3.tag = 2;
        control3.label.text = @"房产证";
        [control3 addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [_footer addSubview:control3];
        height = 335;
    }
    _footer.frame = CGRectMake(0, 0, ScreenWidth, height);
    return _footer;
}
- (void)selectImage:(KKSelectControl *)control
{
    _flag = control.tag;
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
    KKSelectControl * control = self.footer.subviews[_flag];
    control.imageView.image = image;
    if (_flag == 0) {
        self.idCordBefore = image;
    } else if (_flag == 1){
        self.idCordBehind = image;
    } else if (_flag == 2){
        self.fangchanzheng = image;
    }
}

- (IBAction)uploadInfo:(id)sender {
    if (self.isLandloarAuth) {
        NSMutableDictionary * parm = [NSMutableDictionary new];
        parm[@"token"] = [UserDefaults token];
        if (self.name == nil || self.name.length == 0) {
            [KKAlert showErrorHint:@"请输入姓名"];
            return;
        }
        parm[@"h_name"] = self.name;
        
        if (self.idNumber == nil) {
            [KKAlert showErrorHint:@"请输入身份证号"];
            return;
        }
        if (![self.idNumber isPhoneNumber]) {
            [KKAlert showErrorHint:@"身份证号码不正确"];
            return;
        }
        parm[@"h_card"] = self.idNumber;

        if (self.phone == nil) {
            [KKAlert showErrorHint:@"请输入手机号"];
            return;
        }
        if (![self.phone isPhoneNumber]) {
            [KKAlert showErrorHint:@"手机号不正确"];
            return;
        }
        parm[@"h_mobile"] = self.phone;

        if (self.address == nil || self.address.length == 0) {
            [KKAlert showErrorHint:@"请输入您的地址"];
            return;
        }
        parm[@"h_address"] = self.address;
        
        if (self.idCordBefore == nil) {
            [KKAlert showErrorHint:@"请上传身份证正面照片"];
            return;
        }
        if (self.idCordBehind == nil) {
            [KKAlert showErrorHint:@"请上传身份证反面照片"];
            return;
        }
        if (self.fangchanzheng == nil) {
            [KKAlert showErrorHint:@"请上传房产证照片"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"资料上传中"];
        [KKNetWork addHoustUserWithParm:parm imgS:@{@"h_zheng_pic":self.idCordBefore,@"h_fan_pic":self.idCordBehind,@"h_fc_pic":self.fangchanzheng} SuccessBlock:^(NSDictionary *dic) {
            NSNumber * code = dic[@"code"];
            [KKAlert dismiss];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"资料上传成功"];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"资料上传失败"];
        }];
    } else {
        NSMutableDictionary * parm = [NSMutableDictionary new];
        parm[@"token"] = [UserDefaults token];
        
        if (self.name == nil || self.name.length == 0) {
            [KKAlert showErrorHint:@"请输入姓名"];
            return;
        }
        parm[@"n_name"] = self.name;
        
        if (self.idNumber == nil) {
            [KKAlert showErrorHint:@"请输入身份证号"];
            return;
        }
        if (![self.idNumber isPhoneNumber]) {
            [KKAlert showErrorHint:@"身份证号码不正确"];
            return;
        }
        parm[@"n_card"] = self.idNumber;
        
        if (self.phone == nil) {
            [KKAlert showErrorHint:@"请输入手机号"];
            return;
        }
        if (![self.phone isPhoneNumber]) {
            [KKAlert showErrorHint:@"手机号不正确"];
            return;
        }
        parm[@"n_mobile"] = self.phone;
        
        if (self.address == nil || self.address.length == 0) {
            [KKAlert showErrorHint:@"请输入您的地址"];
            return;
        }
        parm[@"n_address"] = self.address;
        
        if (self.idCordBefore == nil) {
            [KKAlert showErrorHint:@"请上传身份证正面照片"];
            return;
        }
        if (self.idCordBehind == nil) {
            [KKAlert showErrorHint:@"请上传身份证反面照片"];
            return;
        }
        [KKAlert showAnimateWithStauts:@"资料上传中"];

        [KKNetWork addNameUserWithParm:parm imgS:@{@"n_zheng_pic":self.idCordBefore,@"n_fan_pic":self.idCordBehind} SuccessBlock:^(NSDictionary *dic) {
            NSNumber * code = dic[@"code"];
            [KKAlert dismiss];
            if (code.integerValue == 200) {
                [KKAlert showSuccessHint:@"资料上传成功"];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"资料上传失败"];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKInputTableViewCell * cell = [KKInputTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    kkWeakSelf
    cell.textBlock = ^(NSString *text) {
        switch (indexPath.row) {
            case 0:
                {
                    weakSelf.name = text;
                }
                break;
            case 1:
            {
                weakSelf.idNumber = text;
            }
                break;
            case 2:
            {
                weakSelf.phone = text;
            }
                break;
            case 3:
            {
                weakSelf.address = text;
            }
                break;
            default:
                break;
        }
    };
    NSDictionary * dic = self.arr[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.textField.placeholder = dic[@"placehold"];
    if (!self.inputEnabled) {
        cell.textField.userInteractionEnabled = NO;
    }
    switch (indexPath.row) {
        case 0:
        {
            if (self.name) {
                cell.textField.text = self.name;
            }
        }
            break;
        case 1:
        {
            if (self.idNumber) {
                cell.textField.text = self.idNumber;
            }
        }
            break;
        case 2:
        {
            if (self.phone) {
                cell.textField.text = self.phone;
            }
        }
            break;
        case 3:
        {
            if (self.address) {
                cell.textField.text = self.address;
            }
        }
            break;
        default:
            break;
    }
    if (indexPath.row == 2) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}
@end
