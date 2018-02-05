//
//  BrowseHouseViewController.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/2.
//

#import "BrowseHouseViewController.h"
#import "HouseImageCollectionViewCell.h"
#import "DetailCollectionViewCell.h"
#import "DetailTableViewCellValue1.h"

@interface BrowseHouseViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UICollectionView * headerCV;
@property(nonatomic,strong)UICollectionView * footerCV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property(nonatomic,strong)NSDictionary * dataDic;//网络请求到的数据
@property(nonatomic,strong)NSArray * imageUrlArr;
@end

@implementation BrowseHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerCV;
    UIView * footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    footer.frame = CGRectMake(0, 0, ScreenWidth, 120);
    UILabel * label = [UILabel new];
    label.text = @"配套设施";
    label.textColor = k102Color;
    label.font = [UIFont systemFontOfSize:15];
    label.frame = CGRectMake(15, 10, 200, 20);
    [footer addSubview:label];
    [footer addSubview:self.footerCV];
    self.tableView.tableFooterView = footer;
  self.navigationController.navigationBar.hidden = YES;
    if (isIphoneX  == NO) {
        self.topCons.constant = -20;
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
     self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view layoutIfNeeded];
    if (self.house_id) {
        [self getHouseDeatil];
    }
}
- (void)getHouseDeatil
 {
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getHouseDetailWithParm:@{@"token":[UserDefaults token],@"house_id":self.house_id} SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismiss];
            NSNumber * code = dic[@"code"];
            if (code.integerValue == 200) {
                self.dataDic = dic[@"data"];

                NSMutableArray * arr = [NSMutableArray new];
                NSArray * imageArr = self.dataDic[@"house_img"];
                for (NSString * str in imageArr) {
                    [arr addObject:[NSString stringWithFormat:@"%@%@",baseUrl,str]];
                }
                self.imageUrlArr = arr;
                [self.headerCV reloadData];
                
                
                
                NSString * status = self.dataDic[@"status"];
                NSArray * equ = [status componentsSeparatedByString:@","];
                NSArray * equArr = @[@{@"eId":@"1",@"title":@"标准间",@"imageName":@"biaozhunjian"},@{@"eId":@"2",@"title":@"大床间",@"imageName":@"dachuangjian"},@{@"eId":@"3",@"title":@"家庭房",@"imageName":@"jiatingfang"},@{@"eId":@"4",@"title":@"24小时热水",@"imageName":@"hotwater"},@{@"eId":@"5",@"title":@"电视",@"imageName":@"tv"},@{@"eId":@"6",@"title":@"空调",@"imageName":@"kongtiao"},@{@"eId":@"7",@"title":@"整租",@"imageName":@"zhengzu"},@{@"eId":@"8",@"title":@"单间",@"imageName":@"danzu"},@{@"eId":@"9",@"title":@"wifi",@"imageName":@"wifi"},@{@"eId":@"10",@"title":@"三人行礼包",@"imageName":@"sanrenxing"},@{@"eId":@"11",@"title":@"娱乐设施",@"imageName":@"game"},@{@"eId":@"12",@"title":@"周边景点",@"imageName":@"jingdian"},@{@"eId":@"13",@"title":@"停车场",@"imageName":@"tingchechang"}];
                NSMutableArray * eArr = [NSMutableArray new];
                for (NSString * s in equ) {
                    NSDictionary * dic = equArr[s.integerValue - 1];
                    [eArr addObject:dic];
                }
                self.equArr = eArr;
                [self.footerCV reloadData];
                [self.tableView reloadData];
            } else {
                [KKAlert showErrorHint:dic[@"msg"]];
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismiss];
            [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (UICollectionView *)headerCV
{
    if (_headerCV) {
        return _headerCV;
    }
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _headerCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) collectionViewLayout:layout];
    _headerCV.delegate = self;
    _headerCV.dataSource = self;
    _headerCV.pagingEnabled = YES;
    _headerCV.showsHorizontalScrollIndicator = NO;
    _headerCV.backgroundColor = [UIColor whiteColor];
    [_headerCV registerNib:[UINib nibWithNibName:@"HouseImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HouseImageCollectionViewCell"];
    return _headerCV;
}
- (UICollectionView *)footerCV
{
    if (_footerCV) {
        return _footerCV;
    }
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(80, 80);
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _footerCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, 80) collectionViewLayout:layout];
    _footerCV.delegate = self;
    _footerCV.dataSource = self;
    _footerCV.showsHorizontalScrollIndicator = NO;
    _footerCV.backgroundColor = [UIColor whiteColor];
    [_footerCV registerNib:[UINib  nibWithNibName:@"DetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailCollectionViewCell"];
    return _footerCV;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.house_id) {
        if (collectionView == self.headerCV) {
            if (self.imageUrlArr) {
                return self.imageUrlArr.count;
            }
            return 0;
        }
        if (self.equArr) {
            return self.equArr.count;
        }
        return 0;
    }
    if (collectionView == self.headerCV) {
        return self.imageArr.count;
    }
    return self.equArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.house_id) {
        if (collectionView == self.headerCV) {
            HouseImageCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseImageCollectionViewCell" forIndexPath:indexPath];
            cell.delBtn.hidden = YES;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArr[indexPath.row]]];
            return cell;
        }
        DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionViewCell" forIndexPath:indexPath];
        NSDictionary * dic = self.equArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
        cell.titleLabel.text = dic[@"title"];
        return cell;
    }
    
    if (collectionView == self.headerCV) {
        HouseImageCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseImageCollectionViewCell" forIndexPath:indexPath];
        cell.delBtn.hidden = YES;
        cell.imageView.image = self.imageArr[indexPath.row];
        return cell;
    }
    DetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.equArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}
- (IBAction)fanhui:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DetailTableViewCellValue1 * cell = [DetailTableViewCellValue1 cellWithTableView:tableView indexPatch:indexPath];
    if (self.house_id) {
        if (self.dataDic) {
            cell.titleLabel.text = self.dataDic[@"title"];
            cell.desLabel.text = self.dataDic[@"house_info"];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",self.dataDic[@"city"],self.dataDic[@"district"],self.dataDic[@"town"]];
            
            NSString * price = self.dataDic[@"house_price"];
            NSString * priceStr = [NSString stringWithFormat:@"¥%@/天",price];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:priceStr];
            NSRange range = [priceStr rangeOfString:price];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
            cell.priceLabel.attributedText = str;
        }
    } else {
        if (self.address) {
            cell.addressLabel.text = self.address;
        } else {
            cell.addressLabel.text = @"";
        }
        if (self.house_title) {
            cell.titleLabel.text = self.house_title;
        } else {
            cell.titleLabel.text = @"";
        }
        if (self.house_des) {
            cell.desLabel.text = self.house_des;
        } else {
            cell.desLabel.text = @"";
        }
        if (self.price) {
            NSString * priceStr = [NSString stringWithFormat:@"¥%@/天",_price];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:priceStr];
            NSRange range = [priceStr rangeOfString:_price];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
            cell.priceLabel.attributedText = str;
        } else {
            cell.priceLabel.text = @"";
        }
    }
    cell.pingjiaBtn.hidden = YES;
    cell.shoucangBtn.hidden = YES;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
@end
