//
//  NSArray+FLYUnicode.m
//  02-解决数组输出汉字的问题
//
//  Created by fly on 2018/8/7.
//  Copyright © 2018年 fly. All rights reserved.
//

#import "NSArray+FLYUnicode.h"

@implementation NSArray (FLYUnicode)

//description是NSObject的属性,所以所有的类都拥有这个属性
//重新description的get方法
//-(NSString *)description
//{
//
//}


//Xcode8以后，字典和数组的descriptionWithLocale都不再被调用。后来使用- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level来取代
//返回表示数组内容的字符串
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * mStr = [NSMutableString string];
    
    //第一行是小括号,然后换行
    [mStr appendString:@"(\r\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //再拼接每个元素,每个元素后换行  (/t代表tab空格)
        [mStr appendFormat:@"\t%@,\r\n", obj];
    }];
    
    //所有元素拼接完成后再加一个小括号
    [mStr appendString:@")"];
    
    //最后一个拼接多了一个逗号,查找最后一个逗号然后删除
    NSRange range = [mStr rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
    {
        [mStr deleteCharactersInRange:range];
    }
    
    return mStr.copy;
}


@end





