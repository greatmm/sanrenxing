//
//  BankCardTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/23.
//

#import "KKBaseTableViewCell.h"

@interface BankCardTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;

@end
