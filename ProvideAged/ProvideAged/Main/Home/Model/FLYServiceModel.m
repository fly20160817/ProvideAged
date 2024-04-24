//
//  FLYServiceModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYServiceModel.h"

@implementation FLYServiceModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
