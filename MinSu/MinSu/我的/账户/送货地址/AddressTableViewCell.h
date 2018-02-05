//
//  AddressTableViewCell.h
//  MinSu
//
//  Created by 竹叶 on 2017/12/6.
//

#import "KKBaseTableViewCell.h"

@interface AddressTableViewCell : KKBaseTableViewCell
@property(nonatomic,strong) void(^delBlock)(void);
@property(nonatomic,strong) void(^editBlock)(void);
@property(nonatomic,strong) void(^morenBlock)(void);
- (void)assignWithDic:(NSDictionary *)dic;
@end
