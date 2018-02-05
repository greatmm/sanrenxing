//
//  KKHouseShowTableViewCell.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "KKHouseShowTableViewCell.h"


@interface KKHouseShowTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *desLabel;//描述

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//地址
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;//是否收藏

@end

@implementation KKHouseShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)clickCollectionBtn:(id)sender {
    if (self.collectBlock) {
        self.collectBlock();
    }
}

- (void)setIsLike:(BOOL)isLike
{
    _isLike = isLike;
    if (_isLike) {
        self.likeBtn.hidden = NO;
        self.likeBtn.selected = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)assignWithDic:(NSDictionary *)dic
{
    NSNumber * collect = dic[@"collect"];
    if (collect == nil) {
        self.likeBtn.hidden = YES;
    } else {
        self.likeBtn.hidden = NO;
        self.likeBtn.selected = collect.integerValue;
    }
    if (dic[@"title"]) {
        self.titleLabel.text = dic[@"title"];
    } else {
        self.titleLabel.text = @"";
    }
    if (dic[@"house_info"]) {
        self.desLabel.text = dic[@"house_info"];
    } else {
        self.desLabel.text = @"";
    }
    if (dic[@"house_price"]) {
        NSString * price = dic[@"house_price"];
        NSString * priceStr = [NSString stringWithFormat:@"¥%@/天",price];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:priceStr];
        NSRange range = [priceStr rangeOfString:price];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
        self.priceLabel.attributedText = str;
        
    } else {
        self.priceLabel.text = @"";
    }
    NSString * province = dic[@"province"];
    NSString * city = dic[@"city"];
    NSString * district = dic[@"district"];
    NSString * town = dic[@"town"];
    NSString * address = [NSString stringWithFormat:@"%@%@%@%@",province,city,district,town];
    self.locationLabel.text = address;
    if (dic[@"house_img"] && [dic[@"house_img"] isKindOfClass:[NSString class]]) {
        [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,dic[@"house_img"]]]];
    }
   /*
    {
    city = "\U957f\U6cbb\U5e02";
    district = "\U8944\U57a3\U53bf";
    "house_id" = 5;
    "house_img" = "/Uploads/Images/2018-01-03/5a4c53be1bb21.png";
    "house_info" = "vbn\U5476\U5476\U5527\U5527\U767d\U767d\U5ae9\U5ae9\U4e70";
    "house_price" = 100;
    province = "\U5c71\U897f\U7701";
    title = "\U53d1\U5e03\U623f\U6e90";
    town = "\U897f\U8425\U9547";
    }
    */
}
@end
