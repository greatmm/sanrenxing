//
//  KKBaseTableViewCell.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "KKBaseTableViewCell.h"

@implementation KKBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)cellWithTableView:(UITableView *)tableView indexPatch:(NSIndexPath *)indexPath
{
    NSString * identifier = NSStringFromClass([self class]);
    KKBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil].firstObject;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
