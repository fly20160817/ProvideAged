//
//  NSDictionary+FLYUnicode.m
//  FLYKit
//
//  Created by fly on 2021/8/27.
//

#import "NSDictionary+FLYUnicode.h"

@implementation NSDictionary (FLYUnicode)

//Xcode8以后，字典和数组的descriptionWithLocale都不再被调用。后来使用- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level来取代
//返回表示字典内容的字符串
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * stringM=[NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@ = %@;\n",key,obj];
    }];
    [stringM appendString:@"}\n"];
    return stringM;
}

@end
