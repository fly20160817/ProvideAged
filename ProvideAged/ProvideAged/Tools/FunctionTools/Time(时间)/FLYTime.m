//
//  FLYTime.m
//  Elevator
//
//  Created by fly on 2018/11/20.
//  Copyright © 2018年 fly. All rights reserved.
//

#import "FLYTime.h"

#define kMilliSecond 1000 //如果时间戳是毫秒类型写1000  秒写1

@implementation FLYTime

//date转字符串
+ (NSString *)dateToStringWithDate:(NSDate *)date dateFormat:(FLYDateFormatType)FLYDateFormatType
{
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:[self dateFormat:FLYDateFormatType]];
    NSString * string=[dateFormat stringFromDate:date];
    return string;
}

//date转时间戳
+ (NSString *)dateToTimeStamp:(NSDate *)date
{
    NSString * timeStamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970] * kMilliSecond];
    return timeStamp;
}



//字符串转date
+ (NSDate *)stringToDateWithString:(NSString *)string dateFormat:(FLYDateFormatType)FLYDateFormatType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self dateFormat:FLYDateFormatType]];
    NSDate * date = [dateFormatter dateFromString:string];
    return date;
}

//字符串转时间戳
+ (NSString *)stringToTimeStampWithString:(NSString *)string dateFormat:(FLYDateFormatType)FLYDateFormatType
{
    NSDate * date = [self stringToDateWithString:string dateFormat:FLYDateFormatType];
    NSString * timeStamp = [self dateToTimeStamp:date];
    return timeStamp;
}


//时间戳转date
+ (NSDate *)timeStampToDate:(NSString *)timeStamp
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue] / kMilliSecond ];
    return date;
}

//时间戳转字符串
+ (NSString *)timeStampToStringWithTimeStamp:(NSString *)timeStamp dateFormat:(FLYDateFormatType)FLYDateFormatType
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue] / kMilliSecond];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self dateFormat:FLYDateFormatType]];
    NSString * string = [formatter stringFromDate:date];
    return string;
}




//根据时间格式type，获取相对应的时间格式字符串
+ (NSString *)dateFormat:(FLYDateFormatType)FLYDateFormatType
{
    NSString * dateFormat = @"";
    switch (FLYDateFormatType)
    {
        case FLYDateFormatTypeYMDHMS:
            dateFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
            
        case FLYDateFormatTypeYMDHM:
            dateFormat = @"yyyy-MM-dd HH:mm";
            break;
            
        case FLYDateFormatTypeYMD:
            dateFormat = @"yyyy-MM-dd";
            break;
            
        case FLYDateFormatTypeZYMDHMS:
            dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
            break;
            
        case FLYDateFormatTypeZYMDHM:
            dateFormat = @"yyyy年MM月dd日 HH:mm";
            break;
            
        case FLYDateFormatTypeZYMD:
            dateFormat = @"yyyy年MM月dd日";
            break;
            
        case FLYDateFormatTypeHMS:
            dateFormat = @"HH:mm:ss";
            break;
            
        case FLYDateFormatTypeHM:
            dateFormat = @"HH:mm";
            break;
            
        default:
            break;
    }
    
    return dateFormat;
}

@end
