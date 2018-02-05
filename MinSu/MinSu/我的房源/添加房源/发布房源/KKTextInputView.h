//
//  KKTextInputView.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/4.
//

#import <UIKit/UIKit.h>

@interface KKTextInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property  (nonatomic,strong) void(^ensureBlock)(NSString * text);
+ (instancetype)shareTextInputView;
@end
