//
//  FLYMemberModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/18.
//

#import "FLYMemberModel.h"

@implementation FLYMemberModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id"
             };
}

@end
