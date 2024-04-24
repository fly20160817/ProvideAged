//
//  FLYMessageModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/17.
//

#import "FLYMessageModel.h"

@implementation FLYMessageModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
