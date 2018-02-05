//
//  RefundTopTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "RefundTopTableViewCell.h"

@implementation RefundTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)assignWithDic:(NSDictionary *)dic
{
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,dic[@"house_img"]]]];
    self.titleLabel.text = dic[@"title"];
    self.desLabel.text = dic[@"house_info"];
    self.checkInLabel.text = dic[@"check_time"];
    self.leaveLabel.text = dic[@"leave_time"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",dic[@"city"],dic[@"district"],dic[@"town"]];
    self.totalTimeLabel.text = [NSString stringWithFormat:@"共%@晚",dic[@"days"]];
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号:%@",dic[@"order_sn"]];
    /*
     {
     "check_time" = "2018-01-26";
     city = "\U672c\U6eaa\U5e02";
     days = 1;
     district = "\U5e73\U5c71\U533a";
     "house_img" = "/Uploads/Images/2018-01-03/5a4c576fafec5.png";
     "house_info" = "\U4fbf\U5b9c\U53c8\U5b9e\U60e0";
     "leave_time" = "2018-01-27";
     "order_sn" = fy201801181350215584;
     province = "\U8fbd\U5b81\U7701";
     title = "\U53d1\U5e03\U623f\U6e90";
     town = "\U7ad9\U524d\U8857\U9053";
     };
     */
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
