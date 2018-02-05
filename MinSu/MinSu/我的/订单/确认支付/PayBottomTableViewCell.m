//
//  PayBottomTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "PayBottomTableViewCell.h"

@implementation PayBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickCycleBtn:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
