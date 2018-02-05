//
//  KKUtils.h
//  日历控件
//
//  Created by GKK on 2017/10/26.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtils : NSObject

+ (NSCalendar *)localCalendar;

//获取下个月的日期
+ (NSDate *)nextMonthWithDate:(NSDate *)date;
//获取上个月的日期
+ (NSDate *)preMonthWithDate:(NSDate *)date;

+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year;

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;

+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components;


//获取当前月的天数
+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year;

+ (NSUInteger)daysInMonthOfDate:(NSDate *)date;

//第一天是周几
+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year;

+ (NSUInteger)firstWeekdayInMonthOfDate:(NSDate *)date;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents;
//是否同年同月
+ (BOOL)isSameMonthAndSameYearDate1:(NSDate *)date1 date2:(NSDate *)date2;
+ (BOOL)isTodayWithDate:(NSDate *)date;//是否是今天
+ (NSUInteger)daysBetweenDate1:(NSDate *)date1 date2:(NSDate *)date2;//计算两个日期之间的天数
+ (NSInteger)getYearWithDate:(NSDate *)date;
+ (NSInteger)getMonthWithDate:(NSDate *)date;
//获取年月
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSDate *)stringToDate:(NSString *)dateStr;
+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format;//日期根据格式转换成字符串
+ (NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)format;//字符串根据格式转换成日期
@end
