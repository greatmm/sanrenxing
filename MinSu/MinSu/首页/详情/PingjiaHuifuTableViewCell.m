//
//  PingjiaHuifuTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/25.
//

#import "PingjiaHuifuTableViewCell.h"

@implementation PingjiaHuifuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)zanPingjia:(id)sender {
    if (self.clickZanbtnBlock) {
        self.clickZanbtnBlock();
    }
}

- (void)assignWithDic:(NSDictionary *)dic
{
    NSString * head_Pic = dic[@"head_pic"];
    if ([head_Pic isKindOfClass:[NSString class]]) {
        if (![head_Pic containsString:@"http"]) {
            head_Pic = [NSString stringWithFormat:@"%@%@",baseUrl,head_Pic];
        }
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:head_Pic] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    }
    if (dic[@"nickname"]) {
        self.nickName.text = dic[@"nickname"];
    } else {
        self.nickName.text = @"  ";
    }
    if (dic[@"add_time"]) {
        self.addTimeLabel.text = dic[@"add_time"];
    } else {
        self.addTimeLabel.text = @"  ";
    }
    if (dic[@"content"]) {
        self.pinglunLabel.text = dic[@"content"];
    } else {
        self.pinglunLabel.text = @"  ";
    }
    NSString * cCount = dic[@"c_count"];
    if (cCount == nil) {
        cCount = @"0";
    }
    [self.zanBtn setTitle:[NSString stringWithFormat:@"  %ld",cCount.integerValue] forState:UIControlStateNormal];
    NSString * u_coll = dic[@"u_coll"];
    if (u_coll.integerValue == 1) {
        [self.zanBtn setImage:[UIImage imageNamed:@"dianzan_sel"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
    } else {
        [self.zanBtn setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:k102Color forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
