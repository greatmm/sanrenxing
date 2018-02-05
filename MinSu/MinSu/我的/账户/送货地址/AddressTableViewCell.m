//
//  AddressTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *morenBtn;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)assignWithDic:(NSDictionary *)dic
{
    NSString * is_default = dic[@"is_default"];
    if (is_default.integerValue) {
        self.morenBtn.selected = YES;
        self.morenBtn.userInteractionEnabled = NO;
    } else {
        self.morenBtn.selected = NO;
        self.morenBtn.userInteractionEnabled = YES;
    }
    NSString * mobile = dic[@"mobile"];
    if (mobile && mobile.length == 11) {
        NSMutableString * phoneNunber = mobile.mutableCopy;
        [phoneNunber replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneLabel.text = phoneNunber;
    } else  {
        self.phoneLabel.text = @"";
    }
    NSString * name = dic[@"name"];
    if (name) {
        self.nameLabel.text = name;
    } else {
        self.nameLabel.text = @"";
    }
    if (dic[@"address"]) {
        self.addressLabel.text = dic[@"address"];
    } else {
        self.addressLabel.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickDefaultBtn:(id)sender {
    if (self.morenBlock) {
        self.morenBlock();
    }
}
- (IBAction)clickDelBtn:(id)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}
- (IBAction)clickEditBtn:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

@end
