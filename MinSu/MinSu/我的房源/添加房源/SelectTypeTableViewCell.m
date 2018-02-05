//
//  SelectTypeTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/28.
//

#import "SelectTypeTableViewCell.h"


@interface SelectTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *selImageView;

@end
@implementation SelectTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsSel:(BOOL)isSel
{
    if (_isSel == isSel) {
        return;
    }
    _isSel = isSel;
    if (isSel) {
        self.selectLabel.textColor = [UIColor colorWithRed:254/255.0 green:150/255.0 blue:0 alpha:1];
        self.selImageView.hidden = NO;
    } else {
        self.selectLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.selImageView.hidden = YES;
    }
}


@end
