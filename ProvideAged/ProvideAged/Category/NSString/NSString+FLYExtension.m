//
//  NSString+FLYExtension.m
//  FLYKit
//
//  Created by fly on 2021/10/15.
//

#import "NSString+FLYExtension.h"

@implementation NSString (FLYExtension)

/// 数组、字典转json字符串
/// @param object 数组或字典
+ (NSString *)objectToJson:(id)object
{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

/// json字符串转数组、字典
/// @param jsonString json字符串
/// @return id 数组、字典
+ (id)jsonToObject:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    return dic;
}

@end
