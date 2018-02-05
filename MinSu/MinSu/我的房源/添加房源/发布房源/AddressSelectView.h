//
//  AddressSelectView.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import <UIKit/UIKit.h>

@interface AddressSelectView : UIView

@property(nonatomic,copy)NSArray * cityArr;//省数组
@property(nonatomic,strong)NSDictionary * pDic;//选中的省
@property(nonatomic,strong)NSDictionary *cDic;//选中的市
@property(nonatomic,strong)NSDictionary *  qDic;//选中的区
@property(nonatomic,strong)NSDictionary *sDic;//选中的区/街道
@property(nonatomic,strong)void(^ensureBlock)(NSString * addressStr);
+ (instancetype)shareAddressView;
- (void)show;
@end
