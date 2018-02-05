//
//  CitySearchResultTableViewController.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/15.
//

#import "KKBaseTableViewController.h"

@interface CitySearchResultTableViewController : KKBaseTableViewController
@property(nonatomic,strong)void(^finishedSearchBlock)(NSDictionary *dict);
@end
