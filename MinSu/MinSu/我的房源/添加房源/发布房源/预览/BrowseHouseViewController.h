//
//  BrowseHouseViewController.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/2.
//

#import "KKBaseViewController.h"

@interface BrowseHouseViewController : KKBaseViewController
@property(nonatomic,strong)NSString * house_title;
@property(nonatomic,strong)NSString * house_des;
@property(nonatomic,strong)NSString * price;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSArray * imageArr;
@property(nonatomic,strong)NSArray * equArr;
@property(nonatomic,strong)NSString * house_id;
@end
