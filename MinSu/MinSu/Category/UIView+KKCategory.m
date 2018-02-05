//
//  UIView+KKCategory.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import "UIView+KKCategory.h"

@implementation UIView (KKCategory)

@dynamic borderC,borderW,cornerR;
//- (void)setKk_height:(CGFloat)kk_height
//{
//    CGRect rect = self.frame;
//    rect.size.height = kk_height;
//    self.frame = rect;
//}
//
//- (CGFloat)kk_height
//{
//    return self.frame.size.height;
//}
//
//- (CGFloat)kk_width
//{
//    return self.frame.size.width;
//}
//- (void)setKk_width:(CGFloat)kk_width
//{
//    CGRect rect = self.frame;
//    rect.size.width = kk_width;
//    self.frame = rect;
//}
//
//- (CGFloat)kk_x
//{
//    return self.frame.origin.x;
//
//}
//
//- (void)setKk_x:(CGFloat)kk_x
//{
//    CGRect rect = self.frame;
//    rect.origin.x = kk_x;
//    self.frame = rect;
//}
//
//- (void)setKk_y:(CGFloat)kk_y
//{
//    CGRect rect = self.frame;
//    rect.origin.y = kk_y;
//    self.frame = rect;
//}
//
//- (CGFloat)kk_y
//{
//
//    return self.frame.origin.y;
//}
//
//- (void)setKk_centerX:(CGFloat)kk_centerX
//{
//    CGPoint center = self.center;
//    center.x = kk_centerX;
//    self.center = center;
//}
//
//- (CGFloat)kk_centerX
//{
//    return self.center.x;
//}
//
//- (void)setKk_centerY:(CGFloat)kk_centerY
//{
//    CGPoint center = self.center;
//    center.y = kk_centerY;
//    self.center = center;
//}
//
//- (CGFloat)kk_centerY
//{
//    return self.center.y;
//}
- (void)setBorderW:(CGFloat)borderW{
    self.layer.borderWidth = borderW;
}

- (void)setCornerR:(CGFloat)cornerR{
    self.layer.cornerRadius = cornerR;
    self.layer.masksToBounds = YES;
}

- (void)setBorderC:(UIColor *)borderC{
    self.layer.borderColor = borderC.CGColor;
}
- (UIViewController *)viewController
{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    return object;
}
@end
