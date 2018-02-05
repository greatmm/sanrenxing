//
//  PayBottomTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "KKBaseTableViewCell.h"

@interface PayBottomTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cycleBtn;
@property (nonatomic,strong)void(^selectBlock)(void);
@end
