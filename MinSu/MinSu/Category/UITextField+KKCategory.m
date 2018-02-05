//
//  UITextField+KKCategory.m
//  EasyToWork
//
//  Created by GKK on 2017/12/23.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "UITextField+KKCategory.h"

@implementation UITextField (KKCategory)

- (void)addLeftViewWithImagename:(NSString *)imageName
{
    UIView * leftView = [UIView new];
    leftView.frame = CGRectMake(0, 0, 28, CGRectGetHeight(self.frame));
    UIImageView * imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, 0, 18,CGRectGetHeight(self.frame));
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:imageView];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
