//
//  AddArticleCollectionViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/31.
//

#import "AddArticleCollectionViewCell.h"

@implementation AddArticleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)removeImage:(id)sender {
    if (self.delBlock) {
        self.delBlock();
    }
}

@end
