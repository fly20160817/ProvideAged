//
//  FLYSysDicModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYSysDicModel.h"

@implementation FLYSysDicModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
