//
//  HousePingjiaTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/22.
//

#import "KKBaseTableViewCell.h"

@interface HousePingjiaTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pingjiaBtn;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;
- (void)assignWithDic:(NSDictionary *)dic;
@end
