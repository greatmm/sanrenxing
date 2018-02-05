//
//  KKHouseShowTableViewCell.h
//  minsu
//
//  Created by xhkj on 2017/12/4.
//  Copyright © 2017年 郑州竹叶网络科技有限公司. All rights reserved.
//

#import "KKBaseTableViewCell.h"

@interface KKHouseShowTableViewCell : KKBaseTableViewCell
@property(nonatomic,assign) BOOL isLike;
@property(nonatomic,strong) void(^collectBlock)(void);
- (void)assignWithDic:(NSDictionary *)dic;
@end
