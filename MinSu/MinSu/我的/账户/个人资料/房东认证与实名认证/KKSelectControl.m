//
//  KKSelectControl.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "KKSelectControl.h"

@implementation KKSelectControl
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.5 - 60, 0, 120, 80)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, frame.size.width, frame.size.height - 105)];
        self.label.textColor = k102Color;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}
@end
