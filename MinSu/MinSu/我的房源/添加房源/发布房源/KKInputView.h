//
//  KKInputView.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import <UIKit/UIKit.h>

@interface KKInputView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property  (nonatomic,strong) void(^ensureBlock)(NSString * text);
+ (instancetype)shareInputView;
@end
