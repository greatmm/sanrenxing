

//
//  KKCalendarCollectionViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import "KKCalendarCollectionViewCell.h"


@interface KKCalendarCollectionViewCell()
@property(nonatomic,strong) UIImageView * signImageView;
@property(nonatomic,strong) UIView * backView;
@end

@implementation KKCalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//背景色
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0 alpha:1];
        CGFloat width = MIN(60, CGRectGetWidth(self.bounds));
        _backView.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5 - width * 0.5, CGRectGetHeight(self.bounds) * 0.5 - width * 0.5, width, width);
        _backView.layer.cornerRadius = width * 0.5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)stateLabel
{
    if (_stateLabel == nil) {
        _stateLabel = [UILabel new];
        _stateLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) * 0.5  - 20, CGRectGetWidth(self.bounds), 20);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}
- (UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        _priceLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) * 0.5, CGRectGetWidth(self.bounds), 20);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.text = @"¥0";
    }
    return _priceLabel;
}

//签到图片
- (UIImageView *)signImageView
{
    if (_signImageView) {
        return _signImageView;
    }
    _signImageView = [UIImageView new];
    _signImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.5 - 14, CGRectGetHeight(self.bounds) * 0.5 - 12, 28, 24);
    _signImageView.image = [UIImage imageNamed:@"signin"];
    _signImageView.backgroundColor = [UIColor whiteColor];
    return _signImageView;
}

- (void)setStyle:(NSString *)style
{
    if (_style == style) {
        return;
    }
    _style = style;
    NSInteger flag = _style.integerValue;
    switch (flag) {
        case 0:
            {
                if (_signImageView) {
                    [_signImageView removeFromSuperview];
                    _signImageView = nil;
                }
                if (_backView) {
                    [_backView removeFromSuperview];
                }
                if (_priceLabel) {
                    [_priceLabel removeFromSuperview];
                }
                if (_stateLabel) {
                    [_stateLabel removeFromSuperview];
                }
            }
            break;
        case 1:
        {
            [self.contentView addSubview:self.signImageView];
        }
            break;
        case 2:
        {
            [self.contentView addSubview:self.backView];
            [self.contentView addSubview:self.stateLabel];
            self.stateLabel.font = [UIFont systemFontOfSize:14];
            self.stateLabel.text = @"入住";
            self.stateLabel.textColor = [UIColor whiteColor];
            [self.contentView addSubview:self.priceLabel];
            self.priceLabel.textColor = [UIColor whiteColor];
        }
            break;
        case 3:
        {
            if (_backView) {
                [_backView removeFromSuperview];
            }
            [self.contentView addSubview:self.stateLabel];
            self.stateLabel.font = [UIFont systemFontOfSize:12];
            self.stateLabel.textColor = k102Color;
            [self.contentView addSubview:self.priceLabel];
            self.priceLabel.textColor = [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0 alpha:1];
        }
            break;
        case 4:
        {
            [self.contentView addSubview:self.backView];
            [self.contentView addSubview:self.stateLabel];
            self.stateLabel.font = [UIFont systemFontOfSize:14];
            self.stateLabel.text = @"退房";
            self.stateLabel.textColor = [UIColor whiteColor];
            [self.contentView addSubview:self.priceLabel];
            self.priceLabel.textColor = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
}
@end
