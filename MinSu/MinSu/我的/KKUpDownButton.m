//
//  KKUpDownButton.m
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "KKUpDownButton.h"

@implementation KKUpDownButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGSize imageSize = self.imageView.frame.size;
    self.imageView.frame = CGRectMake(frame.size.width * 0.5 - imageSize.width * 0.5, 11 - imageSize.height/2, imageSize.width, imageSize.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 8, frame.size.width, 15);
}

@end
