//
//  LocationTableViewController.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/12.
//

#import "KKBaseTableViewController.h"

@interface LocationTableViewController : KKBaseTableViewController
@property (nonatomic,copy) NSString * city;
@property (nonatomic,strong) void(^backBlock)(NSDictionary * dict);
@end
