//
//  NSDate+FLYExtension.m
//  FLYKit
//
//  Created by fly on 2021/8/27.
//

#import "NSDate+FLYExtension.h"

@implementation NSDate (FLYExtension)


-(BOOL)isThisYear
{
    //获取日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    
    //获取调用者的年份  （日历组件对象）
    NSDateComponents * creatCmp = [calendar components:NSCalendarUnitYear fromDate:self];
    
    
    //获取当前时间
    NSDate * currentDate = [NSDate date];
    //获取当前时间的年份 （日历组件对象）
    NSDateComponents * currentDateCmp = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    
    
    return creatCmp.year == currentDateCmp.year;
}

- (BOOL)isThisToday
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:self];
}

- (BOOL)isThisYesterday
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar isDateInYesterday:self];
}

- (BOOL)isThisTomorrow
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar isDateInTomorrow:self];
}

- (BOOL)isWeekend
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //判断是否在周末
    return [calendar isDateInWeekend:self];
}


/// 获取当前时间戳（精确到秒，如果需要毫秒，外界自己拼接三个0）
+ (NSString *)currentTimeStamp
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString * timeStampString = [NSString stringWithFormat:@"%ld", (long)timeStamp];
    return timeStampString;
}


/// 获取一段时间后(前)的日期 （比如：5天后、两小时前）
/// @param date 基于哪个date的前后
/// @param unitFlag 时间单位
/// @param number 数量
+ (NSDate *)getDateAfter:(NSDate *)date unitFlag:(FLYCalendarUnit)unitFlag number:(NSInteger)number
{
    NSTimeInterval second = 0;
    
    switch (unitFlag)
    {
        //年
        case FLYCalendarUnitYear:
            second = 60 * 60 * 24 * 365;
            break;
            
        //月
        case FLYCalendarUnitMonth:
            second = 60 * 60 * 24 * 30;
            break;
        //日
        case FLYCalendarUnitDay:
            second = 60 * 60 * 24;
            break;
        
        //小时
        case FLYCalendarUnitHour:
            second = 60 * 60;
            break;
        
        //分钟
        case FLYCalendarUnitMinute:
            second = 60;
            break;
        
        //秒
        case FLYCalendarUnitSecond:
            second = 1;
            break;
            
        default:
            break;
    }
    
    NSDate * resultDate = [NSDate dateWithTimeInterval:(second * number) sinceDate:date];
    
    return resultDate;
}


/// 计算两个日期相隔多久 （第二个date - 第一个date，如果第二个比第一个小，结果为负数）
/// @param date 日期1
/// @param targetDate 日期2
/// @param unitFlag 时间单位
+ (NSInteger)calculateApartWithDate:(NSDate *)date targetDate:(NSDate *)targetDate unitFlag:(FLYCalendarUnit)unitFlag
{
    //获取日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //计算两个date相隔多久
    NSDateComponents * dateComponents = [calendar components:((NSCalendarUnit)unitFlag) fromDate:date toDate:targetDate options:NSCalendarWrapComponents];
        
    NSInteger result = 0;
    
    switch (unitFlag)
    {
        //年
        case FLYCalendarUnitYear:
            result = dateComponents.year;
            break;
            
        //月
        case FLYCalendarUnitMonth:
            result = dateComponents.month;
            break;
        //日
        case FLYCalendarUnitDay:
            result = dateComponents.day;
            break;
        
        //小时
        case FLYCalendarUnitHour:
            result = dateComponents.hour;
            break;
        
        //分钟
        case FLYCalendarUnitMinute:
            result = dateComponents.minute;
            break;
        
        //秒
        case FLYCalendarUnitSecond:
            result = dateComponents.second;
            break;
            
        default:
            break;
    }
    
    return result;
}


/// 比较两个日期的大小
/// @param date 日期1
/// @param targetDate 日期2
/// @param unitFlag 时间单位 (例：如果单位是day，那么只会比较年月日，时分秒不相同也没关系)
+ (NSComparisonResult)compareDate:(NSDate *)date targetDate:(NSDate *)targetDate unitFlag:(FLYCalendarUnit)unitFlag
{
    NSString * dateFormat = @"";
    
    switch (unitFlag)
    {
        case FLYCalendarUnitYear:
            dateFormat = @"yyyy";
            break;
            
        case FLYCalendarUnitMonth:
            dateFormat = @"yyyy-MM";
            break;
        
        case FLYCalendarUnitDay:
            dateFormat = @"yyyy-MM-dd";
            break;
            
        case FLYCalendarUnitHour:
            dateFormat = @"yyyy-MM-dd HH";
            break;
            
        case FLYCalendarUnitMinute:
            dateFormat = @"yyyy-MM-dd HH:mm";
            break;
            
        case FLYCalendarUnitSecond:
            dateFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
            
        default:
            break;
    }
    
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    //date转成指定格式的字符串时间（为了去掉不需要的精度，比如去掉时分秒）
    NSString * dateString1 = [dateFormatter stringFromDate:date];
    NSString * dateString2 = [dateFormatter stringFromDate:targetDate];
    
    //字符串时间转回date
    NSDate * date1 = [dateFormatter dateFromString:dateString1];
    NSDate * date2 = [dateFormatter dateFromString:dateString2];
    
   
    if ([date1 compare:date2] == NSOrderedDescending)
    {
        return 1; // 大于
    }
    else if ([date1 compare:date2] == NSOrderedAscending)
    {
        return -1; // 小于
    }
    else
    {
        return 0; // 等于
    }
}


/// 传入的时间距离现在过了多久 (刚刚、n分钟前、n小时前、昨天.....)
/// @param date 过去的时间
+ (NSString *)timeString:(NSDate *)date
{
    /*
        业务逻辑是距离现在的时间越久远，显示的越详细
     
        今年
            今天
            > 1小时  n小时前
            > 1分钟  n分钟前
            < 1分钟  刚刚
     
            昨天
            昨天 09:09
     
            昨天之前
            2-20 09:09:20
     
     
        非今年
        2018-2-22 09:09:20
     */
 
    
    
    NSString * string = @"";
    
    //拿发帖时间和当前时间对比
    
    //今年
    if ( [date isThisYear] )
    {
        //今天
        if ( [date isThisToday] )
        {
            NSInteger hour = [self calculateApartWithDate:date targetDate:[NSDate date] unitFlag:(FLYCalendarUnitHour)];
            NSInteger minute = [self calculateApartWithDate:date targetDate:[NSDate date] unitFlag:(FLYCalendarUnitMinute)];
            
            if ( hour >= 1 )
            {
                string = [NSString stringWithFormat:@"%ld小时前", (long)hour];
            }
            else if ( minute >=1 )
            {
                string = [NSString stringWithFormat:@"%ld分钟前", (long)minute];
            }
            else
            {
                string = @"刚刚";
            }
        }
        //昨天
        else if ( [date isThisYesterday] )
        {
            NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"昨天 HH:mm";
            string = [fmt stringFromDate:date];
        }
        //昨天之前
        else
        {
            NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            string = [fmt stringFromDate:date];
        }
    }
    else//非今年
    {
        NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        string = [fmt stringFromDate:date];
    }
    
    return string;
}

@end
