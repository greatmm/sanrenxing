//
//  ShowTypeTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "KKBaseTableViewCell.h"

@interface ShowTypeTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) void(^clickBtnBlock)(void);
@end
