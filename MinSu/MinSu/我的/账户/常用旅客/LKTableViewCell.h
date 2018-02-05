//
//  LKTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "KKBaseTableViewCell.h"

@interface LKTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property(nonatomic,strong) void(^editBlock)(void);
@property(nonatomic,strong) void(^delBlock)(void);

- (void)assignWithDic:(NSDictionary *)dic;
@end
