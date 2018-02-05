//
//  UIView+KKCategory.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/5.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE

@interface UIView (KKCategory)

//@property CGFloat kk_width;
//@property CGFloat kk_height;
//@property CGFloat kk_x;
//@property CGFloat kk_y;
//@property CGFloat kk_centerX;
//@property CGFloat kk_centerY;

@property (nonatomic, assign) IBInspectable CGFloat borderW;
@property (nonatomic, assign) IBInspectable CGFloat cornerR;
@property (nonatomic, strong) IBInspectable UIColor * borderC;
//@property (nonatomic, assign) IBInspectable NSInteger setMainColor;
- (UIViewController *)viewController;
@end
