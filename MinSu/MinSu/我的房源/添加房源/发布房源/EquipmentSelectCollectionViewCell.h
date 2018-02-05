//
//  EquipmentSelectCollectionViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/29.
//

#import <UIKit/UIKit.h>

@interface EquipmentSelectCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) NSDictionary * dic;
@property(nonatomic,assign) BOOL select;

- (void)assignWithDic:(NSDictionary *)dic;

@end
