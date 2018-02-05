//
//  SearchCityView.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/15.
//

#import "SearchCityView.h"


@interface SearchCityView()
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hisHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotHeightCons;
@end

@implementation SearchCityView
- (void)setHotCityArr:(NSArray *)hotCityArr
{
    if (_hotCityArr != hotCityArr) {
        _hotCityArr = hotCityArr;
        [self refreshHotView];
    }
}
- (void)refreshHotView
{
    [self.hotView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = 15;
    CGFloat y = 5;
    CGFloat h = 30;
    NSInteger count = self.hotCityArr.count;
    for (int i = 0; i < count; i ++) {
        NSDictionary * dic = self.hotCityArr[i];
        NSString * name = dic[@"name"];
        CGFloat w = [name getWidthWithFontSize:14];
        if (x + w + 31 > ScreenWidth) {
            x = 15;
            y += 35;
        }
        UIButton * btn = [self btnWithTitle:name];
        btn.frame = CGRectMake(x, y, w + 16, h);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickHotBtn:) forControlEvents:UIControlEventTouchUpInside];
        x += w + 31;
        [self.hotView addSubview:btn];
    }
    CGRect frame = self.frame;
    if (count) {
        self.hotHeightCons.constant = y + 35;
        frame.size.height = 100 + self.hisHeightCons.constant + y + 35;
    } else {
        self.hotHeightCons.constant = y;
        frame.size.height = 100 + self.hisHeightCons.constant + y;
    }
    self.frame = frame;
    [self layoutIfNeeded];
}
- (void)setHistoryCityArr:(NSArray *)historyCityArr
{
    if (_historyCityArr != historyCityArr) {
        _historyCityArr = historyCityArr;
        [self refreshHistoryView];
    }
}
- (void)refreshHistoryView
{
    [self.historyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = 15;
    CGFloat y = 5;
    CGFloat h = 30;
    NSInteger count = self.historyCityArr.count;
    for (int i = 0; i < count; i ++) {
        NSDictionary * dic = self.historyCityArr[i];
        NSString * name = dic[@"name"];
        CGFloat w = [name getWidthWithFontSize:14];
        if (x + w + 31 > ScreenWidth) {
            x = 15;
            y += 35;
        }
        UIButton * btn = [self btnWithTitle:name];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickHisBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(x, y, w + 16, h);
        x += w + 31;
        [self.historyView addSubview:btn];
    }
    
    CGRect frame = self.frame;
    if (count) {
        self.hisHeightCons.constant = y + 35;
        frame.size.height = 100 + y + 35 + self.hotHeightCons.constant;
        
    } else {
        self.hisHeightCons.constant = y;
        frame.size.height = 100 + y + self.hotHeightCons.constant;
    }
    self.frame = frame;
    [self layoutIfNeeded];
}
- (void)clickHotBtn:(UIButton *)btn
{
    NSDictionary * dict = self.hotCityArr[btn.tag];
    /*{
     "c_num" = 4;
     "city_id" = 2629;
     name = "\U6ca7\U5dde\U5e02";
     }
     */
    if (self.clickBtnBlock) {
        self.clickBtnBlock(dict);
    }
}
- (void)clickHisBtn:(UIButton *)btn
{
    NSDictionary * dict = self.historyCityArr[btn.tag];
    if (self.clickBtnBlock) {
        self.clickBtnBlock(dict);
    }
}
- (UIButton *)btnWithTitle:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithWhite:40/255.0 alpha:1] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 15;
    btn.layer.borderColor = k153Color.CGColor;
    btn.layer.borderWidth  = 0.5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}
@end
