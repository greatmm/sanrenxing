//
//  OrderHIntTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/8.
//

#import "KKBaseTableViewCell.h"

@interface OrderHIntTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end
