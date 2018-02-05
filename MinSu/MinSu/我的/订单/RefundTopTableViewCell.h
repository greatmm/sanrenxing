//
//  RefundTopTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "KKBaseTableViewCell.h"

@interface RefundTopTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (void)assignWithDic:(NSDictionary *)dic;
@end
