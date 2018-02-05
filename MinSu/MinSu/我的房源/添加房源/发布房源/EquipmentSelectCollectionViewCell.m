//
//  EquipmentSelectCollectionViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import "EquipmentSelectCollectionViewCell.h"


@interface EquipmentSelectCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation EquipmentSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithWhite:102/255.0 alpha:1].CGColor;
}
- (void)setSelect:(BOOL)select
{
    _select = select;
    if (_select) {
       self.backView.layer.borderColor = [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0 alpha:1].CGColor;
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",self.dic[@"imageName"]]];
        self.label.textColor = [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0 alpha:1];
    } else {
       self.backView.layer.borderColor = [UIColor colorWithWhite:102/255.0 alpha:1].CGColor;
        self.imageView.image = [UIImage imageNamed:self.dic[@"imageName"]];
        self.label.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
    }
}
- (void)assignWithDic:(NSDictionary *)dic
{
    self.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    self.label.text = dic[@"title"];
}

@end
