//
//  SelectTypeTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "KKBaseTableViewCell.h"

@interface SelectTypeTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;//label
@property (assign,nonatomic) BOOL isSel;
@end
