//
//  SearchCityView.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/15.
//

#import <UIKit/UIKit.h>

@interface SearchCityView : UIView
@property(nonatomic,strong) NSArray * hotCityArr;
@property(nonatomic,strong) NSArray * historyCityArr;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic,strong)void(^clickBtnBlock)(NSDictionary *dic);
@end
