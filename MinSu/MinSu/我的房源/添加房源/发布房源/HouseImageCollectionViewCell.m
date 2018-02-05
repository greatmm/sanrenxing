//
//  HouseImageCollectionViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/2.
//

#import "HouseImageCollectionViewCell.h"

@implementation HouseImageCollectionViewCell
- (IBAction)delImage:(id)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
