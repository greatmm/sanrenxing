//
//  SystemMessageTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "KKBaseTableViewCell.h"

@interface SystemMessageTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
