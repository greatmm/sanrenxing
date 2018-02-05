//
//  KKInputTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "KKBaseTableViewCell.h"

@interface KKInputTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) void(^textBlock)(NSString *text);
@end
