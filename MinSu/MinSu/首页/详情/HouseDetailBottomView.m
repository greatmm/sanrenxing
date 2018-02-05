//
//  HouseDetailBottomView.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import "HouseDetailBottomView.h"

@implementation HouseDetailBottomView
- (IBAction)bookRoom:(id)sender {
    if (self.bookBlock) {
        self.bookBlock();
    }
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, ScreenWidth, 50);
//}

@end
