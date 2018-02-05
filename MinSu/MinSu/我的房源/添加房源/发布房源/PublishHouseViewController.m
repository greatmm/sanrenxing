//
//  PublishHouseViewController.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "PublishHouseViewController.h"
#import "PublishHouseTableViewCell.h"
#import "EquipmentSelectView.h"
#import "AddressSelectView.h"
#import "HouseImageCollectionViewCell.h"
#import "HouseAddImageCollectionViewCell.h"
#import "ZLPhotoActionSheet.h"
#import "BrowseHouseViewController.h"
#import "CMInputView.h"
#import "KKInputView.h"
#import "KKTextInputView.h"
#import "MyHouseTableViewController.h"

@interface PublishHouseViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * titleArr;
@property (nonatomic,strong) KKInputView * priceInputView;
@property (nonatomic,strong) KKInputView * titleInputView;
@property (nonatomic,strong) NSString * price;

@property (nonatomic,strong) NSString * houseTitle;
@property (nonatomic,strong) NSString * desStr;
@property (nonatomic,strong) KKTextInputView * desInputView;
@property (nonatomic,strong) EquipmentSelectView * selView;//选择设备view
@property (nonatomic,strong) NSArray * equArr;//配套设置数组
@property (nonatomic,strong) AddressSelectView * addressSelView;//选择地址view
@property (nonatomic,strong) UICollectionView * cv;//房屋图片
@property (nonatomic,strong) NSMutableArray * imageArr;
@property(nonatomic,strong)NSString * addressStr;

@end

@implementation PublishHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布房源";
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(yulan)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithWhite:40/255.0 alpha:1];
    self.titleArr = @[@"房源标题",@"房源信息",@"价格设定",@"配套设施",@"房源地址"];
    self.imageArr = [NSMutableArray new];
    self.tableView.tableHeaderView = self.cv;
}
- (KKTextInputView *)desInputView
{
    if (_desInputView) {
        return _desInputView;
    }
    _desInputView = [KKTextInputView shareTextInputView];
    kkWeakSelf
    _desInputView.ensureBlock = ^(NSString *text) {
        weakSelf.desStr = text;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _desInputView;
}
- (KKInputView *)titleInputView
{
    if (_titleInputView) {
        return _titleInputView;
    }
    _titleInputView = [KKInputView shareInputView];
    _titleInputView.tf.placeholder = @"输入标题";
    _titleInputView.tf.keyboardType = UIKeyboardTypeDefault;
    _titleInputView.titleLabel.text = @"";
    kkWeakSelf
    _titleInputView.ensureBlock = ^(NSString *text) {
        weakSelf.houseTitle = text;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _titleInputView;
}
- (KKInputView *)priceInputView
{
    if (_priceInputView) {
        return _priceInputView;
    }
    _priceInputView = [KKInputView shareInputView];
    _priceInputView.tf.placeholder = @"输入价格信息";
    _priceInputView.tf.keyboardType = UIKeyboardTypeNumberPad;
    kkWeakSelf
    _priceInputView.ensureBlock = ^(NSString *text) {
        weakSelf.price = text;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _priceInputView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count) {
        return self.imageArr.count;
    }
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageArr.count) {
        HouseImageCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseImageCollectionViewCell" forIndexPath:indexPath];
        cell.imageView.image = self.imageArr[indexPath.row];
        kkWeakSelf
        cell.delBlock = ^{
            [weakSelf.imageArr removeObjectAtIndex:indexPath.row];
            [weakSelf.cv reloadData];
        };
        return cell;
    }
    HouseAddImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseAddImageCollectionViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageArr.count > 10) {
        [KKAlert showErrorHint:@"最多只能添加10张图片"];
        return;
    }
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 10 - self.imageArr.count;
    ac.configuration.maxPreviewCount = 50;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    kkWeakSelf
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf.imageArr addObjectsFromArray:images];
        [weakSelf.cv reloadData];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
}
- (UICollectionView *)cv
{
    if (_cv) {
        return _cv;
    }
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:layout];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.pagingEnabled = YES;
    _cv.showsHorizontalScrollIndicator = NO;
    [_cv registerNib:[UINib nibWithNibName:@"HouseImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HouseImageCollectionViewCell"];
    [_cv registerNib:[UINib nibWithNibName:@"HouseAddImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HouseAddImageCollectionViewCell"];
    
    _cv.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_background"]];
    return _cv;
}
- (AddressSelectView *)addressSelView
{
    if (_addressSelView) {
        return _addressSelView;
    }
    _addressSelView = [AddressSelectView shareAddressView];
    _addressSelView.cityArr = self.cityArr;
    kkWeakSelf
    _addressSelView.ensureBlock = ^(NSString *addressStr) {
        weakSelf.addressStr = addressStr;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _addressSelView;
}
- (EquipmentSelectView *)selView
{
    if (_selView) {
        return _selView;
    }
    _selView = [EquipmentSelectView shareEquView];
    kkWeakSelf
    _selView.selBlock = ^(NSMutableArray *arr) {
        weakSelf.equArr = arr.copy;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    return _selView;
}

- (void)yulan
{
    BOOL isRight = [self checkParm];
    if (isRight == NO) {
        return;
    }
    BrowseHouseViewController * vc = [BrowseHouseViewController new];
    vc.house_title = self.houseTitle;
    vc.house_des = self.desStr;
    vc.price = self.price;
    vc.address = self.addressStr;
    vc.imageArr = self.imageArr;
    vc.equArr = self.equArr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)publish:(id)sender
{
    BOOL isRight = [self checkParm];
    if (isRight == NO) {
        return;
    }
    NSMutableString * status = [NSMutableString new];
    for (NSDictionary * dict in self.equArr) {
        [status appendString:dict[@"eId"]];
        [status  appendString:@","];
    }
    [status deleteCharactersInRange:NSMakeRange(status.length  - 1, 1)];
    [KKAlert showAnimateWithStauts:@"房源上传 中"];
    [KKNetWork addHouseWithParm:@{@"token":[UserDefaults token],@"house_type_id":self.fyDic[@"id"],@"space_type_id":self.kjDic[@"id"],@"title":self.houseTitle,@"house_info":self.desStr,@"house_price":self.price,@"status":status,@"province":self.addressSelView.pDic[@"id"],@"city":self.addressSelView.cDic[@"id"],@"district":self.addressSelView.qDic[@"id"],@"town":self.addressSelView.sDic[@"id"]} imageArr:self.imageArr SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            [KKAlert showSuccessHint:@"发布成功"];
            for (UIViewController * vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[MyHouseTableViewController class]]) {
                    MyHouseTableViewController * controller = (MyHouseTableViewController *)vc;
                    controller.changed = YES;
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            
        } else {
           [KKAlert showSuccessHint:@"发布房源 失败"];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"发布失败"];
    }];
}
- (BOOL)checkParm
{
    if (self.imageArr.count == 0) {
        [KKAlert showErrorHint:@"请选择房屋图片"];
        return NO;
    }
    if (self.houseTitle == nil || self.houseTitle.length == 0) {
        [KKAlert showErrorHint:@"请输入房源标题"];
        return NO;
    }
    if (self.desStr == nil || self.desStr.length == 0) {
        [KKAlert showErrorHint:@"请输入房源描述"];
        return NO;
    }
    if (self.price == nil || self.price.length == 0) {
        [KKAlert showErrorHint:@"请输入每天价格"];
        return NO;
    }
    if (self.equArr == nil || self.equArr.count == 0) {
        [KKAlert showErrorHint:@"请选择配套设置"];
        return NO;
    }
    if (self.addressSelView.pDic == nil || self.addressSelView.cDic == nil || self.addressSelView.qDic == nil || self.addressSelView.sDic == nil) {
        [KKAlert showErrorHint:@"请选择房屋地址"];
        return NO;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuse = @"iden";
    PublishHouseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (nil == cell) {
        cell = [[PublishHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithWhite:40/255.0 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:132/255.0 alpha:1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.numberOfLines = 0;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (self.houseTitle && self.houseTitle.length) {
                cell.detailTextLabel.text = self.houseTitle;
            } else {
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case 1:
        {
            if (self.desStr && self.desStr.length) {
                cell.detailTextLabel.text = self.desStr;
            } else {
                cell.detailTextLabel.text = @"";
            }

        }
            break;
        case 2:
        {
            if (self.price && self.price.length) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/晚",self.price];
            } else {
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case 3:
        {
            if (self.equArr) {
                NSMutableString * str =  [NSMutableString new];
                for (NSDictionary * dic in self.equArr) {
                    NSString * title = dic[@"title"];
                    [str appendString:title];
                    [str appendString:@"/"];
                }
                if (str.length) {
                    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
                }
                cell.detailTextLabel.text = str;
            } else {
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case 4:
        {
            if (self.addressStr && self.addressStr.length) {
                cell.detailTextLabel.text = self.addressStr;
            } else {
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (self.desStr && self.desStr.length) {
            CGFloat height = [self.desStr getHeightWithWidth:ScreenWidth - 50 fontSize:12] + 44;
            return MAX(64, height);
        }
        
    }
    return 64;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    UILabel * label = [UILabel new];
    label.frame = CGRectMake(15, 0, 300, 54);
    label.text = @"房源详细";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    [header addSubview:label];
    header.backgroundColor = [UIColor whiteColor];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self.titleInputView];
            [self.titleInputView.tf becomeFirstResponder];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self.desInputView];
            [self.desInputView.textView becomeFirstResponder];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self.priceInputView];
            [self.priceInputView.tf becomeFirstResponder];
        }
            break;
        case 3:
        {
            [self.selView show];
        }
            break;
        case 4:
        {
            [self.addressSelView show];
        }
            break;
        default:
            break;
    }
}

@end
