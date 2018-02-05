//
//  PingjiaHuifuTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "KKBaseTableViewCell.h"

@interface PingjiaHuifuTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *pinglunLabel;
@property (nonatomic,strong) void(^clickZanbtnBlock)(void);
- (void)assignWithDic:(NSDictionary *)dic;
@end
