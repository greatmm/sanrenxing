//
//  ChatRecordTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "KKBaseTableViewCell.h"

@interface ChatRecordTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

- (void)assignWithDic:(NSDictionary *)dic;
@end
