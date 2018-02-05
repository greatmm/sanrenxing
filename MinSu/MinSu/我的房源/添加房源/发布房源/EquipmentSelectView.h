//
//  EquipmentSelectView.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import <UIKit/UIKit.h>

@interface EquipmentSelectView : UIView
@property(nonatomic,strong)NSMutableArray * selDataArr;
@property(nonatomic,strong)void(^selBlock)(NSMutableArray *arr);
+ (instancetype)shareEquView;
- (void)show;
- (void)dismiss;
@end
