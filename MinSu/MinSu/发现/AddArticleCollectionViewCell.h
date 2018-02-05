//
//  AddArticleCollectionViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/31.
//

#import <UIKit/UIKit.h>

@interface AddArticleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) void(^delBlock)(void);
@end
