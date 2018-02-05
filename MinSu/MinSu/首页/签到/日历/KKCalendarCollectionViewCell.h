//
//  KKCalendarCollectionViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import <UIKit/UIKit.h>

@interface KKCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) NSString * style;//0,1,2 0表示只显示日期,1表示需要显示签到图标,2表示入住日期,3表示在入住与离开日期之间,4表示离开日期
@property(nonatomic,strong) UILabel * stateLabel;//入住退房离开
@property(nonatomic,strong) UILabel * priceLabel;//价格label

@end
