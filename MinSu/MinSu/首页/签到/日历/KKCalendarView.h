//
//  KKCalendarView.h
//  日历
//
//  Created by 竹叶 on 2017/12/7.
//  Copyright © 2017年 竹叶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKCalendarView : UIView
@property (nonatomic,strong) NSDate * date;

@property (nonatomic,strong) NSArray * signInDateArr;
@property (nonatomic,assign) BOOL isHouse;//是否是房屋详情
@property (nonatomic,strong) NSString * price;//每日价格
@property (nonatomic,strong) void(^selectDateBlock)(NSArray * dateArr);//选择入住离开日期,入住几天
+ (instancetype)shareCalendarView;

@end
