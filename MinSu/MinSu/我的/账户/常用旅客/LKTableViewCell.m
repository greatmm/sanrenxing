//
//  LKTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "LKTableViewCell.h"

@implementation LKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickDeleteBtn:(id)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}
- (IBAction)clickEditBtn:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}
- (void)assignWithDic:(NSDictionary *)dic
{
    self.nameLabel.text = dic[@"name"];
    self.styleLabel.text = dic[@"lk_type"];
    NSString * zjcode = dic[@"zj_code"];
    self.idCardLabel.text = [NSString stringWithFormat:@"%@********%@",[zjcode substringWithRange:NSMakeRange(0, 6)],[zjcode substringFromIndex:zjcode.length - 4]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
