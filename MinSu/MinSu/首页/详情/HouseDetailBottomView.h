//
//  HouseDetailBottomView.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/7.
//

#import <UIKit/UIKit.h>

@interface HouseDetailBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong,nonatomic) void(^bookBlock)(void);
@end
