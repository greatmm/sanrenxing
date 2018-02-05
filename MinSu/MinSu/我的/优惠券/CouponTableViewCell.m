//
//  CouponTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "CouponTableViewCell.h"


@interface CouponTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end

@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)assignWithDic:(NSDictionary *)dict
{
    if (self.isMine) {
        self.getBtn.hidden = YES;
    }
    self.infoLabel.text = dict[@"info"];
    NSString * dateStr = [NSString stringWithFormat:@"有效期:%@至%@",dict[@"start_time"],dict[@"end_time"]];
    self.dateLabel.text = dateStr;
    NSNumber * p = dict[@"price"];
    NSString * price = p.stringValue;
    NSString * priceStr = [NSString stringWithFormat:@"¥%@",price];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range = [priceStr rangeOfString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:range];
    self.priceLabel.attributedText = str;
    
    NSString * isType = dict[@"is_type"];
    if (self.isMine) {
        if (isType.integerValue == 0) {
            self.countLabel.text = @"状态:有效";
            self.countLabel.textColor = [UIColor blackColor];
        } else {
            self.countLabel.text = @"状态:已过期";
            self.countLabel.textColor = k102Color;
        }
        return;
    }
    NSString * numStr = [NSString stringWithFormat:@"共%@张,已领取%@张",dict[@"sum"],dict[@"get_num"]];
    self.countLabel.text = numStr;
    if (isType.integerValue == 0) {
        self.getBtn.userInteractionEnabled = YES;
        [self.getBtn setTitle:@"领取" forState:UIControlStateNormal];
    } else {
        self.getBtn.userInteractionEnabled = NO;
        [self.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
    }
}
- (IBAction)clickGetBtn:(id)sender {
    if (self.getBlock) {
        self.getBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
