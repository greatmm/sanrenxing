//
//  ChatRecordTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "ChatRecordTableViewCell.h"

@implementation ChatRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)assignWithDic:(NSDictionary *)dic
{
    NSString * head_pic = dic[@"head_pic"];
    if (head_pic && [head_pic isKindOfClass:[NSString class]]) {
        if ([head_pic containsString:@"http"]) {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:head_pic] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        } else {
           [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,head_pic]] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        }
    } else {
        self.headerImageView.image = [UIImage imageNamed:@"default_icon"];
    }
    if (dic[@"nickname"]) {
        self.nickNameLabel.text = dic[@"nickname"];
    } else {
        self.nickNameLabel.text = @"";
    }
    if (dic[@"add_time"]) {
        self.timeLabel.text = dic[@"add_time"];
    } else {
        self.timeLabel.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
