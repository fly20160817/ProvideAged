//
//  FLYUserModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYUserModel.h"

@implementation FLYUserModel

@end


@implementation FLYUserData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id"
             };
}

@end
