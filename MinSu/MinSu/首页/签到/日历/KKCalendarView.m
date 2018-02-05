//
//  KKCalendarView.m
//  日历
//
//  Created by 竹叶 on 2017/12/7.
//  Copyright © 2017年 竹叶. All rights reserved.
//

#import "KKCalendarView.h"
#import "KKUtils.h"
#import "KKCalendarCollectionViewCell.h"

@interface KKCalendarView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (nonatomic,strong) NSMutableArray <KKCalendarItemView *>* itemArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger days;//本月有多少天
@property (nonatomic,assign) NSInteger daysBefore;//上月有几天
@property (nonatomic,strong) NSMutableArray * signDays;//存储当月签到的日期
@property (nonatomic,strong) NSMutableArray  * selectDateArr;//选择日期字典
@property (nonatomic,strong) NSDate * preDate;//上次选中的日期
@end

@implementation KKCalendarView
//传过来签到的日期,根据字符串计算出年月日,比较当前年月,如果一致,存储日期,标记已签到
- (void)setSignInDateArr:(NSArray *)signInDateArr
{
    if (_signInDateArr == signInDateArr) {
        return;
    }
    _signInDateArr = signInDateArr;
    [self signDate];
}
-(NSMutableArray *)selectDateArr
{
    if (_selectDateArr == nil) {
        _selectDateArr = [NSMutableArray new];
    }
    return _selectDateArr;
}
//标记哪些日期签到过
- (void)signDate
{
    if (!(_signInDateArr && _signInDateArr.count)) {
        return;
    }
    NSMutableArray * signDays = [NSMutableArray new];
    NSLog(@"%@",self.signInDateArr);
    for (NSDictionary * dic in self.signInDateArr) {
        NSString * sign_time = dic[@"sign_time"];
        NSLog(@"%@",sign_time);
        NSArray * arr = [sign_time componentsSeparatedByString:@"-"];
        if (arr.count != 3) {
            continue;
        }
        NSString * year = arr[0];
        NSInteger nowYear = [KKUtils getYearWithDate:self.date];

        if (year.integerValue < nowYear) {
            break;
        }
        if (year.integerValue > nowYear) {
            continue;
        }
        NSString * month = arr[1];
        NSInteger nowMonth = [KKUtils getMonthWithDate:self.date];
        if (month.integerValue < nowMonth) {
            break;
        }
        if (month.integerValue >  nowMonth) {
            continue;
        }
        NSString * day = arr[2];
        if (day.integerValue < 10) {
            day = [day substringFromIndex:day.length - 1];
        }
        [signDays addObject:day];
    }
    self.signDays = signDays;
    [self.collectionView reloadData];
}
- (IBAction)preMonth:(id)sender {
    if (_signDays) {
        _signDays = nil;
    }
    self.date = [KKUtils preMonthWithDate:self.date];
}
- (IBAction)nextMonth:(id)sender {
    if (_signDays) {
        _signDays = nil;
    }
    self.date = [KKUtils nextMonthWithDate:self.date];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KKCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KKCalendarCollectionViewCell"];
    self.date = [NSDate date];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.width = ScreenWidth;
    self.frame = frame;
}
+ (instancetype)shareCalendarView
{
    KKCalendarView * calenView = [[NSBundle mainBundle] loadNibNamed:@"KKCalendarView" owner:nil options:nil].firstObject;
    return calenView;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.dateLabel.text = [KKUtils dateStringFromDate:_date];
    self.daysBefore = [KKUtils firstWeekdayInMonthOfDate:date]%7;//第一行前边有几个
    self.days = [KKUtils daysInMonthOfDate:date];
    if (self.signInDateArr&&self.signInDateArr.count) {
        [self signDate];
        return;
    }
     [self.collectionView reloadData];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    KKCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKCalendarCollectionViewCell" forIndexPath:indexPath];
    cell.style = @"0";
    if (self.isHouse) {
        if (indexPath.row < self.daysBefore) {
            cell.dateLabel.text = @"";
        } else {
            NSInteger day = indexPath.row - self.daysBefore + 1;
            NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
            cell.dateLabel.text = dayStr;
            NSInteger count = self.selectDateArr.count;
            NSString  * dateStr = [NSString stringWithFormat:@"%@%ld日",self.dateLabel.text,day];
            switch (count) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    NSDate * date = [KKUtils stringToDate:dateStr withFormat:@"yyyy年MM月dd日"];
                    NSDate * first  = self.selectDateArr.firstObject;
                    if ([date compare:first] == NSOrderedSame) {
                        if (self.price) {
                            cell.priceLabel.text = self.price;
                        }
                        cell.dateLabel.text = @"";
                        cell.style = @"2";
                    }
                }
                    break;
                default:
                {
                    NSDate * date = [KKUtils stringToDate:dateStr withFormat:@"yyyy年MM月dd日"];
                    NSDate * first = self.selectDateArr.firstObject;
                    NSComparisonResult r1 = [date compare:first];
                    NSDate * last = self.selectDateArr.lastObject;
                    NSComparisonResult r2 = [date compare:last];
                    if (r1 == NSOrderedSame) {
                        cell.dateLabel.text = @"";
                        cell.style = @"2";
                        if (self.price) {
                            cell.priceLabel.text = self.price;
                        }
                    }
                    if ((r1 == NSOrderedDescending) && (r2 == NSOrderedAscending)) {
                        cell.dateLabel.text = @"";
                        cell.stateLabel.text = dayStr;
                        cell.style = @"3";
                        if (self.price) {
                            cell.priceLabel.text = self.price;
                        }
                    }
                    if (r2 == NSOrderedSame) {
                        cell.dateLabel.text = @"";
                        cell.style = @"4";
                        if (self.price) {
                            cell.priceLabel.text = self.price;
                        }
                    }
                }
                    break;
            }
        }
        return cell;
    }
    

    if (indexPath.row < self.daysBefore) {
        cell.dateLabel.text = @"";
    } else {
        NSInteger day = indexPath.row - self.daysBefore + 1;
        NSString * dayStr = [NSString stringWithFormat:@"%ld",(long)day];
        if (self.signDays && self.signDays.count) {
            if ([self.signDays containsObject:dayStr]) {
                cell.style = @"1";
            }
        }
        cell.dateLabel.text = dayStr;
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.days + self.daysBefore;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/7, 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isHouse == NO) {
        //签到控件返回
        return;
    }
    if (indexPath.row < self.daysBefore) {
        return;
    }
    NSInteger day = indexPath.row - self.daysBefore + 1;//几号
    //@"yyyy-MM-dd"@"yyyy年MM月dd日"
    NSString  * dateStr = [NSString stringWithFormat:@"%@%ld日",self.dateLabel.text,day];
    KKLog(@"%@",dateStr);
    NSDate * selDate = [KKUtils stringToDate:dateStr withFormat:@"yyyy年MM月dd日"];
    NSDate * today = [NSDate date];
    NSComparisonResult result = [selDate compare:today];
    if (result == NSOrderedAscending) {
        if (![KKUtils isTodayWithDate:selDate]) {
            [KKAlert showErrorHint:@"选择的日期不能早于今天"];
            return;
        }
    }
    [self addNewDate:selDate];
}
- (void)addNewDate:(NSDate *)date
{
    NSInteger count = self.selectDateArr.count;
    if (count == 0) {
        [self.selectDateArr addObject:date];
        self.preDate = date;
        [self updateUI];
        return;
    }
    NSComparisonResult result = [date compare:self.preDate];
    if (result == NSOrderedSame) {
        return;
    }
    [self.selectDateArr removeAllObjects];
    if (result == NSOrderedDescending) {
        [self.selectDateArr addObject:self.preDate];
        [self.selectDateArr addObject:date];
        self.preDate = date;
    } else {
        [self.selectDateArr addObject:date];
        [self.selectDateArr addObject:self.preDate];
        self.preDate = date;
    };
    [self updateUI];
}
- (void)updateUI
{
    [self.collectionView reloadData];
    kkWeakSelf
    if (self.selectDateBlock) {
        self.selectDateBlock(weakSelf.selectDateArr);
    }
}
@end
