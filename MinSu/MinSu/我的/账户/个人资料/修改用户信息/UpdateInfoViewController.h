//
//  UpdateInfoViewController.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/26.
//

#import "KKBaseViewController.h"

@interface UpdateInfoViewController : KKBaseViewController

@property(nonatomic,assign) NSInteger style;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSString * content;
@end
