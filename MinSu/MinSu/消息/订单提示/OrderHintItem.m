//
//  OrderHintItem.m
//  MinSu
//
//  Created by 竹叶 on 2018/1/30.
//

#import "OrderHintItem.h"

@implementation OrderHintItem
+ (instancetype)itemWithDic:(NSDictionary *)dict
{
    OrderHintItem * item = [OrderHintItem new];
    NSString * contentStr = [NSString stringWithFormat:@"%@ %@ 入住%@ %@晚,总价人民币 %@;",dict[@"name"],dict[@"check_time"],dict[@"title"],dict[@"days"],dict[@"total_price"]];
    NSString * str = @"  ";
    NSNumber * type = dict[@"type"];
    if (type.integerValue == 1) {
        item.hintTitle = @"预定成功";
        str = [NSString stringWithFormat:@"地址:%@%@%@%@;联系电话:%@",dict[@"province"],dict[@"city"],dict[@"district"],dict[@"town"],dict[@"fd_mobile"]];
    } else if (type.integerValue == 2) {
        item.hintTitle = @"取消成功";
        str = @"已成功取消您的预定,感谢您的支持,期待着您再次使用农家三人行.";
    } else {
        item.hintTitle = @"  ";
    }
    item.contentStr = [NSString stringWithFormat:@"%@\n%@",contentStr,str];
    if (dict[@"time"] && [dict[@"time"] isKindOfClass:[NSString class]]) {
        item.timeStr = dict[@"time"];
    } else {
        item.timeStr = @"";
    }
    if (dict[@"check_time"] && [dict[@"check_time"] isKindOfClass:[NSString class]]) {
        item.dateStr = dict[@"check_time"];
    } else {
        item.dateStr = @"";
    }
    return item;
}
@end
