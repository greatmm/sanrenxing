//
//  ShouzhiTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/24.
//

#import "KKBaseTableViewCell.h"

@interface ShouzhiTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
