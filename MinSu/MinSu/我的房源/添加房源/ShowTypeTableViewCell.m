//
//  ShowTypeTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "ShowTypeTableViewCell.h"

@implementation ShowTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickBtn:(id)sender {
    self.btn.selected = !self.btn.selected;
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
