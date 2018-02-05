//
//  KKUtils.m
//  日历控件
//
//  Created by GKK on 2017/10/26.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "KKUtils.h"

@implementation KKUtils

+ (NSCalendar *)localCalendar
{
    static NSCalendar *Instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Instance = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return Instance;
}
//获取下个月的日期
+ (NSDate *)nextMonthWithDate:(NSDate *)date
{
    return [self getPriousorLaterDateFromDate:date withMonth:1];
}
//获取上个月的日期
+ (NSDate *)preMonthWithDate:(NSDate *)date
{
   return [self getPriousorLaterDateFromDate:date withMonth:-1];
}
+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year
{
    return [self dateWithMonth:month day:1 year:year];
}

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    return [self dateFromDateComponents:comps];
}
+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components
{
     return [[self localCalendar] dateFromComponents:components];
}

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year
{
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}
+ (NSUInteger)daysInMonthOfDate:(NSDate *)date
{
   return [[self localCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year
{
    NSDate *date = [self dateWithMonth:month year:year];
    return [[self localCalendar] component:NSCalendarUnitWeekday fromDate:date];
}
+ (NSUInteger)firstWeekdayInMonthOfDate:(NSDate *)date
{
   return [[self localCalendar] component:NSCalendarUnitWeekday fromDate:date];
}

+ (NSString *)stringOfWeekdayInEnglish:(NSUInteger)weekday
{
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday: %lu", (unsigned long) weekday);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat"];
    });
    return Strings[weekday - 1];
}
+ (NSString *)stringOfWeekdayInChinese:(NSUInteger)weekday
{
    NSAssert(weekday >= 1 && weekday <= 7, @"Invalid weekday: %lu", (unsigned long) weekday);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    });
    return Strings[weekday - 1];
}
+ (NSString *)stringOfMonthInEnglish:(NSUInteger)month
{
    NSAssert(month >= 1 && month <= 12, @"Invalid month: %lu", (unsigned long) month);
    static NSArray *Strings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Strings = @[@"Jan.", @"Feb.", @"Mar.", @"Apr.", @"May.", @"Jun.", @"Jul.", @"Aug.", @"Sept.", @"Oct.", @"Nov.", @"Dec."];
    });
    return Strings[month - 1];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date
{
    return [[self localCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
}
+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents
{
    NSDateComponents *todayComps = [self dateComponentsFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    return todayComps.year == dateComponents.year && todayComps.month == dateComponents.month && todayComps.day == dateComponents.day;
}
+ (BOOL)isTodayWithDate:(NSDate *)date
{
    NSDateComponents *comps1 = [self dateComponentsFromDate:date];
    NSDateComponents *comps2 = [self dateComponentsFromDate:[NSDate date]];
    return comps1.year == comps2.year && comps1.month == comps2.month && comps1.day== comps2.day;
}
+ (BOOL)isSameMonthAndSameYearDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    NSDateComponents *comps1 = [self dateComponentsFromDate:date1];
    NSDateComponents *comps2 = [self dateComponentsFromDate:date2];
    return comps1.year == comps2.year && comps1.month == comps2.month;
}
+ (NSUInteger)daysBetweenDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    int days=((int)time)/(3600*24);
    return days;
}

+ (NSInteger)getYearWithDate:(NSDate *)date
{
     NSDateComponents *comps = [self dateComponentsFromDate:date];
    return comps.year;
}
+ (NSInteger)getMonthWithDate:(NSDate *)date
{
    NSDateComponents *comps = [self dateComponentsFromDate:date];
    return comps.month;
}
//获取date前后几个月的日期，month为正表示之后，为负表示之前
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [self localCalendar];
    NSDate *newDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return newDate;
}
//
+ (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
   return [dateFormatter stringFromDate:date];
}
+ (NSDate *)stringToDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateStr];
}
+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
+ (NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateStr];
}
@end
