//
//  AddressSelectView.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import "AddressSelectView.h"
#import "SelectTypeTableViewCell.h"

@interface AddressSelectView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;

@property(strong,nonatomic)UIButton * preBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign,nonatomic)NSInteger selIndex;//要选择哪一级
@property(assign,nonatomic)NSInteger pIndex;
@property(assign,nonatomic)NSInteger cIndex;
@property(assign,nonatomic)NSInteger qIndex;
@property(assign,nonatomic)NSInteger sIndex;


@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,strong)NSArray * shiArr;//城市数组
@property(nonatomic,strong)NSArray *quArr;//区县数组
@property(nonatomic,strong)NSArray *streetArr;//街道数组
@end

@implementation AddressSelectView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selIndex = -1;
    self.pIndex = -1;
    self.cIndex = -1;
    self.qIndex = -1;
    self.sIndex = -1;
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss:nil];
}
+ (instancetype)shareAddressView
{
    AddressSelectView * selView = [[NSBundle mainBundle] loadNibNamed:@"AddressSelectView" owner:nil options:nil].firstObject;
    selView.tableView.tableFooterView = [UIView new];
    return selView;
}
- (IBAction)dismiss:(id)sender {
    if (self.superview) {
        [self removeFromSuperview];
    }
    if (self.ensureBlock) {
        NSMutableString * str = [NSMutableString new];
        if (self.pDic) {
            [str appendString:self.pDic[@"name"]];
        }
        if (self.cDic) {
            [str appendString:self.cDic[@"name"]];
        }
        if (self.qDic) {
            [str appendString:self.qDic[@"name"]];
        }
        if (self.sDic) {
            [str appendString:self.sDic[@"name"]];
        }
        self.ensureBlock(str);
    }
}
/*
 {
 id = 1;
 name = "\U5317\U4eac\U5e02";
 "parent_id" = 0;
 }
 */
- (IBAction)clickBtn:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    switch (btn.tag) {
        case 0:
            {
                self.dataArr = self.cityArr;
                if (self.pIndex != -1) {
                    indexPath = [NSIndexPath indexPathForRow:self.pIndex inSection:0];
                }
            }
            break;
        case 1:
        {
            if (nil == self.pDic) {
                [KKAlert showErrorHint:@"请先选择省份"];
                return;
            }
            if (self.shiArr) {
                self.dataArr = self.shiArr;
                if (self.cIndex != -1) {
                    indexPath = [NSIndexPath indexPathForRow:self.cIndex inSection:0];
                }
            } else {
                [self getCitys];
                return;
            }
        }
            break;
        case 2:
        {
            if (nil == self.pDic) {
                [KKAlert showErrorHint:@"请先选择省份"];
                return;
            }
            if (nil == self.cDic) {
                [KKAlert showErrorHint:@"请先选择市"];
                return;
            }
            if (self.quArr) {
                self.dataArr = self.quArr;
                if (self.qIndex != -1) {
                    indexPath = [NSIndexPath indexPathForRow:self.qIndex inSection:0];
                }
            } else {
                [self getAreas];
                return;
            }
        }
            break;
        case 3:
        {
            if (nil == self.pDic) {
                [KKAlert showErrorHint:@"请先选择省份"];                return;
            }
            if (nil == self.cDic) {
                [KKAlert showErrorHint:@"请先选择市"];
                return;
            }
            if (nil == self.qDic) {
                [KKAlert showErrorHint:@"请先选择区/县"];
                return;
            }
            if (self.streetArr) {
                self.dataArr = self.streetArr;
                if (self.sIndex != -1) {
                    indexPath = [NSIndexPath indexPathForRow:self.sIndex inSection:0];
                }
            } else {
                [self getStreets];
                return;
            }
        }
            break;
        default:
            break;
    }
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
    self.selIndex = btn.tag;
    [self.tableView reloadData];
    [self.tableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)getCitys
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getCityWithParm:@{@"token":[UserDefaults token],@"province":self.pDic[@"id"]} SuccessBlock:^(NSDictionary *dic) {
        NSNumber * code = dic[@"code"];
        [KKAlert dismiss];
        if (code.integerValue == 200) {
            NSArray * data = dic[@"data"];
            self.shiArr = data;
            [self clickBtn:self.btnArr[1]];
        } else {
            [KKAlert showErrorHint:@"获取数据失败"];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)getAreas
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getAreaWithParm:@{@"token":[UserDefaults token],@"city":self.cDic[@"id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * data = dic[@"data"];
            self.quArr = data;
            [self clickBtn:self.btnArr[2]];
        } else {
            [KKAlert showErrorHint:@"获取数据失败"];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}
- (void)getStreets
{
    [KKAlert showAnimateWithStauts:@"数据获取中"];
    [KKNetWork getStreetWithParm:@{@"token":[UserDefaults token],@"district":self.qDic[@"id"]} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSNumber * code = dic[@"code"];
        if (code.integerValue == 200) {
            NSArray * data = dic[@"data"];
            self.streetArr = data;
            [self clickBtn:self.btnArr[3]];
        } else {
            [KKAlert showErrorHint:@"获取数据失败"];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        [KKAlert showErrorHint:@"获取数据失败"];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTypeTableViewCell * cell = [SelectTypeTableViewCell cellWithTableView:tableView indexPatch:indexPath];
    NSDictionary * dic = self.dataArr[indexPath.row];
    cell.selectLabel.text = dic[@"name"];
    switch (self.selIndex) {
        case 0:
        {
            if (self.pIndex == -1) {
                cell.isSel = NO;
                break;
            }
            cell.isSel = (self.pIndex == indexPath.row);
        }
            break;
        case 1:
        {
            if (self.cIndex == -1) {
                cell.isSel = NO;
                break;
            }
            cell.isSel = (self.cIndex == indexPath.row);
        }
            break;
        case 2:
        {
            if (self.qIndex == -1) {
                cell.isSel = NO;
                break;
            }
            cell.isSel = (self.qIndex == indexPath.row);
        }
            break;
        case 3:
        {
            if (self.sIndex == -1) {
                cell.isSel = NO;
                break;
            }
            cell.isSel = (self.sIndex == indexPath.row);
        }
            break;
        default:
            break;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selIndex) {
        case 0:
        {
            if (self.pIndex == indexPath.row) {
                return;
            }
            self.pIndex = indexPath.row;
            self.pDic = self.cityArr[indexPath.row];
            UIButton * btn = self.btnArr[0];
            [btn setTitle:self.pDic[@"name"] forState:UIControlStateSelected];
            [btn setTitle:self.pDic[@"name"] forState:UIControlStateNormal];
            
            self.cIndex = -1;
            self.cDic = nil;
            UIButton * btn1 = self.btnArr[1];
            [btn1 setTitle:@"市" forState:UIControlStateNormal];
            [btn1 setTitle:@"市" forState:UIControlStateSelected];
            self.shiArr = nil;
            
            self.qIndex = -1;
            self.qDic = nil;
            UIButton * btn2 = self.btnArr[2];
            [btn2 setTitle:@"区/县" forState:UIControlStateNormal];
            [btn2 setTitle:@"区/县" forState:UIControlStateSelected];
            self.quArr = nil;
            
            self.sIndex = -1;
            self.sDic =  nil;
            UIButton * btn3 = self.btnArr[3];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateNormal];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateSelected];
            self.streetArr = nil;
        }
            break;
        case 1:
        {
            if (self.cIndex == indexPath.row) {
                return;
            }
            self.cIndex = indexPath.row;
            self.cDic = self.dataArr[indexPath.row];
            
            UIButton * btn1 = self.btnArr[1];
            [btn1 setTitle:self.cDic[@"name"] forState:UIControlStateNormal];
            [btn1 setTitle:self.cDic[@"name"] forState:UIControlStateSelected];
            
            self.qIndex = -1;
            self.qDic = nil;
            UIButton * btn2 = self.btnArr[2];
            [btn2 setTitle:@"区/县" forState:UIControlStateNormal];
            [btn2 setTitle:@"区/县" forState:UIControlStateSelected];
            self.quArr = nil;
            
            self.sIndex = -1;
            self.sDic =  nil;
            UIButton * btn3 = self.btnArr[3];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateNormal];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateSelected];
            self.streetArr = nil;
        }
            break;
        case 2:
        {
            if (self.qIndex == indexPath.row) {
                return;
            }
            self.qIndex = indexPath.row;
            self.qDic = self.dataArr[indexPath.row];
            UIButton * btn2 = self.btnArr[2];
            [btn2 setTitle:self.qDic[@"name"] forState:UIControlStateNormal];
            [btn2 setTitle:self.qDic[@"name"] forState:UIControlStateSelected];
            
            self.sIndex = -1;
            self.sDic =  nil;
            UIButton * btn3 = self.btnArr[3];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateNormal];
            [btn3 setTitle:@"街道/乡" forState:UIControlStateSelected];
            self.streetArr = nil;
        }
            break;
        case 3:
        {
            if (indexPath.row == self.sIndex) {
                return;
            }
            self.sIndex = indexPath.row;
            self.sDic = self.dataArr[indexPath.row];
            UIButton * btn3 = self.btnArr[3];
            [btn3 setTitle:self.sDic[@"name"] forState:UIControlStateNormal];
            [btn3 setTitle:self.sDic[@"name"] forState:UIControlStateSelected];
        }
            break;
        default:
            break;
    }
    [tableView reloadData];
}


@end
