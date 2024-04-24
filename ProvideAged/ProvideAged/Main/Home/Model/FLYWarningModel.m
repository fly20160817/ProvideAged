//
//  FLYWarningModel.m
//  ProvideAged
//
//  Created by fly on 2021/9/16.
//

#import "FLYWarningModel.h"

@implementation FLYWarningModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idField" : @"id",
             @"descriptionField" : @"description",
             };
}

@end
