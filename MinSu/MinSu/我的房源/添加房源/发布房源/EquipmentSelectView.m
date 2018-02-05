//
//  EquipmentSelectView.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import "EquipmentSelectView.h"
#import "EquipmentSelectCollectionViewCell.h"

@interface EquipmentSelectView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic,strong) NSArray * dataArr;

@end
@implementation EquipmentSelectView
+ (instancetype)shareEquView
{
    EquipmentSelectView * selView = [[NSBundle mainBundle] loadNibNamed:@"EquipmentSelectView" owner:nil options:nil].lastObject;
    return selView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataArr = @[@{@"eId":@"1",@"title":@"标准间",@"imageName":@"biaozhunjian"},@{@"eId":@"2",@"title":@"大床间",@"imageName":@"dachuangjian"},@{@"eId":@"3",@"title":@"家庭房",@"imageName":@"jiatingfang"},@{@"eId":@"4",@"title":@"24小时热水",@"imageName":@"hotwater"},@{@"eId":@"5",@"title":@"电视",@"imageName":@"tv"},@{@"eId":@"6",@"title":@"空调",@"imageName":@"kongtiao"},@{@"eId":@"7",@"title":@"整租",@"imageName":@"zhengzu"},@{@"eId":@"8",@"title":@"单间",@"imageName":@"danzu"},@{@"eId":@"9",@"title":@"wifi",@"imageName":@"wifi"},@{@"eId":@"10",@"title":@"三人行礼包",@"imageName":@"sanrenxing"},@{@"eId":@"13",@"title":@"停车场",@"imageName":@"tingchechang"},@{@"eId":@"11",@"title":@"娱乐设施",@"imageName":@"game"},@{@"eId":@"12",@"title":@"周边景点",@"imageName":@"jingdian"}];
    [self.cv registerNib:[UINib nibWithNibName:@"EquipmentSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EquipmentSelectCollectionViewCell"];
}
- (NSMutableArray *)selDataArr
{
    if (_selDataArr) {
        return _selDataArr;
    }
    _selDataArr = [NSMutableArray new];
    return _selDataArr;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
- (IBAction)cancel:(id)sender {
    [self dismiss];
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
- (void)dismiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EquipmentSelectCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"EquipmentSelectCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArr[indexPath.row];
    cell.dic = dic;
    [cell assignWithDic:dic];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat margin = (ScreenWidth - 280) * 0.2;
    return UIEdgeInsetsMake(0, margin, 0, margin);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentSelectCollectionViewCell * cell = (EquipmentSelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.select = !cell.select;
    NSDictionary * dic = self.dataArr[indexPath.row];
    if (cell.select) {
        [self.selDataArr addObject:dic];
        [self.selDataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSDictionary * dic1 = obj1;
            NSDictionary * dic2 = obj2;
            NSString * n1 = dic1[@"eId"];
            NSString * n2 = dic2[@"eId"];
            return n1.integerValue - n2.integerValue;
        }];
    } else {
        if ([self.selDataArr containsObject:dic]) {
            [self.selDataArr removeObject:dic];
        }
    }
    kkWeakSelf
    if (self.selBlock) {
        self.selBlock(weakSelf.selDataArr);
    }
    
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}


@end
