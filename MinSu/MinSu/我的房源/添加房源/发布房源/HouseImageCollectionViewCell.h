//
//  HouseImageCollectionViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/2.
//

#import <UIKit/UIKit.h>

@interface HouseImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,strong) void(^delBlock)(void);
@end
