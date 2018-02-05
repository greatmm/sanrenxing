//
//  OrderHintItem.h
//  MinSu
//
//  Created by 竹叶 on 2018/1/30.
//

#import <Foundation/Foundation.h>

@interface OrderHintItem : NSObject
@property(nonatomic,strong) NSString * hintTitle;//标题
@property(nonatomic,strong) NSString * dateStr;//日期str
@property(nonatomic,strong) NSString * contentStr;//描述
@property(nonatomic,strong) NSString * timeStr;//时间
+ (instancetype)itemWithDic:(NSDictionary *)dict;
@end
