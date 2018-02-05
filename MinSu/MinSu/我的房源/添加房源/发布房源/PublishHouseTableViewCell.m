//
//  PublishHouseTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "PublishHouseTableViewCell.h"

@implementation PublishHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
