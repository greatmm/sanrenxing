//
//  CouponTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "KKBaseTableViewCell.h"

@interface CouponTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property(nonatomic,strong)void(^getBlock)(void);
@property(nonatomic,assign)BOOL isMine;
- (void)assignWithDic:(NSDictionary *)dict;
@end
