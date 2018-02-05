//
//  KKInputTableViewCell.m
//  MinSu
//
//  Created by 竹叶 on 2017/12/8.
//

#import "KKInputTableViewCell.h"

@interface KKInputTableViewCell()<UITextFieldDelegate>

@end

@implementation KKInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textField addTarget:self action:@selector(changeWord) forControlEvents:UIControlEventEditingChanged];
}

- (void)changeWord
{
    if (self.textBlock) {
        NSString * text = self.textField.text;
        self.textBlock(text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
