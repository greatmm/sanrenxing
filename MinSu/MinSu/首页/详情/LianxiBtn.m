//
//  LianxiBtn.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import "LianxiBtn.h"

@implementation LianxiBtn
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    self.imageView.frame = CGRectMake(frame.size.width * 0.5 - 11.5, 0, 23, 23);
    self.titleLabel.frame = CGRectMake(0, 28, frame.size.width, 18);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = k153Color;
}


@end
